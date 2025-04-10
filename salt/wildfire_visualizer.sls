{% set TETHYS_PERSIST = salt['environ.get']('TETHYS_PERSIST') %}
{% set FIRMS_API_TOKEN = salt['environ.get']('FIRMS_API_TOKEN') %}

Set_Wildfire_Visualizer_Firms_Api_Token:
  cmd.run:
    - name: "tethys app_settings set wildfire_visualizer FIRMS_api_token {{ FIRMS_API_TOKEN }}"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/wildfire_visualizer_setup_complete" ];"

Flag_Wildfire_Visualizer_Setup_Complete:
  cmd.run:
    - name: touch {{ TETHYS_PERSIST }}/wildfire_visualizer_setup_complete
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/wildfire_visualizer_setup_complete" ];"