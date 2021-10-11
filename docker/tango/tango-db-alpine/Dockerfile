ARG BASE_IMAGE="alpine:3.14"
FROM $BASE_IMAGE AS buildenv

RUN apk add --update --no-cache curl ca-certificates

ENV TANGO_DOWNLOAD_URL=https://artefact.skao.int/repository/raw-internal/ska-tango-images/libraries/tango-9.3.4.tar.gz

RUN mkdir -p /usr/src/tango && mkdir /docker-entrypoint-initdb.d

WORKDIR /usr/src/tango 

RUN curl -fsSL "$TANGO_DOWNLOAD_URL" -o tango.tar.gz && \
    tar xf tango.tar.gz -C /usr/src/tango --strip-components=1

# create dump from tango tar gz and move it into the folder docker-entrypoint-initdb.d
RUN mkdir -p dbinit/include \
    && cp cppserver/database/create_db.sql.in dbinit/create_db.sql \
    && cp cppserver/database/create_db_tables.sql.in dbinit/include/create_db_tables.sql \
    && cp cppserver/database/stored_proc.sql.in dbinit/include/stored_proc.sql \
    && sed -i "s|@TANGO_DB_NAME@|tango|g" dbinit/create_db.sql \
    && sed -i "s|@TANGO_DB_NAME@|tango|g" dbinit/include/create_db_tables.sql \
    && sed -i "s|@TANGO_DB_NAME@|tango|g" dbinit/include/stored_proc.sql \
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
    tzdata xz zstd bash coreutils

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

