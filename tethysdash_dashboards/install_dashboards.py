import os
import uuid
import json
import shutil
from django.contrib.auth.models import User
from tethysapp.tethysdash.model import Dashboard, add_new_dashboard, update_named_dashboard
from tethysapp.tethysdash.app import App as app

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
                pass

    if "args" in grid_item and "args_string" not in grid_item:
        grid_item["args_string"] = convert_json_to_string(grid_item["args"])
        grid_item.pop("args", None)
    elif "args_string" in grid_item:
        grid_item["args_string"] = convert_json_to_string(grid_item["args_string"])

    if "metadata" in grid_item and "metadata_string" not in grid_item:
        grid_item["metadata_string"] =  convert_json_to_string(grid_item["metadata"])
        grid_item.pop("metadata", None)
    elif "metadata_string" in grid_item:
        grid_item["metadata_string"] = convert_json_to_string(grid_item["metadata_string"])

    return grid_item

def cleanup_grid_items(grid_items):
    return [cleanup_grid_item(grid_item) for grid_item in (grid_items or [])]

Session = app.get_persistent_store_database("primary_db", as_sessionmaker=True)
session = Session()

try:
    dir_path = os.getcwd()
    dashboard_files = [f for f in os.listdir(dir_path) if f.endswith(".json")]

    admin_user = User.objects.filter(is_superuser=True).first()
    if not admin_user:
        raise RuntimeError("No superuser found; cannot assign dashboard owner.")

    existing_names = {name for (name,) in session.query(Dashboard.name).all()}

    for dashboard_file in dashboard_files:
        dashboard_path = os.path.join(dir_path, dashboard_file)
        with open(dashboard_path, "r", encoding="utf-8") as f:
            json_contents = json.load(f)

        name = json_contents.get("name")
        if not name:
            continue

        if "gridItems" in json_contents:
            json_contents["gridItems"] = cleanup_grid_items(json_contents["gridItems"])

        if name in existing_names:
            existing_dashboard = session.query(Dashboard).filter(Dashboard.name == name).first()
            owner_username = getattr(existing_dashboard.owner, "username", str(existing_dashboard.owner))
            if owner_username == admin_user.username:
                json_contents.pop("image", None)
                update_named_dashboard(
                    admin_user.username,
                    existing_dashboard.id,
                    json_contents,
                )

        else:
            new_id = str(uuid.uuid4())
            add_new_dashboard(
                admin_user.username,
                new_id,
                json_contents["name"],
                json_contents.get("description", ""),
                json_contents.get("notes", ""),
                json_contents.get("accessGroups", []),
                json_contents.get("unrestrictedPlacement", False),
                json_contents.get("gridItems", []),
            )

            app_media_path = app.get_app_media().path
            shutil.copyfile(
                os.path.join(os.getenv("DEFAULT_DASHBOARD_IMAGE_PATH")),
                os.path.join(app_media_path, f"{new_id}.png")
            )
            
finally:
    session.close()
