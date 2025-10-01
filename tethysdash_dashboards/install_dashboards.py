import os
import uuid
import json
import shutil
import sys
import logging
from django.contrib.auth.models import User
from tethysapp.tethysdash.model import Dashboard, add_new_dashboard
from tethysapp.tethysdash.app import App as app

logging.basicConfig(level=logging.INFO, handlers=[logging.StreamHandler(sys.stdout)])
log = logging.getLogger("install_dashboards")

log.info(" Starting install_dashboards.py ")


def convert_json_to_string(contents):
    if isinstance(contents, (dict, list)):
        return json.dumps(contents, separators=(",", ":"), ensure_ascii=False)
    return contents if isinstance(contents, (str, type(None))) else str(contents)


def cleanup_grid_item(grid_item):
    grid_item = dict(grid_item)

    if "i" in grid_item and not isinstance(grid_item["i"], str):
        grid_item["i"] = str(grid_item["i"])

    for k in ("x", "y", "w", "h", "order"):
        if k in grid_item and grid_item[k] is not None:
            try:
                grid_item[k] = int(grid_item[k])
            except (TypeError, ValueError):
                log.warning(f"Could not convert {k} to int")

    if "args" in grid_item and "args_string" not in grid_item:
        grid_item["args_string"] = convert_json_to_string(grid_item["args"])
        grid_item.pop("args", None)
    elif "args_string" in grid_item:
        grid_item["args_string"] = convert_json_to_string(grid_item["args_string"])

    if "metadata" in grid_item and "metadata_string" not in grid_item:
        grid_item["metadata_string"] = convert_json_to_string(grid_item["metadata"])
        grid_item.pop("metadata", None)
    elif "metadata_string" in grid_item:
        grid_item["metadata_string"] = convert_json_to_string(
            grid_item["metadata_string"]
        )

    return grid_item


def cleanup_grid_items(grid_items):
    return [cleanup_grid_item(grid_item) for grid_item in (grid_items or [])]


Session = app.get_persistent_store_database("primary_db", as_sessionmaker=True)
session = Session()

try:
    dir_path = os.getcwd()

    dashboard_files = [f for f in os.listdir(dir_path) if f.endswith(".json")]
    log.info(f"Found dashboard files: {dashboard_files}")

    admin_user = User.objects.filter(is_superuser=True).first()
    if not admin_user:
        raise RuntimeError("No superuser found; cannot assign dashboard owner.")

    existing_names = {name for (name,) in session.query(Dashboard.name).all()}

    for dashboard_file in dashboard_files:
        log.info(f"Processing file: {dashboard_file}")
        dashboard_path = os.path.join(dir_path, dashboard_file)

        with open(dashboard_path, "r", encoding="utf-8") as f:
            json_contents = json.load(f)

        name = json_contents.get("name")
        if not name:
            log.warning(f"Skipping file {dashboard_file}: no 'name' field")
            continue

        if "gridItems" in json_contents:
            json_contents["gridItems"] = cleanup_grid_items(json_contents["gridItems"])

        if name in existing_names:
            log.info(f"Dashboard '{name}' already exists, deleting before re-adding")
            existing_dashboard = (
                session.query(Dashboard).filter(Dashboard.name == name).first()
            )
            session.delete(existing_dashboard)
            session.commit()

        new_uuid = str(uuid.uuid4())

        add_new_dashboard(
            admin_user,
            new_uuid,
            json_contents["name"],
            json_contents.get("description", ""),
            json_contents.get("notes", ""),
            json_contents.get("publicDashboard", False),
            json_contents.get("unrestrictedPlacement", False),
            json_contents.get("gridItems", []),
        )
        log.info(f"Dashboard '{name}' installed")

        app_media_path = app.get_app_media().path
        target_image_path = os.path.join(app_media_path, f"{new_uuid}.png")

        if json_contents.get("image"):
            image_path = os.path.join(dir_path, json_contents["image"])
            if os.path.exists(image_path):
                log.info(f"Using custom image at {image_path}")
                shutil.copyfile(image_path, target_image_path)
            else:
                default_img = os.getenv("DEFAULT_DASHBOARD_IMAGE_PATH")
                log.warning(
                    f"Custom image not found at {image_path}, using default image {default_img}"
                )
                shutil.copyfile(default_img, target_image_path)
        else:
            default_img = os.getenv("DEFAULT_DASHBOARD_IMAGE_PATH")
            log.info(f"No custom image defined, using default image {default_img}")
            shutil.copyfile(default_img, target_image_path)

    log.info("Completed dashboard installation successfully")

finally:
    session.close()
