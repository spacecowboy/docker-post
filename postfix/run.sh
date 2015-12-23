#!/bin/bash -eu


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

# Start postgrey
service postgrey start
# Restart postfix
postfix start
postfix reload
# Restart syslog
service rsyslog restart

# And track mail log
tail -f /var/log/mail.log
