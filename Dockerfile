FROM tethysplatform/tethys-core:4.3.7-py3.12-dj4.2

ENV GS_USERNAME="admin"
ENV GS_PASSWORD="geoserver"
ENV GS_SERVICE_NAME="geoserver"
ENV GS_SERVICE_HOST="https://demo.tethysgeoscience.org"
ENV GS_SERVICE_PORT="8080"

ENV PERSISTENT_SERVICE_NAME="tethys_postgis"

# Tokens/credentials for demo apps
ENV OPENCAGEDATA_API_KEY="61bf0fdba0ea495eb1546cdf1fa0bdce"
ENV CESIUM_ION_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI3Njc3NjFmZC1iMmY1LTQ2MWUtYmNiYS0yZWIyNzM4ODdlYzMiLCJpZCI6Mjg3MzYwLCJpYXQiOjE3NDI4NzI1Njl9.FOpXK90h-MmUFAkrkubwCv7yFPuFeXD-PFcLOnr7Zig"
ENV OPEN_SKY_USERNAME="tethys_demo_portal"
ENV OPEN_SKY_PASSWORD="Password123"
ENV FIRMS_API_TOKEN="4a9518ea6c93f94ecdebabba9dee6bd4"

ENV NGINX_PORT=8080     

ENV SITE_TITLE=""
ENV FAVICON="/tethys_portal/images/TGF-icon.svg"
ENV BRAND_TEXT="TGF Portal"
ENV BRAND_IMAGE="/tethys_portal/images/TGF-icon.svg"
ENV PRIMARY_COLOR="#403f3f"
ENV SECONDARY_COLOR="#95c798"
ENV COPYRIGHT="Copyright © 2025 Tethys Geoscience Foundation™"

ENV DEFAULT_DASHBOARD_IMAGE_PATH=${TETHYS_HOME}/apps/tethysdash/tethysapp/tethysdash/default_dashboard.png

ARG TETHYS_APP_ROOT_URL="/apps/tethysdash/"
ARG TETHYS_LOADER_DELAY="500"

ENV TETHYS_DASH_APP_SRC_ROOT=${TETHYS_HOME}/apps/tethysdash
ENV DEV_REACT_CONFIG="${TETHYS_DASH_APP_SRC_ROOT}/reactapp/config/development.env"
ENV PROD_REACT_CONFIG="${TETHYS_DASH_APP_SRC_ROOT}/reactapp/config/production.env"

# Install NPM with NVM
ENV NVM_DIR=/usr/local/nvm
ENV NODE_VERSION=20.12.2
RUN mkdir -p ${NVM_DIR} \
  && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | /bin/bash \
  && . ${NVM_DIR}/nvm.sh \
  && nvm install ${NODE_VERSION} \
  && nvm alias default ${NODE_VERSION} \
  && nvm use default

ENV NODE_VERSION_DIR=${NVM_DIR}/versions/node/v${NODE_VERSION}
ENV NODE_PATH=${NODE_VERSION_DIR}/lib/node_modules
ENV PATH=${NODE_VERSION_DIR}/bin:$PATH
ENV NPM=${NODE_VERSION_DIR}/bin/npm

COPY apps ${TETHYS_HOME}/apps

COPY tethysdash_plugins ${TETHYS_HOME}/tethysdash_plugins

COPY tethysdash_dashboards ${TETHYS_HOME}/tethysdash_dashboards

COPY app_requirements/ app_requirements/

COPY static/images/* ${TETHYS_HOME}/tethys/tethys_portal/static/tethys_portal/images

ARG MAMBA_DOCKERFILE_ACTIVATE=1

RUN micromamba install --yes -c conda-forge --file app_requirements/conda_package_requirements.txt && \
    pip install --no-cache-dir -r app_requirements/pip_package_requirements.txt

RUN cd ${TETHYS_HOME}/apps/tethysapp-flight_tracker/tethysapp-flight_tracker && tethys install -w -N -q && \
    cd ${TETHYS_HOME}/apps/tethysapp-gizmo_showcase && tethys install -w -N -q && \
    cd ${TETHYS_HOME}/apps/tethysapp-layout_showcase && tethys install -w -N -q && \
    cd ${TETHYS_HOME}/apps/tethysapp-nyc_car_theft_viewer/tethysapp-nyc_car_theft_viewer && tethys install -w -N -q && \
    cd ${TETHYS_HOME}/apps/tethysapp-population_viewer/tethysapp-population_app && tethys install -w -N -q && \
    cd ${TETHYS_HOME}/apps/tethysapp-wildfire_tracker/tethysapp-wildfire_visualizer && tethys install -w -N -q && \
    cd ${TETHYS_HOME}/apps/tethysapp-wildatlas/tethysapp-wildatlas && tethys install -w -N -q

RUN mv ${DEV_REACT_CONFIG} ${PROD_REACT_CONFIG} && \
    sed -i "s#TETHYS_DEBUG_MODE.*#TETHYS_DEBUG_MODE = ${TETHYS_DEBUG_MODE}#g" ${PROD_REACT_CONFIG} && \
    sed -i "s#TETHYS_LOADER_DELAY.*#TETHYS_LOADER_DELAY = ${TETHYS_LOADER_DELAY}#g" ${PROD_REACT_CONFIG} && \
    sed -i "s#TETHYS_PORTAL_HOST.*#TETHYS_PORTAL_HOST = ${TETHYS_PORTAL_HOST}#g" ${PROD_REACT_CONFIG} && \
    sed -i "s#TETHYS_APP_ROOT_URL.*#TETHYS_APP_ROOT_URL = ${TETHYS_APP_ROOT_URL}#g" ${PROD_REACT_CONFIG} && \
    cd ${TETHYS_HOME}/apps/tethysdash && npm install && npm run build && tethys install -w -N -q

RUN cd ${TETHYS_HOME}/tethysdash_plugins/tethysdash_plugin_cnrfc && pip install . && \
    cd ${TETHYS_HOME}/tethysdash_plugins/tethysdash_plugin_cw3e && pip install . && \
    cd ${TETHYS_HOME}/tethysdash_plugins/tethysdash_plugin_usace && pip install . && \
    cd ${TETHYS_HOME}/tethysdash_plugins/tethysdash_examples && pip install . && \
    cd ${TETHYS_HOME}/tethysdash_plugins/tethysdash_plugin_geoglows && pip install --no-deps .

RUN mkdir -p -m 777 ${TETHYS_PERSIST}/data/tethysdash

RUN chmod -R 777 /opt/conda/envs/tethys/lib/python3.12/site-packages/tethysdash_plugin_geoglows/

ADD salt /srv/salt

WORKDIR ${TETHYS_HOME}

CMD bash run.sh