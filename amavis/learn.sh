#!/bin/bash -eu

echo "Looking at spam..."
sudo -u amavis /usr/bin/sa-learn --spam /var/vmail/*/*/mail/.Junk/{cur,new}/*

# Learn ham (place false positives here, auto-learn should make sure
# you learn enough ham normally)
echo "Looking at ham..."
sudo -u amavis /usr/bin/sa-learn --ham /var/vmail/*/*/mail/.NotJunk/{cur,new}/*
