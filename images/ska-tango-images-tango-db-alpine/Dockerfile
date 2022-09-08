ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE="alpine:3.15"
ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-cpp-alpine:0.0.0"
FROM $BUILD_IMAGE AS buildenv

USER root

# source is giving syntax error, so we just paste everything 
RUN mkdir /docker-entrypoint-initdb.d && cd  /usr/local/share/tango/db \
    && sed -i '/create_db_tables.sql/ r create_db_tables.sql' create_db.sql \
    && sed -i '/stored_proc.sql/ r stored_proc.sql' create_db.sql \
    && sed -i "s/^source/#source/g" create_db.sql \
    && sed -i "/CREATE DATABASE tango;/d" create_db.sql \
    && cp create_db.sql /docker-entrypoint-initdb.d

FROM $BASE_IMAGE

LABEL \
      author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
      description="This image is the tango db (MariaDB) from the TANGO-community" \
      license="BSD-3-Clause" \
      registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-db" \
      org.skatelescope.team="Systems Team" \
      org.skatelescope.version="1.0.0" \
      int.skao.application="Tango DB"

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN apk --update add --no-cache pwgen alpine-baselayout
RUN addgroup --system mysql && adduser --system -s /bin/bash -G mysql mysql

RUN apk --update add --no-cache mariadb mariadb-client pwgen

COPY run.sh /scripts/run.sh
COPY wait.sh /usr/local/bin/wait-for-it.sh
RUN mkdir /docker-entrypoint-initdb.d /etc/mysql/conf.d && \
    chmod -R 755 /scripts /etc/mysql/conf.d

EXPOSE 3306

VOLUME ["/var/lib/mysql"]
COPY --from=buildenv /docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
COPY sql_mode.cnf /etc/my.cnf.d
RUN chmod 644 /etc/my.cnf.d/sql_mode.cnf
ENTRYPOINT ["/scripts/run.sh"]
