ARG BASE_IMAGE="alpine:3.14"
FROM $BASE_IMAGE AS buildenv

ENV TANGO_DOWNLOAD_URL=https://artefact.skao.int/repository/raw-internal/ska-tango-images/libraries/tango-9.3.4.tar.gz

RUN apk add --no-cache --update curl ca-certificates

RUN mkdir -p /usr/src/tango

WORKDIR /usr/src/tango

RUN curl -fsSL "$TANGO_DOWNLOAD_URL" -o tango.tar.gz && \
    tar xf tango.tar.gz -C /usr/src/tango --strip-components=1

# create dump from tango tar gz and move it into the folder docker-entrypoint-initdb.d
RUN mkdir /docker-entrypoint-initdb.d && mkdir -p dbinit/include \
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

LABEL \
      author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
      description="This image is the tango db (MariaDB) from the TANGO-community" \
      license="BSD-3-Clause" \
      registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-db" \
      org.skatelescope.team="Systems Team" \
      org.skatelescope.version="1.0.0" \
      int.skao.application="Tango DB"

RUN mkdir /docker-entrypoint-initdb.d && \
    apk add --no-cache --update mariadb mariadb-common mariadb-client && \
    mariadb-server-utils pwgen tzdata bash 

# purge and re-create /var/lib/mysql with appropriate ownership
# and other stuff done in the official debian image

CMD ["bash"]
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
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh && chmod -R 755 /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]

COPY --from=buildenv /docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
COPY sql_mode.cnf /etc/mysql/conf.d

