#!/bin/sh -e

# execute any pre-init scripts
for i in /scripts/pre-init.d/*sh
do
    if [ -e "${i}" ]; then
        echo "[i] pre-init.d - processing $i"
        . "${i}"
    fi
done

if [ -d "/run/mysqld" ]; then
    echo "[i] mysqld already present, skipping creation"
    chown -R mysql:mysql /run/mysqld
else
    echo "[i] mysqld not found, creating...."
    mkdir -p /run/mysqld
    chown -R mysql:mysql /run/mysqld
fi

if [ -d /var/lib/mysql/mysql ]; then
    echo "[i] MariaDB directory already present, skipping creation"
    chown -R mysql:mysql /var/lib/mysql
else
    echo "[i] MariaDB data directory not found, creating initial DBs"

    chown -R mysql:mysql /var/lib/mysql

    mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null

    if [ "$MYSQL_ROOT_PASSWORD" = "" ]; then
        MYSQL_ROOT_PASSWORD=`pwgen 16 1`
        echo "[i] MariaDB root Password: $MYSQL_ROOT_PASSWORD"
    fi

    MYSQL_DATABASE=${MYSQL_DATABASE:-""}
    MYSQL_USER=${MYSQL_USER:-""}
    MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}

    tfile=`mktemp`
    if [ ! -f "$tfile" ]; then
        return 1
    fi

    cat << EOF > /root/.my.cnf
[mysql]
user=root
password=$MYSQL_ROOT_PASSWORD
EOF
    chmod 0600 /root/.my.cnf

    cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES ;
GRANT ALL ON *.* TO 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
GRANT ALL ON *.* TO 'root'@'localhost' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;
EOF

    if [ "$MYSQL_DATABASE" != "" ]; then
        echo "[i] Creating database: $MYSQL_DATABASE"
        if [ "$MYSQL_CHARSET" != "" ] && [ "$MYSQL_COLLATION" != "" ]; then
            echo "[i] with character set [$MYSQL_CHARSET] and collation [$MYSQL_COLLATION]"
            echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET $MYSQL_CHARSET COLLATE $MYSQL_COLLATION;" >> $tfile
        else
            echo "[i] with character set: 'utf8' and collation: 'utf8_general_ci'"
            echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile
        fi

        if [ "$MYSQL_USER" != "" ]; then
            echo "[i] Creating user: $MYSQL_USER with password $MYSQL_PASSWORD"
            echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tfile
        fi
    fi

    /usr/bin/mysqld --user=mysql --bootstrap --verbose=0 < $tfile
    rm -f $tfile

    /usr/bin/mysqld --user=mysql  --verbose=0 &
    PID=$!
    echo "[i] Init server PID $PID"

    i=30
    while [ $i -ne 0 ]
    do
        i=$(($i-1))
        echo 'select 1' | /usr/bin/mysql --database=mysql  &> /dev/null && break
        sleep 1
    done

    if [ "$i" = 0 ]; then
        echo "[e] Unable to start init server, aborting"
        rm -rf /var/lib/mysql/mysql
        exit -1
    fi

    echo "[i] Init server up"

    for f in /docker-entrypoint-initdb.d/*; do
        case "$f" in
            *.sql)    echo "$0: running $f"; /usr/bin/mysql < "$f"; echo ;;
            *.sql.gz) echo "$0: running $f"; gunzip -c "$f" | /usr/bin/mysql --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0; echo ;;
            *)        echo "$0: ignoring or entrypoint initdb empty $f" ;;
        esac
        echo
    done

    echo "[i] Terminating init server"
    kill "$PID"
    wait "$PID"

    echo
    echo 'MariaDB init process done. Ready for start up.'
    echo

    echo "exec /usr/bin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0" "$@"
fi

# execute any pre-exec scripts
for i in /scripts/pre-exec.d/*sh
do
    if [ -e "${i}" ]; then
        echo "[i] pre-exec.d - processing $i"
        . ${i}
    fi
done

exec /usr/bin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0 $@

