FROM tethysplatform/tethys-core

COPY salt/ /srv/salt/

EXPOSE 80
WORKDIR ${TETHYS_HOME}
CMD bash run.sh