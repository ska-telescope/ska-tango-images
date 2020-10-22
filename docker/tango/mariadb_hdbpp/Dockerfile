ARG DOCKER_REGISTRY_USER
ARG DOCKER_REGISTRY_HOST
FROM ${DOCKER_REGISTRY_HOST}/${DOCKER_REGISTRY_USER}/tango-db:10.4.10

COPY resources/create_hdb++_mysql.sql docker-entrypoint-initdb.d/create_db.sql
COPY resources/my.cnf /etc/mysql/conf.d

