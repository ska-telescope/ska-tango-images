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

RUN mkdir /docker-entrypoint-initdb.d && \
    apk add --no-cache --update su-exec bash \
    pwgen tzdata xz zstd coreutils\    
    mariadb mariadb-common mariadb-client  mariadb-server-utils

# purge and re-create /var/lib/mysql with appropriate ownership
RUN rm -rf /var/lib/apt/lists/* && \
# purge and re-create /var/lib/mysql with appropriate ownership
	rm -rf /var/lib/mysql && \
	mkdir -p /var/lib/mysql /var/run/mysqld && \
	chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
# ensure that /var/run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
	chmod 777 /var/run/mysqld && \
# comment out a few problematic configuration values
	find /etc/mysql/ -name '*.cnf' -print0 \
		| xargs -0 grep -lE '^(bind-address|log|user\s)' \
		| xargs -rt -0 sed -Ei 's/^(bind-address|log|user\s)/#&/' 

VOLUME /var/lib/mysql
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh 
RUN chmod -R 755 /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 3306

COPY --from=buildenv /docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
COPY sql_mode.cnf /etc/mysql/conf.d

CMD ["mysqld"]
