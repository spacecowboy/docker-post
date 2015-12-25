#!/bin/bash -eu

# Postfix does not resolv hostnames with /etc/hosts
DOVECOTIP=$(getent hosts dovecot | awk '{ print $1 }')
AMAVISIP=$(getent hosts amavis | awk '{ print $1 }')

# Fix lmtp host
sed -i -e "s/lmtp:inet:.*:24/lmtp:inet:[$DOVECOTIP]:24/" /etc/postfix/main.cf
# Fix auth host
sed -i -e "s/dovecot-ip/$DOVECOTIP/" /etc/postfix/master.cf
# Fix amavis ip
sed -i -e "s/amavis-ip/$AMAVISIP/" /etc/postfix/master.cf

# Override these environment variable to your desired main domain
postconf -e myhostname="$myhostname"
postconf -e mydomain="$mydomain"

# Print during dev
postconf -n

postfix check

# Print during dev
grep '^[^#]' /etc/postfix/master.cf

# This needs to be correct
rm -f /etc/mailname
echo "$myhostname" > /etc/mailname

# Restart postfix
postfix start
postfix reload
# Restart syslog
service rsyslog restart

# And track mail log
tail -f /var/log/mail.log
