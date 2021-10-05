ARG BASE_IMAGE="alpine:3.14"
FROM $BASE_IMAGE AS buildenv

RUN apk add --update --no-cache git


# clone TangoDatabase
RUN git clone --depth 1 https://gitlab.com/tango-controls/TangoDatabase.git /TangoDatabase 

# move file from repo into docker-entrypoint-initdb.d
RUN mkdir /docker-entrypoint-initdb.d && cd /TangoDatabase && mkdir -p dbinit/include  \
    && cp create_db.sql.in dbinit/create_db.sql \
    && cp create_db_tables.sql.in dbinit/include/create_db_tables.sql \
    && cp stored_proc.sql.in dbinit/include/stored_proc.sql \
    && sed -i "s|@TANGO_DB_NAME@|tango|g" dbinit/create_db.sql \
    && sed -i "s|@TANGO_DB_NAME@|tango|g" dbinit/include/create_db_tables.sql \
    && sed -i "s|@TANGO_DB_NAME@|tango|g" dbinit/include/stored_proc.sql \
    && sed -i "s|^source create_db_tables.sql$|source /docker-entrypoint-initdb.d/include/create_db_tables.sql|g" dbinit/create_db.sql \
    && sed -i "s|^source stored_proc.sql$|source /docker-entrypoint-initdb.d/include/stored_proc.sql|g" dbinit/create_db.sql \
    && sed -i "/CREATE DATABASE tango;/d" dbinit/create_db.sql \
    && cp -r dbinit/* /docker-entrypoint-initdb.d


FROM yobasystems/alpine-mariadb

LABEL \
      author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
      description="This image is the tango db (MariaDB) from the TANGO-community" \
      license="BSD-3-Clause" \
      registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-db" \
      org.skatelescope.team="Systems Team" \
      org.skatelescope.version="1.0.0" \
      int.skao.application="Tango DB"

COPY --from=buildenv /docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
COPY sql_mode.cnf /etc/mysql/conf.d
