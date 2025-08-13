{% set TETHYS_HOME = salt['environ.get']('TETHYS_HOME') %}
{% set TETHYS_PERSIST = salt['environ.get']('TETHYS_PERSIST') %}

Add_GEOGLOWS_Hydroviewer:
  cmd.run:
    - name: |
        tethys proxyapp add \
          "GEOGLOWS Hydroviewer" \
          "http://hydroviewer.geoglows.org" \
          "A web app for interacting with all components of the GEOGloWS ECMWF Streamflow Model" \
          "tethys_portal/images/geoglows_hydroviewer_icon.jpeg"

    - shell: /bin/bash
    - unless: /bin/bash -c '[ -f "{{ TETHYS_PERSIST }}/proxy_apps_setup_complete" ]'
    
Proxy_Apps_Setup_Complete:
  cmd.run:
    - name: touch {{ TETHYS_PERSIST }}/proxy_apps_setup_complete
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/proxy_apps_setup_complete" ];"