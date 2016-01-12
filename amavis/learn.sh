#!/bin/bash -eu

# Need to be readable to amavis
chmod -R 755 /var/vmail/*/*

echo "Looking at spam..."
sudo -u amavis /usr/bin/sa-learn --spam /var/vmail/*/*/mail/.Junk/{cur,new}/*

# Learn ham (place false positives here, auto-learn should make sure
# you learn enough ham normally)
echo "Looking at ham..."
sudo -u amavis /usr/bin/sa-learn --ham /var/vmail/*/*/mail/.NotJunk/{cur,new}/*

# Restore permissions
chmod -R 700 /var/vmail/*/*
