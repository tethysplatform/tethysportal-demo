{% set TETHYS_PERSIST = salt['environ.get']('TETHYS_PERSIST') %}
{% set TETHYS_HOME = salt['environ.get']('TETHYS_HOME') %}

{% set OPENCAGEDATA_API_KEY = salt['environ.get']('OPENCAGEDATA_API_KEY') %}

{% set GEOSERVER_SERVICE_NAME = salt['environ.get']('GS_SERVICE_NAME') %}

Set_Layout_Showcase_Geocode_Api_Key:
  cmd.run:
    - name: "tethys app_settings set layout_showcase geocode_api_key {{ OPENCAGEDATA_API_KEY }}"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/layout_showcase_setup_complete" ];"

Link_Layout_Showcase_Geoserver:
  cmd.run:
    - name: "tethys link spatial:{{ GEOSERVER_SERVICE_NAME }} layout_showcase:ds_spatial:primary_geoserver"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/layout_showcase_setup_complete" ];"

Add_Workspace_File:
  cmd.run:
    - name: |
        mkdir -p /var/lib/tethys_persist/workspaces/layout_showcase/app_workspace/map_layout && \
        cp /usr/lib/tethys/apps/tethysapp-layout_showcase/tethysapp/layout_showcase/workspaces/app_workspace/map_layout/us-states.json \
        /var/lib/tethys_persist/workspaces/layout_showcase/app_workspace/map_layout/us-states.json
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f \"/var/lib/tethys_persist/layout_showcase_setup_complete\" ];"

Flag_Layout_Showcase_Setup_Complete:
  cmd.run:
    - name: touch {{ TETHYS_PERSIST }}/layout_showcase_setup_complete
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/layout_showcase_setup_complete" ];"