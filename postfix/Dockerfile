FROM debian:jessie

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -q update
RUN apt-get -qy upgrade
RUN apt-get -qy remove exim4
RUN apt-get -qy install postfix postfix-pgsql openssl rsyslog telnet
RUN apt-get autoclean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/ssl/private/
RUN chmod 710 /etc/ssl/private
RUN openssl dhparam -out /etc/ssl/private/dhparams.pem 1024

# Log files must exist, or nothing gets written to them
RUN touch /var/log/mail.log
RUN touch /var/log/mail.err
RUN touch /var/log/mail.info
RUN touch /var/log/mail.warn

# Needed for postfix to function
RUN ln -snf /etc/services /var/spool/postfix/etc/services
RUN ln -snf /etc/hosts /var/spool/postfix/etc/hosts
RUN ln -snf /etc/localtime /var/spool/postfix/etc/localtime
RUN ln -snf /etc/nsswitch.conf /var/spool/postfix/etc/nsswitch.conf
RUN ln -snf /etc/resolv.conf /var/spool/postfix/etc/resolv.conf
RUN ln -snf /etc/ssl /var/spool/postfix/etc/ssl

# Override these from the commandline when running the container
#ENV myhostname="mail.example.com"
#ENV mydomain="example.com"

COPY main.cf /etc/postfix/main.cf
COPY master.cf /etc/postfix/master.cf
COPY pgsql-domains.cf /etc/postfix/pgsql-domains.cf
COPY pgsql-aliases.cf /etc/postfix/pgsql-aliases.cf
COPY pgsql-mailboxes.cf /etc/postfix/pgsql-mailboxes.cf

COPY run.sh /usr/local/bin/run.sh

CMD /usr/local/bin/run.sh
