FROM orgsync/base
MAINTAINER Clifton King <cliftonk@gmail.com>

ENV MYSQL_VERSION 5.6
ENV PERCONA_SERVER_VERSION 5.6.21-69.0-675.wheezy

# TODO: do we need the client package?
#   percona-server-client-5.6=5.6.21-69.0-675.wheezy

RUN apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A \
    && echo "deb http://repo.percona.com/apt wheezy main" \
            > /etc/apt/sources.list.d/percona.list \
    && apt-get update \
    && apt-get install -y \
        percona-server-server-$MYSQL_VERSION=$PERCONA_SERVER_VERSION \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

ADD my.cnf /etc/mysql/my.cnf

# bootstrap root user
RUN echo "mysqld_safe & " \
    "mysqladmin --silent --wait=30 ping || exit 1;" \
    "mysql -e 'GRANT ALL PRIVILEGES ON *.* TO \"root\"@\"%\" WITH GRANT OPTION;'" \
    | bash -e

VOLUME ["/etc/mysql", "/var/lib/mysql"]

EXPOSE 3306

CMD ["mysqld_safe"]
