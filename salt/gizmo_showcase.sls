{% set TETHYS_PERSIST = salt['environ.get']('TETHYS_PERSIST') %}
{% set CESIUM_ION_TOKEN = salt['environ.get']('CESIUM_ION_TOKEN') %}

{% set GEOSERVER_SERVICE_USERNAME = salt['environ.get']('GS_USERNAME') %}
{% set GEOSERVER_SERVICE_PASSWORD = salt['environ.get']('GS_PASSWORD') %}
{% set GEOSERVER_SERVICE_NAME = salt['environ.get']('GS_SERVICE_NAME') %}
{% set GEOSERVER_SERVICE_HOST = salt['environ.get']('GS_SERVICE_HOST') %}
{% set GEOSERVER_SERVICE_PORT = salt['environ.get']('GS_SERVICE_PORT') %}
{% set GEOSERVER_SERVICE_PUBLIC_ENDPOINT = GEOSERVER_SERVICE_HOST + ':' + GEOSERVER_SERVICE_PORT + '/geoserver/rest' %}
{% set GEOSERVER_SERVICE_ENDPOINT = GEOSERVER_SERVICE_USERNAME + ':' + GEOSERVER_SERVICE_PASSWORD + '@' + GEOSERVER_SERVICE_PUBLIC_ENDPOINT %}

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