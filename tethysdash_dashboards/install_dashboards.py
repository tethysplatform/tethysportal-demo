import os
import uuid
import json
from datetime import datetime, timezone

from django.contrib.auth.models import User

from tethysapp.tethysdash.model import Dashboard, GridItem, add_new_dashboard, update_named_dashboard, add_new_grid_item, delete_grid_item
from tethysapp.tethysdash.app import App as app

Session = app.get_persistent_store_database("primary_db", as_sessionmaker=True)
session = Session()

dir = os.getcwd()
dashboard_files = os.listdir(dir)
dashboard_files = [f for f in dashboard_files if f.endswith('.json')]

admin_user = User.objects.filter(is_superuser=True).first().username

existing_dashboard_names = session.query(Dashboard.name).all()

for dashboard_file in dashboard_files:
    dashboard_path = os.path.join(dir, dashboard_file)
    json_contents = json.loads(open(dashboard_path, 'r').read())
    if json_contents['name'] in existing_dashboard_names:
        existing_dashboard = session.query(Dashboard).filter(Dashboard.name == json_contents['name']).first()
        if existing_dashboard.owner == admin_user:
            json_contents.pop('image', None)
            print(f"Updating existing dashboard: {json_contents['name']}")
            update_named_dashboard(admin_user, existing_dashboard.id, json_contents)
        else:
            print(f"Dashboard {json_contents['name']} already exists and is owned by another user. Skipping installation.")
            continue

    else:
        # Install the dashboard
        print(f"Installing new dashboard: {json_contents['name']}")
        add_new_dashboard(
            admin_user,
            str(uuid.uuid4()),
            json_contents['name'],
            json_contents['description'],
            json_contents['notes'],
            json_contents['accessGroups'],
            json_contents['unrestrictedPlacement'],
            json_contents['gridItems'],
        )

session.close()
