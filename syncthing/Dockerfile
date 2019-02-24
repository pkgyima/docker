FROM alpine:3.9
LABEL maintainer="Peter Gyima peter.gyima@gimadigital.com>"
# set environment variables
ENV RUN_USER                                syncthing
ENV RUN_GROUP                               syncthing
ENV INSTALL_DIR                             /opt/syncthing
ENV GUI_PORT                                8384
ENV GUI_IP                                  0.0.0.0

# set user and user group
RUN addgroup -S ${RUN_GROUP} && adduser -S ${RUN_USER} -G ${RUN_GROUP}

# Expose default HTTP port.
EXPOSE ${GUI_PORT}
EXPOSE 22000

# create a amed volume to persist data
VOLUME [":${INSTALL_DIR}"]

# create install dir
RUN mkdir -p ${INSTALL_DIR}

# lets download the files
ADD https://github.com/syncthing/syncthing/releases/download/v1.0.1/syncthing-linux-amd64-v1.0.1.tar.gz ./

#lets untar it
RUN tar -C ${INSTALL_DIR} -xzf syncthing-linux-amd64-v1.0.1.tar.gz

# delete the downloaded file
RUN rm syncthing-linux-amd64-v1.0.1.tar.gz

# make sure the user has access to the files
RUN chown -R ${RUN_USER}:${RUN_GROUP} ${INSTALL_DIR}

# lets work in the syncthing folder
WORKDIR ${INSTALL_DIR}/syncthing-linux-amd64-v1.0.1

# lets run as user
USER ${RUN_USER}

# start the application
CMD ./syncthing -gui-address="http://${GUI_IP}:${GUI_PORT}"