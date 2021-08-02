ARG BASE_IMAGE="mariadb:10"
FROM $BASE_IMAGE AS builder

ENV TANGO_DOWNLOAD_URL=https://artefact.skao.int/repository/raw-internal/ska-tango-images/libraries/tango-9.3.4.tar.gz

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
     apt-get -y install --no-install-recommends curl ca-certificates

RUN mkdir -p /usr/src/tango

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

RUN rm -r /usr/src/tango

FROM $BASE_IMAGE

COPY --from=builder /docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
COPY sql_mode.cnf /etc/mysql/conf.d
