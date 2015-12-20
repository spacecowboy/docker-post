FROM debian:jessie

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -q update
RUN apt-get -qy upgrade
RUN apt-get -qy remove exim4
RUN apt-get -qy install postfix postfix-pgsql rsyslog telnet postgresql-client
RUN apt-get autoclean && rm -rf /var/lib/apt/lists/*

RUN postfix stop

RUN touch /var/log/mail.log

# Override these from the commandline when running the container
#ENV myhostname="mail.example.com"
#ENV mydomain="example.com"

COPY main.cf /etc/postfix/main.cf
COPY master.cf /etc/postfix/master.cf
COPY pgsql-domains.cf /etcd/postfix/pgsql-domains.cf
COPY pgsql-aliases.cf /etcd/postfix/pgsql-aliases.cf

COPY run.sh /usr/local/bin/run.sh

CMD /usr/local/bin/run.sh
