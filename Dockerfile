FROM tethysplatform/tethys-core:4.3.7-py3.12-dj4.2

ENV GS_USERNAME="admin"
ENV GS_PASSWORD="geoserver"
ENV GS_SERVICE_NAME="geoserver"
ENV GS_SERVICE_HOST="http://localhost"
ENV GS_SERVICE_PORT="8080"

ENV OPENCAGEDATA_API_KEY="61bf0fdba0ea495eb1546cdf1fa0bdce"

ENV CESIUM_ION_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI3Njc3NjFmZC1iMmY1LTQ2MWUtYmNiYS0yZWIyNzM4ODdlYzMiLCJpZCI6Mjg3MzYwLCJpYXQiOjE3NDI4NzI1Njl9.FOpXK90h-MmUFAkrkubwCv7yFPuFeXD-PFcLOnr7Zig"

ENV OPEN_SKY_USERNAME="tethys_demo_portal"
ENV OPEN_SKY_PASSWORD="Password123"

ENV FIRMS_API_TOKEN="4a9518ea6c93f94ecdebabba9dee6bd4"

ENV NGINX_PORT=8080     

COPY apps ${TETHYS_HOME}/apps

COPY tethysdash_plugins ${TETHYS_HOME}/tethysdash_plugins

COPY app_requirements/ app_requirements/

ARG MAMBA_DOCKERFILE_ACTIVATE=1

RUN ls -R ${TETHYS_HOME}/apps

RUN micromamba install --yes -c conda-forge --file app_requirements/conda_package_requirements.txt && \
    cd ${TETHYS_HOME}/apps/tethysapp-flight_tracker/tethysapp-flight_tracker && tethys install -w -N -q && \
    cd ${TETHYS_HOME}/apps/tethysapp-gizmo_showcase && tethys install -w -N -q && \
    cd ${TETHYS_HOME}/apps/tethysapp-layout_showcase && tethys install -w -N -q && \
    cd ${TETHYS_HOME}/apps/tethysapp-nyc_car_theft_viewer/tethysapp-nyc_car_theft_viewer && tethys install -w -N -q && \
    cd ${TETHYS_HOME}/apps/tethysapp-population_viewer/tethysapp-population_app && tethys install -w -N -q && \
    cd ${TETHYS_HOME}/apps/tethysapp-wildfire_tracker/tethysapp-wildfire_visualizer && tethys install -w -N -q && \
    cd ${TETHYS_HOME}/apps/tethysdash && tethys install -w -N -q

RUN cd ${TETHYS_HOME}/tethysdash_plugins/tethysdash_plugin_cnrfc && pip install . && \
    cd ${TETHYS_HOME}/tethysdash_plugins/tethysdash_plugin_cw3e && pip install . && \
    cd ${TETHYS_HOME}/tethysdash_plugins/tethysdash_plugin_usace && pip install . && \
    cd ${TETHYS_HOME}/tethysdash_plugins/tethysdash_examples && pip install . && \
    cd ${TETHYS_HOME}/tethysdash_plugins/ciroh_plugins && pip install .

RUN mkdir -p -m 777 ${TETHYS_PERSIST}/data/tethysdash

ADD salt /srv/salt


WORKDIR ${TETHYS_HOME}

CMD bash run.sh