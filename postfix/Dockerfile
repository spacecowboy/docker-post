FROM debian:jessie

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -q update
RUN apt-get -qy upgrade
RUN apt-get -qy remove exim4
RUN apt-get -qy install postfix postfix-pgsql
RUN apt-get autoclean && rm -rf /var/lib/apt/lists/*

RUN postfix stop

# TODO config stuff

# TODO wrapper script?

# TODO -c configdir
RUN cat /etc/postfix/master.cf
RUN echo "---------"
RUN cat /etc/postfix/main.cf
