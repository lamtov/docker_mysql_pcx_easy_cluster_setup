FROM tovanlam/base_image
MAINTAINER lamtv10@viettel.com.vn

LABEL openstack_version="queens"
ENV DEBIAN_FRONTEND noninteractive
ENV SERVICE mysql
ENV SHARE_CONF_DIR /usr/share/docker
RUN apt install -y wget
RUN echo $(lsb_release -sc)

RUN groupadd -r -g 1010  mysql && useradd -r -u 1011  -g mysql mysql

RUN apt install debconf-utils
RUN wget https://repo.percona.com/apt/percona-release_0.1-6.$(lsb_release -sc)_all.deb
RUN dpkg -i percona-release_0.1-6.$(lsb_release -sc)_all.deb
RUN apt-get update -y

RUN echo "percona-xtradb-cluster-server-5.7   percona-xtradb-cluster-server-5.7/root-pass password lamtv10" | debconf-set-selections
RUN echo "percona-xtradb-cluster-server-5.7   percona-xtradb-cluster-server-5.7/re-root-pass  password lamtv10" | debconf-set-selections



#RUN apt-cache serach percona



RUN apt-get -y  install percona-xtradb-cluster-57

RUN  mkdir -p   /var/run/mysqld  && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld  &&  chmod 777 /var/run/mysqld


COPY mysql_sudoers /etc/sudoers.d/mysql_sudoers

COPY copy_file.sh /usr/local/bin/copy_file.sh
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/*.sh


EXPOSE 3306 4567 4568

LABEL vendor=Percona
LABEL com.percona.package="Percona XtraDB Cluster"
LABEL com.percona.version="5.7"
VOLUME [ "/var/lib/mysql/", "/var/log/", "/etc/mysql/" ]

USER 1011

CMD ["start.sh"]

