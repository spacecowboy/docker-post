#!/bin/bash -eu


# Override these environment variable to your desired main domain
echo "Setting: myhostname=$myhostname mydomain=$mydomain"
#cat "myhostname=$myhostname" >> /etc/postfix/main.cf
#cat "mydomain=$mydomain" >> /etc/postfix/main.cf

postconf -e myhostname="$myhostname"
postconf -e mydomain="$mydomain"

# Print during dev
postconf -n

# This needs to be correct
rm -f /etc/mailname
echo "$myhostname" > /etc/mailname

# Run postfix
postfix start

# And track mail log
tail -f /var/log/mail.log
