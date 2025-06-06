{% set TETHYS_PERSIST = salt['environ.get']('TETHYS_PERSIST') %}

Patch_ASGI_Config:
  cmd.run:
    - name: "sed -i 's/--fd 0 //' {{ TETHYS_PERSIST }}/asgi_supervisord.conf"
    - shell: /bin/bash