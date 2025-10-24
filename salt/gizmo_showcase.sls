{% set TETHYS_PERSIST = salt['environ.get']('TETHYS_PERSIST') %}
{% set CESIUM_ION_TOKEN = salt['environ.get']('CESIUM_ION_TOKEN') %}
{% set GEOSERVER_SERVICE_NAME = salt['environ.get']('GS_SERVICE_NAME') %}

Set_Gizmo_Showcase_Cesium_Ion_Token:
  cmd.run:
    - name: "tethys app_settings set gizmo_showcase cesium_ion_token {{ CESIUM_ION_TOKEN }}"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/gizmo_showcase_setup_complete" ];"

Link_Gizmo_Showcase_Geoserver:
  cmd.run:
    - name: "tethys link spatial:{{ GEOSERVER_SERVICE_NAME }} gizmo_showcase:ds_spatial:primary_geoserver"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/gizmo_showcase_setup_complete" ];"

Flag_Gizmo_Showcase_Setup_Complete:
  cmd.run:
    - name: touch {{ TETHYS_PERSIST }}/gizmo_showcase_setup_complete
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/gizmo_showcase_setup_complete" ];"