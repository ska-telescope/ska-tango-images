ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE="alpine:3.15"
FROM $BASE_IMAGE AS buildenv

RUN apk --update add --no-cache git
# install TangoDatabase so we retrieve the three files we need
RUN git clone --depth 1 https://gitlab.com/tango-controls/TangoDatabase.git /usr/local/share/tango/db


# source is giving syntax error, so we just paste everything 
RUN mkdir /docker-entrypoint-initdb.d && cd  /usr/local/share/tango/db \
    && cp create_db.sql.in create_db.sql \
    && sed -i '/create_db_tables.sql/ r create_db_tables.sql.in' create_db.sql \
    && sed -i '/stored_proc.sql/ r stored_proc.sql.in' create_db.sql \
    && sed -i "s|@TANGO_DB_NAME@|tango|g" create_db.sql \
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
RUN addgroup --system mysql && adduser --system -s /bin/ash -G mysql mysql

RUN apk --update add --no-cache mariadb mariadb-client pwgen

COPY run.sh /scripts/run.sh
RUN mkdir /docker-entrypoint-initdb.d /etc/mysql/conf.d && \
    chmod -R 755 /scripts /etc/mysql/conf.d

EXPOSE 3306

VOLUME ["/var/lib/mysql"]
COPY --from=buildenv /docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
COPY --from=buildenv /usr/local/bin/wait-for-it.sh /usr/local/bin/wait-for-it.sh
COPY sql_mode.cnf /etc/my.cnf.d
RUN chmod 644 /etc/my.cnf.d/sql_mode.cnf
ENTRYPOINT ["/scripts/run.sh"]

