{% set POSTGIS_SERVICE_NAME = salt['environ.get']('PERSISTENT_SERVICE_NAME') %}
{% set TETHYS_PERSIST = salt['environ.get']('TETHYS_PERSIST') %}
{% set TETHYS_HOME = salt['environ.get']('TETHYS_HOME') %}

Link_WildAtlas_PostGIS_Service:
  cmd.run:
    - name: "tethys link persistent:{{ POSTGIS_SERVICE_NAME }} wildatlas:ps_database:primary_db"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/wildatlas_setup_complete" ];"

Flag_WildAtlas_Setup_Complete:
  cmd.run:
    - name: touch {{ TETHYS_PERSIST }}/wildatlas_setup_complete
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/wildatlas_setup_complete" ];"