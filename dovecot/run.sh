#!/bin/bash -eu

# Generate certs if non have been provided
if [ ! -f /etc/ssl/certs/dovecot.pem ]; then
  openssl req -subj "/CN=$mydomain/O=BlaBla Inc./C=US" -new -x509 -days 365 \
          -nodes -out "/etc/ssl/certs/dovecot.pem" \
          -keyout "/etc/ssl/private/dovecot.pem"
fi

# Set the postmaster address. This is required for lmtp to function.
sed -i -e \
    "s/example.com/$mydomain/" \
    /etc/dovecot/dovecot.conf

# Print config values which differs from default
doveconf -n

# Start dovecot
# It might complain about set-priority (nice level)
# on newer versions of Docker. This is fine.
dovecot

# And follow logs
tail -f /var/log/dovecot.log
