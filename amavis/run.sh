#!/bin/bash -eu

# Enable pyzor and razor
sudo -u amavis razor-admin -create
sudo -u amavis razor-admin -register
sudo -u amavis pyzor discover

# Start service to update db daily
service clamav-freshclam start

# Make sure spamassassin database has correct permissions
chown -R amavis:amavis /var/spamassassin/bayes_db

# Start amavis
/etc/init.d/amavis stop
/etc/init.d/amavis start

# Print actual config
cat /etc/amavis/conf.d/50-user
cat /etc/spamassassin/local.cf

# Start antivirus scanner
echo "Small delay before starting clam: 10"
sleep 10

service clamav-daemon start

# Follow log
tail -f /var/log/amavis.log
