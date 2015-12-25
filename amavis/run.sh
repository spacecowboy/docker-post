#!/bin/bash -eu

# Enable pyzor and razor
sudo -u amavis razor-admin -create
sudo -u amavis razor-admin -register
sudo -u amavis pyzor discover

# Fix postfix ip
POSTFIXIP=$(getent hosts postfix | awk '{ print $1 }')
sed -i -e "s/postfix-ip/$POSTFIXIP/" /etc/amavis/conf.d/50-user

# Start service to update db daily
service clamav-freshclam start

# Start antivirus scanner
service clamav-daemon start

# Start amavis
/etc/init.d/amavis stop
/etc/init.d/amavis start

# Print actual config (to see ip addresses)
cat /etc/amavis/conf.d/50-user

# Follow log
tail -f /var/log/amavis.log
