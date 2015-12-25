FROM debian:jessie

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -q update
RUN apt-get -qy upgrade
RUN apt-get -qy remove exim4

# Necessary
RUN apt-get -qy install amavisd-new spamassassin clamav-daemon

# To be able to scan inside compressed files
RUN apt-get -qy install p7zip arj bzip2 cabextract cpio file gzip \
                nomarch pax unzip zip zoo

# Optional for better spam detection
RUN apt-get -qy install libnet-dns-perl libmail-spf-perl pyzor razor


CMD bash
