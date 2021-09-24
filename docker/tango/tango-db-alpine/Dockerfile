ARG BASE_IMAGE="yobasystems/alpine-mariadb:latest"
FROM $BASE_IMAGE AS builder
### Install and Setup Mariadb
# ENV LC_ALL=en_GB.UTF-8
# RUN mkdir /docker-entrypoint-initdb.d && \
#     apk add --upgrade --no-cache  \
#     mariadb mariadb-client tzdata 
# # comment out a few problematic configuration values
# RUN sed -Ei 's/^(bind-address|log)/#&/' /etc/my.cnf && \
#     sed -i  's/^skip-networking/#&/' /etc/my.cnf.d/mariadb-server.cnf && \
#     # don't reverse lookup hostnames, they are usually another container
#     sed -i '/^\[mysqld]$/a skip-host-cache\nskip-name-resolve' /etc/my.cnf && \
#     # always run as user mysql
#     sed -i '/^\[mysqld]$/a user=mysql' /etc/my.cnf && \
#     # allow custom configurations
#     echo -e '\n!includedir /etc/mysql/conf.d/' >> /etc/my.cnf && \
#     mkdir -p /etc/mysql/conf.d/
# VOLUME /var/lib/mysql
# COPY docker-entrypoint.sh /usr/local/bin/
# ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
# EXPOSE 3306
# CMD ["mysqld_safe"]
ENV TANGO_DOWNLOAD_URL=https://artefact.skao.int/repository/raw-internal/ska-tango-images/libraries/tango-9.3.4.tar.gz
RUN apk add --update --no-cache curl \
    ca-certificates
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
    && sed -i "s|^source create_db_tables.sql$|source /docker-+-initdb.d/include/create_db_tables.sql|g" dbinit/create_db.sql \
    && sed -i "s|^source stored_proc.sql$|source /docker-entrypoint-initdb.d/include/stored_proc.sql|g" dbinit/create_db.sql \
    && sed -i "/CREATE DATABASE tango;/d" dbinit/create_db.sql \
    && cp -r dbinit/* /docker-entrypoint-initdb.d
FROM $BASE_IMAGE
### Install and Setup Mariadb
# USER root
# ENV LC_ALL=en_GB.UTF-8
RUN apk add --upgrade --no-cache bash
# # comment out a few problematic configuration values
# RUN sed -Ei 's/^(bind-address|log)/#&/' /etc/my.cnf && \
#     sed -i  's/^skip-networking/#&/' /etc/my.cnf.d/mariadb-server.cnf && \
#     # don't reverse lookup hostnames, they are usually another container
#     sed -i '/^\[mysqld]$/a skip-host-cache\nskip-name-resolve' /etc/my.cnf && \
#     # always run as user mysql
#     sed -i '/^\[mysqld]$/a user=mysql' /etc/my.cnf && \
#     # allow custom configurations
#     echo -e '\n!includedir /etc/mysql/conf.d/' >> /etc/my.cnf && \
#     mkdir -p /etc/mysql/conf.d/
# VOLUME /var/lib/mysql
# COPY docker-entrypoint.sh /usr/local/bin/
# ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
# EXPOSE 3306
# CMD ["mysqld_safe"]
LABEL \
      author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
      description="This image is the tango db (MariaDB) from the TANGO-community" \
      license="BSD-3-Clause" \
      registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-db-alpine" \
      org.skatelescope.team="Systems Team" \
      org.skatelescope.version="1.0.0" \
      int.skao.application="Tango DB"
      
RUN addgroup --system mysql && adduser --system --group mysql mysql

COPY --from=builder /docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
COPY sql_mode.cnf /etc/my



