{% set POSTGIS_SERVICE_NAME = salt['environ.get']('PERSISTENT_SERVICE_NAME') %}
{% set TETHYS_PERSIST = salt['environ.get']('TETHYS_PERSIST') %}
{% set TETHYS_HOME = salt['environ.get']('TETHYS_HOME') %}

Link_TethysDash_PostGIS_Service:
  cmd.run:
    - name: "tethys link persistent:{{ POSTGIS_SERVICE_NAME }} tethysdash:ps_database:primary_db"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_dash_setup_complete" ];"

Collect_Plugin_Metadata:
  cmd.run:
  - name: |
      SCRIPT_DIR=$(dirname $(python -c 'import tethysapp.tethysdash as m; print(m.__file__)'))
      cd $SCRIPT_DIR
      python collect_plugin_static.py
  - shell: /bin/bash
  - cwd: /

Run_Install_Dashboards_Script:
  cmd.run:
    - name: "cd {{ TETHYS_HOME }}/tethysdash_dashboards && tethys manage shell < install_dashboards.py"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_dash_setup_complete" ];"

Flag_Tethys_Dash_Setup_Complete:
  cmd.run:
    - name: touch {{ TETHYS_PERSIST }}/tethys_dash_setup_complete
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_dash_setup_complete" ];"