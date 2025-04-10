{% set TETHYS_PERSIST = salt['environ.get']('TETHYS_PERSIST') %}
{% set CESIUM_ION_TOKEN = salt['environ.get']('CESIUM_ION_TOKEN') %}
{% set OPEN_SKY_USERNAME = salt['environ.get']('OPEN_SKY_USERNAME') %}
{% set OPEN_SKY_PASSWORD = salt['environ.get']('OPEN_SKY_PASSWORD') %}

Set_Flight_Tracker_Cesium_Ion_Token:
  cmd.run:
    - name: "tethys app_settings set flight_tracker cesium_ion_token {{ CESIUM_ION_TOKEN }}"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/flight_tracker_setup_complete" ];"

Set_Flight_Tracker_Open_Sky_Username:
  cmd.run:
    - name: "tethys app_settings set flight_tracker open_sky_username {{ OPEN_SKY_USERNAME }}"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/flight_tracker_setup_complete" ];"

Set_Flight_Tracker_Open_Sky_Password:
  cmd.run:
    - name: "tethys app_settings set flight_tracker open_sky_password {{ OPEN_SKY_PASSWORD }}"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/flight_tracker_setup_complete" ];"

Flag_Flight_Tracker_Setup_Complete:
  cmd.run:
    - name: touch {{ TETHYS_PERSIST }}/flight_tracker_setup_complete
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/flight_tracker_setup_complete" ];"


