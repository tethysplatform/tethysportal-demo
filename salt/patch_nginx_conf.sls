{% set conf_file = salt['environ.get']('TETHYS_PERSIST') ~ '/tethys_nginx.conf' %}

Patch_NGINX_Channels_Upstream:
  file.blockreplace:
    - name: {{ conf_file }}
    - marker_start: "upstream channels-backend {"
    - marker_end: "}"
    - content:  server unix:/run/tethys_asgi0.sock;
    - show_changes: True