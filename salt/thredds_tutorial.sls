{% set THREDDS_SERVICE_NAME = salt['environ.get']('THREDDS_SERVICE_NAME') %}
{% set TETHYS_PERSIST = salt['environ.get']('TETHYS_PERSIST') %}

Link_THREDDS_Tutorial_THREDDS_Service:
  cmd.run:
    - name: "tethys link spatial:{{ THREDDS_SERVICE_NAME }} thredds_tutorial:ds_spatial:thredds_service"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_dash_setup_complete" ];"

Flag_Tethys_Dash_Setup_Complete:
  cmd.run:
    - name: touch {{ TETHYS_PERSIST }}/tethys_dash_setup_complete
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_dash_setup_complete" ];"