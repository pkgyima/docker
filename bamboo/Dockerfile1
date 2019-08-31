# from  Dave Chevell docker files
# changed version to 6.8
FROM openjdk:8-jdk-alpine
LABEL maintainer="Peter Gyima peter.gyima@gimadigital.com>"

ENV RUN_USER            bamboo
ENV RUN_GROUP           bamboo

# https://confluence.atlassian.com/display/BAMBOO/Locating+important+directories+and+files
ENV BAMBOO_HOME          /var/atlassian/application-data/bamboo
ENV BAMBOO_INSTALL_DIR   /opt/atlassian/bamboo

VOLUME ["${BAMBOO_HOME}"]

# Expose HTTP and ActiveMQ ports
EXPOSE 8085
EXPOSE 54663

WORKDIR $BAMBOO_HOME

CMD ["/entrypoint.sh", "-fg"]
ENTRYPOINT ["/sbin/tini", "--"]

RUN apk add --no-cache wget curl git git-lfs openssh bash procps openssl perl ttf-dejavu tini maven \
    && addgroup -S ${RUN_GROUP} \
    && adduser -S -G ${RUN_GROUP} ${RUN_USER}

COPY entrypoint.sh              /entrypoint.sh

ARG BAMBOO_VERSION=6.8.0
ARG DOWNLOAD_URL=https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-${BAMBOO_VERSION}.tar.gz

COPY . /tmp

RUN mkdir -p                             ${BAMBOO_INSTALL_DIR} \
    && curl -L --silent                  ${DOWNLOAD_URL} | tar -xz --strip-components=1 -C "$BAMBOO_INSTALL_DIR" \
    && chown -R ${RUN_USER}:${RUN_GROUP} ${BAMBOO_INSTALL_DIR}/ \
    && sed -i -e 's/^JVM_SUPPORT_RECOMMENDED_ARGS=""$/: \${JVM_SUPPORT_RECOMMENDED_ARGS:=""}/g' ${BAMBOO_INSTALL_DIR}/bin/setenv.sh \
    && sed -i -e 's/^JVM_\(.*\)_MEMORY="\(.*\)"$/: \${JVM_\1_MEMORY:=\2}/g' ${BAMBOO_INSTALL_DIR}/bin/setenv.sh \
    && sed -i -e 's/^JAVA_OPTS="/JAVA_OPTS="${JAVA_OPTS} /g' ${BAMBOO_INSTALL_DIR}/bin/setenv.sh \
    && sed -i -e 's/port="8085"/port="8085" secure="${catalinaConnectorSecure}" scheme="${catalinaConnectorScheme}" proxyName="${catalinaConnectorProxyName}" proxyPort="${catalinaConnectorProxyPort}"/' ${BAMBOO_INSTALL_DIR}/conf/server.xml \
    && sed -i -e 's/Context path=""/Context path="${catalinaContextPath}"/' ${BAMBOO_INSTALL_DIR}/conf/server.xml
