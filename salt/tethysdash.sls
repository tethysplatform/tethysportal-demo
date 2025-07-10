{% set POSTGIS_SERVICE_NAME = 'tethys_postgis' %}
{% set TETHYS_PERSIST = salt['environ.get']('TETHYS_PERSIST') %}

Link_TethysDash_PostGIS_Service:
  cmd.run:
    - name: "tethys link persistent:{{ POSTGIS_SERVICE_NAME }} tethysdash:ps_database:primary_db"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_dash_setup_complete" ];"

Flag_Tethys_Dash_Setup_Complete:
  cmd.run:
    - name: touch {{ TETHYS_PERSIST }}/tethys_dash_setup_complete
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_dash_setup_complete" ];"