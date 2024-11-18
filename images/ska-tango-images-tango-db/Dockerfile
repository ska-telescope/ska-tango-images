ARG MARIADB_VERSION
ARG BASE_IMAGE="mariadb:${MARIADB_VERSION}"
FROM $BASE_IMAGE AS builder
ARG DEBIAN_FRONTEND=noninteractive
ARG DATABASEDS_TANGODB_VERSION

RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
        unattended-upgrades; \
    rm -rf /var/lib/apt/lists/*

# Apply security upgrades (base image is not patched)
RUN unattended-upgrade
RUN apt-get purge unattended-upgrades -y

RUN mkdir -p /usr/src/databaseds
WORKDIR /usr/src/databaseds
RUN set -xe; \
    git clone --depth=1 --branch=${DATABASEDS_TANGODB_VERSION} --recursive -c advice.detachedHead=false \
        https://gitlab.com/tango-controls/TangoDatabase.git /usr/src/databaseds; \
    mkdir -p dbinit/include; \
    cp create_db.sql.in dbinit/create_db.sql; \
    cp create_db_tables.sql.in dbinit/include/create_db_tables.sql; \
    cp stored_proc.sql.in dbinit/include/stored_proc.sql; \
    sed -i "s|@TANGO_DB_NAME@|tango|g" dbinit/create_db.sql; \
    sed -i "s|@TANGO_DB_NAME@|tango|g" dbinit/include/create_db_tables.sql; \
    sed -i "s|@TANGO_DB_NAME@|tango|g" dbinit/include/stored_proc.sql; \
    sed -i "s|^source create_db_tables.sql$|source /docker-entrypoint-initdb.d/include/create_db_tables.sql|g" dbinit/create_db.sql; \
    sed -i "s|^source stored_proc.sql$|source /docker-entrypoint-initdb.d/include/stored_proc.sql|g" dbinit/create_db.sql; \
    sed -i "/CREATE DATABASE tango;/d" dbinit/create_db.sql; \
    cp -r dbinit/* /docker-entrypoint-initdb.d

RUN rm -r /usr/src/databaseds

FROM $BASE_IMAGE

LABEL \
    int.skao.application="Tango DB" \
    int.skao.image.authors="oci-support@skao.int" \
    int.skao.image.team="Team Wombat" \
    int.skao.image.url="https://gitlab.com/ska-telescope/ska-tango-images" \
    int.skao.image.source="images/ska-tango-images-tango-db/Dockerfile" \
    description="This image is the tango db (MariaDB) from the TANGO-community" \
    license="BSD-3-Clause"

COPY --from=builder /docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
COPY sql_mode.cnf /etc/mysql/conf.d
RUN chmod 644 /etc/mysql/conf.d/sql_mode.cnf
