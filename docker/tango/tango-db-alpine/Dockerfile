ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE="alpine:3.14"
ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-cpp-alpine:0.3.7"
FROM $BUILD_IMAGE AS buildenv

USER root

# move sql files into docker-entrypoint-initdb.d 
RUN mkdir /docker-entrypoint-initdb.d && cd  /usr/local/share/tango/db && mkdir -p dbinit/include  \
    && cp create_db.sql dbinit/create_db.sql \
    && cp create_db_tables.sql dbinit/include/create_db_tables.sql \
    && cp stored_proc.sql dbinit/include/stored_proc.sql \
    && sed -i "s|^source create_db_tables.sql$|source /docker-entrypoint-initdb.d/include/create_db_tables.sql|g" dbinit/create_db.sql \
    && sed -i "s|^source stored_proc.sql$|source /docker-entrypoint-initdb.d/include/stored_proc.sql|g" dbinit/create_db.sql \
    && sed -i "/CREATE DATABASE tango;/d" dbinit/create_db.sql \
    && cp -r dbinit/* /docker-entrypoint-initdb.d

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
RUN addgroup --system mysql && adduser --system -G mysql mysql

RUN apk add --update --no-cache socat mysql mysql-client pwgen\
    tzdata xz zstd bash coreutils openrc

ADD run.sh /scripts/run.sh
RUN mkdir /docker-entrypoint-initdb.d && \
    mkdir /scripts/pre-exec.d && \
    mkdir /scripts/pre-init.d && \
    chmod -R 755 /scripts

EXPOSE 3306

VOLUME ["/var/lib/mysql"]
COPY --from=buildenv /docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
COPY sql_mode.cnf /etc/mysql/conf.d

ENTRYPOINT ["/scripts/run.sh"]

