{% set TETHYS_PERSIST = salt['environ.get']('TETHYS_PERSIST') %}

Set_Portal_to_Open:
  cmd.run:
    - name: "tethys settings --set ENABLE_OPEN_PORTAL true"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/portal_config_complete" ];"

Set_Signup_to_Open:
  cmd.run:
    - name: "tethys settings --set ENABLE_OPEN_SIGNUP true"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/portal_config_complete" ];"


Use_New_Paths_API:
  cmd.run:
    - name: "tethys settings --set USE_OLD_WORKSPACES_API false"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/portal_config_complete" ];"


Flag_Portal_Config_Setup_Complete:
  cmd.run:
    - name: touch {{ TETHYS_PERSIST }}/portal_config_complete
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/portal_config_complete" ];"

