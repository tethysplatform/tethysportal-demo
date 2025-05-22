{% set TETHYS_PERSIST = salt['environ.get']('TETHYS_PERSIST') %}
{% set CESIUM_ION_TOKEN = salt['environ.get']('CESIUM_ION_TOKEN') %}

Set_Flight_Tracker_Cesium_Ion_Token:
  cmd.run:
    - name: "tethys app_settings set flight_tracker cesium_ion_token {{ CESIUM_ION_TOKEN }}"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/flight_tracker_setup_complete" ];"

Flag_Flight_Tracker_Setup_Complete:
  cmd.run:
    - name: touch {{ TETHYS_PERSIST }}/flight_tracker_setup_complete
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/flight_tracker_setup_complete" ];"


