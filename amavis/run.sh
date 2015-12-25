#!/bin/bash -eu

# Enable pyzor and razor
sudo -u amavis razor-admin -create
sudo -u amavis razor-admin -register
sudo -u amavis pyzor discover

# Restart syslog
service rsyslog restart

# Manually populate antivirus db
sudo -u clamav freshclam

# Start service to update db daily
service clamav-freshclam start

# Start antivirus scanner
service clamav-daemon start

# Start amavis
/etc/init.d/amavis stop
/etc/init.d/amavis start

# Follow log
tail -f /var/log/mail.log
