FROM tethysplatform/tethys-core

COPY apps ${TETHYS_HOME}/apps

# RUN cd ${TETHYS_HOME}/apps/tethysapp-nyc_car_theft_viewer && tethys install

COPY salt/ /srv/salt/

EXPOSE 80
WORKDIR ${TETHYS_HOME}
CMD bash run.sh