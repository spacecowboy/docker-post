#!/bin/bash -eu

# Opendkim, if nothing has been mounted. You can also mount
# SigningTable and so on if you want to sign with multiple
# keys.
# Default KeyTable assumes mail.private will be used
# to sign everything, and that it is identified by 'omnikey'
# in SigningTable.
#
# Generate key if needed.
mkdir -p /etc/opendkim/keys/$mydomain
if [ ! -f "/etc/opendkim/keys/$mydomain/mail.private" ]; then
  pushd /etc/opendkim/keys/$mydomain
  opendkim-genkey --subdomains --domain=$mydomain --selector=mail
  popd
fi
# Print public key
if [ -f "/etc/opendkim/keys/$mydomain/mail.txt" ]; then
  echo "OpenDKIM public key:"
  cat /etc/opendkim/keys/$mydomain/mail.txt
fi
# Write to KeyTable if necessary
if [ ! -f "/etc/opendkim/KeyTable" ]; then
  echo "omnikey $mydomain:mail:/etc/opendkim/keys/$mydomain/mail.private" > /etc/opendkim/KeyTable
fi
# chown entire directory
chown -R opendkim:opendkim /etc/opendkim/
# And make sure permissions are right
chmod -R 0700 /etc/opendkim/keys/

# Opendkim:
cat /etc/opendkim.conf
echo ""
echo "TrustedHosts"
cat /etc/opendkim/TrustedHosts
echo ""
echo "SigningTable"
cat /etc/opendkim/SigningTable
echo ""
echo "KeyTable"
cat /etc/opendkim/KeyTable

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

# Symlinks are not enough, they have to be copied
cp -f /etc/services /var/spool/postfix/etc/services
cp -f /etc/hosts /var/spool/postfix/etc/hosts
cp -f /etc/localtime /var/spool/postfix/etc/localtime
cp -f /etc/nsswitch.conf /var/spool/postfix/etc/nsswitch.conf
cp -f /etc/resolv.conf /var/spool/postfix/etc/resolv.conf

# Report obvious mistakes
postfix check

# Print during dev
grep '^[^#]' /etc/postfix/master.cf

# This needs to be correct
rm -f /etc/mailname
echo "$myhostname" > /etc/mailname

# Restart dkim
service opendkim restart
# Restart postfix
postfix start
postfix reload
# Restart syslog
service rsyslog restart

# And track mail log
tail -f /var/log/mail.log
