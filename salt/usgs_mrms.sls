{% set TETHYS_PERSIST = salt['environ.get']('TETHYS_PERSIST') %}
{% set BUCKET_NAME = salt['environ.get']('USGS_MRMS_AWS_BUCKET_NAME') %}
{% set AWS_KEY = salt['environ.get']('USGS_MRMS_AWS_KEY') %}
{% set AWS_SECRET = salt['environ.get']('USGS_MRMS_AWS_SECRET') %}
{% set AWS_REGION = salt['environ.get']('USGS_MRMS_AWS_REGION') %}

Set_USGS_MRMS_AWS_Bucket_Name:
  cmd.run:
    - name: "tethys app_settings set usgs_mrms bucket_name {{ BUCKET_NAME }}"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/usgs_mrms_setup_complete" ];"

Set_USGS_MRMS_AWS_Key:
  cmd.run:
    - name: "tethys app_settings set usgs_mrms s3_key {{ AWS_KEY }}"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/usgs_mrms_setup_complete" ];"

Set_USGS_MRMS_AWS_Secret:
  cmd.run:
    - name: "tethys app_settings set usgs_mrms s3_secret {{ AWS_SECRET }}"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/usgs_mrms_setup_complete" ];"

Set_USGS_MRMS_AWS_Region:
  cmd.run:
    - name: "tethys app_settings set usgs_mrms s3_region {{ AWS_REGION }}"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/usgs_mrms_setup_complete" ];"

Flag_USGS_MRMS_Setup_Complete:
  cmd.run:
    - name: touch {{ TETHYS_PERSIST }}/usgs_mrms_setup_complete
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/usgs_mrms_setup_complete" ];"