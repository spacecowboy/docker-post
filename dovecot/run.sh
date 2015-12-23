#!/bin/bash -eu

# Set the postmaster address. This is required for lmtp to function.
sed -i -e \
    "s/example.com/$mydomain/" \
    /etc/dovecot/dovecot.conf

# Print config values which differs from default
doveconf -n

# Start dovecot
dovecot

# And follow logs
tail -f /var/log/dovecot.log
