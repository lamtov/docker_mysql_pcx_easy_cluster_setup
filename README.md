# Percona_Xtra_Db Easy Cluster Setup


This image will help you build Percona_Xtra_Db Cluster easyly

> Link to DockerHub: https://hub.docker.com/r/tovanlam/percona_xtra_db_cluster


## Installation

 * First create docker volume in host you want to setup: 
 ```bash
	rm -rf   /usr/share/docker/mysql/mysql-data/*
	mkdir  -p  /usr/share/docker/mysql/mysql-data/
	mkdir -p /u01/docker/docker_log/mysql/
	mkdir -p /usr/share/docker/mysql/mysql/percona-xtradb-cluster.conf.d
	cp ./percona-xtradb-cluster.conf.d/wsrep.cnf /usr/share/docker/mysql/mysql/percona-xtradb-cluster.conf.d/
	sed -i "s|WSREP_CLUSTER_ADDRESS|_your_wsrep_cluster_address|g" /usr/share/docker/mysql/mysql/percona-xtradb-cluster.conf.d/wsrep.cnf
	chown -R 1011:1010 /usr/share/docker/mysql/mysql-data/
	chown -R 1011:1010 /u01/docker/docker_log/mysql/
```
> ***You should change _your_wsrep_cluster_address to the  _wsrep_cluster_address you want to use like 172.16.29.196,172.16.29.197,172.16.29.198***
 * For First Node in Cluster run:
 ```bash
	docker run  -d  --name mysql --network=host --privileged -v /u01/docker/docker_log/mysql:/var/log/      -v /usr/share/docker/:/usr/share/docker/    -u mysql -e PXC_START='BOOTSTRAP'   -e SQL_SST_USER="sstuser" -e SQL_SST_PASSWD="fPWOWrsMGLaBaP74iK57XoOyJy8aAEew"  tovanlam/percona_xtra_db_cluster
```
> ***You should change SQL_SST_PASSWD to the password you want to use***

 * For another Node in Cluster run:
 ```bash
	docker run  -d --name mysql --network=host --privileged -v /u01/docker/docker_log/mysql:/var/log/    -v /usr/share/docker/:/usr/share/docker/    -u mysql -e PXC_START='INIT_MYSQL_CLUSTER'   -e SQL_SST_USER="sstuser" -e SQL_SST_PASSWD="fPWOWrsMGLaBaP74iK57XoOyJy8aAEew"  tovanlam/percona_xtra_db_cluster
```
 * When done setup cluster exit each Node out and rejoin cluster by command:
 ```bash
	docker stop mysql
	docker rm mysql
	docker run  -d  --name mysql --network=host --privileged -v /u01/docker/docker_log/mysql:/var/log/  -v /usr/share/docker/mysql/mysql-data/:/var/lib/mysql:shared     -v /usr/share/docker/:/usr/share/docker/    -u mysql -e PXC_START='START_MYSQL'   -e SQL_SST_USER="sstuser" -e SQL_SST_PASSWD="fPWOWrsMGLaBaP74iK57XoOyJy8aAEew"  tovanlam/percona_xtra_db_cluster
 ```
  * Then you can restart each container without break cluster connection:
```bash
    docker restart mysql 
 ```
## Tutorials & Documentation
* Perconda-Xtra-Db Cluster will start with default user root and no password
*  To enter mysql commandline run:
```bash
	docker exec -it mysql mysql -u root 
```
* To view cluster info run:
 ```bash
	 docker exec -it mysql bash
 	$ mysql -u root 
 	> show status like '%wsrep%'
 ```
 

## Getting Help
 * See how it work in start.sh
 *  my email: tovanlam20132223@gmail.com


## Contributing

Questions about contributing, internals and so on are very welcome on the mail *tovanlam20132223@gmail.com*



