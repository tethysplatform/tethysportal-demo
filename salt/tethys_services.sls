{% set CONDA_HOME = salt['environ.get']('CONDA_HOME') %}
{% set TETHYS_PERSIST = salt['environ.get']('TETHYS_PERSIST') %}
{% set TETHYS_DB_SUPERUSER = salt['environ.get']('TETHYS_DB_SUPERUSER') %}
{% set TETHYS_DB_SUPERUSER_PASS = salt['environ.get']('TETHYS_DB_SUPERUSER_PASS') %}
{% set TETHYS_DB_HOST = salt['environ.get']('TETHYS_DB_HOST') %}
{% set TETHYS_DB_PORT = salt['environ.get']('TETHYS_DB_PORT') %}
{% set POSTGIS_SERVICE_NAME = 'tethys_postgis' %}
{% set POSTGIS_SERVICE_URL = TETHYS_DB_SUPERUSER + ':' + TETHYS_DB_SUPERUSER_PASS + '@' + TETHYS_DB_HOST + ':' + TETHYS_DB_PORT %}

{% set GEOSERVER_SERVICE_USERNAME = salt['environ.get']('GS_USERNAME') %}
{% set GEOSERVER_SERVICE_PASSWORD = salt['environ.get']('GS_PASSWORD') %}
{% set GEOSERVER_SERVICE_NAME = salt['environ.get']('GS_SERVICE_NAME') %}
{% set GEOSERVER_SERVICE_HOST = salt['environ.get']('GS_SERVICE_HOST') %}
{% set GEOSERVER_SERVICE_PORT = salt['environ.get']('GS_SERVICE_PORT') %}
{% set GEOSERVER_SERVICE_PUBLIC_ENDPOINT = GEOSERVER_SERVICE_HOST + ':' + GEOSERVER_SERVICE_PORT + '/geoserver/rest' %}
{% set GEOSERVER_SERVICE_ENDPOINT = GEOSERVER_SERVICE_USERNAME + ':' + GEOSERVER_SERVICE_PASSWORD + '@' + GEOSERVER_SERVICE_PUBLIC_ENDPOINT %}

Create_PostGIS_Database_Service:
  cmd.run:
    - name: "tethys services create persistent -n {{ POSTGIS_SERVICE_NAME }} -c {{ POSTGIS_SERVICE_URL }}"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_services_complete" ];"

Create_Geoserver_Service:
  cmd.run:
    - name: "tethys services create spatial -n {{ GEOSERVER_SERVICE_NAME}} -t GeoServer -c {{ GEOSERVER_SERVICE_ENDPOINT }} -p {{ GEOSERVER_SERVICE_PUBLIC_ENDPOINT}}"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_services_complete" ];"

Flag_Tethys_Services_Setup_Complete:
  cmd.run:
    - name: touch {{ TETHYS_PERSIST }}/tethys_services_complete
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_services_complete" ];"


