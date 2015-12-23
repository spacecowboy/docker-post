#!/bin/bash -eu

if [ $# -lt 3 ]; then
  echo "Usage: addmailuser.sh [-i/u] bob example.com averysecretpassword"
  exit 1
fi

MODE="-i"
if [ $# -eq 4 ]; then
  MODE="$1"
  shift
fi

# Create a password hash from the given password
PWSTRING=$(doveadm pw -s SHA512-CRYPT -p "$2")

echo "PWSTRING=$PWSTRING"

VAL1="'""$1""'"
VAL2="'""$2""'"
VAL3="'""$PWSTRING""'"

if [ "$MODE" = "-u" ]; then
  # Update the existing entry's password
  PGPASSWORD='Cqg2amU7SY' psql -h postgres -U mail mail -c \
            "UPDATE users SET password=$VAL3 \
             WHERE name=$VAL1 and domain=$VAL2"
else
  # Insert it into the database
  PGPASSWORD='Cqg2amU7SY' psql -h postgres -U mail mail -c \
            "INSERT INTO users (name, domain, password) \
             VALUES ($VAL1, $VAL2, $VAL3)"
fi
