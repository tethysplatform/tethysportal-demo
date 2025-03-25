install-nyc-car-theft-viewer:
    cmd.run:
        - name: >
            cd ${TETHYS_HOME}/apps/tethysapp-nyc_car_theft_viewer/tethysapp-nyc_car_theft_viewer &&
            tethys install

install-flight_tracker:
    cmd.run:
        - name: >
            cd ${TETHYS_HOME}/apps/tethysapp-flight_tracker/tethysapp-flight_tracker &&
            tethys install -w -N -q

install-population_viewer:
    cmd.run:
        - name: >
            cd ${TETHYS_HOME}/apps/tethysapp-population_viewer/tethysapp-population_app &&
            tethys install

