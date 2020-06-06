#!/bin/bash

sudo -E copy_file.sh
if [ "$PXC_START" = "BOOTSTRAP" ]; then
        echo "insecureXXXXXXXXXXXX"
        /etc/init.d/mysql bootstrap-pxc
        #netstat -nap | grep 3306
        SQL_ROOT_PASSWD='lamtv10'
        mysql -u root -p${SQL_ROOT_PASSWD} -e "CREATE USER '${SQL_SST_USER}'@'localhost' IDENTIFIED BY '${SQL_SST_PASSWD}'"
        mysql -u root -p${SQL_ROOT_PASSWD} -e "GRANT RELOAD, LOCK TABLES, PROCESS, REPLICATION CLIENT ON *.* TO '${SQL_SST_USER}'@'localhost'"
        mysql -u root -p${SQL_ROOT_PASSWD} -e "SET PASSWORD FOR root@localhost=''"
        mysql -u root -e "FLUSH PRIVILEGES"

        mkdir -p /usr/share/docker/mysql/mysql-data/
        chown -R mysql:mysql /usr/share/docker/mysql/mysql-data/
        cp -r /var/lib/mysql/* /usr/share/docker/mysql/mysql-data/
        tail -f /var/log/mysqld.log
elif [ "$PXC_START" = "INIT_MYSQL_CLUSTER" ]; then
        /etc/init.d/mysql start
                mkdir -p /usr/share/docker/mysql/mysql-data/
        chown -R mysql:mysql /usr/share/docker/mysql/mysql-data/
        cp -r /var/lib/mysql/* /usr/share/docker/mysql/mysql-data/
        tail -f /var/log/mysqld.log
elif [ "$PXC_START" = "START_MYSQL" ]; then
        /etc/init.d/mysql start
        tail -f /var/log/mysqld.log
else
	echo "PXC_START is set to '$PXC_START'"
fi
