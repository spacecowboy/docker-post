#!/bin/bash -eu

if [ $# -ne 3 ]; then
  echo "Usage: addmailuser.sh bob example.com averysecretpassword"
  exit 1
fi

# Create a password hash from the given password
PWSTRING=$(doveadm pw -s SHA512-CRYPT -p "$2")

VAL1="'""$1""'"
VAL2="'""$2""'"
VAL3="'""$PWSTRING""'"

# Insert it into the database
PGPASSWORD='Cqg2amU7SY' psql -h postgres -U mail mail -c \
          "INSERT INTO users (name, domain, password) \
           VALUES ($VAL1, $VAL2, $VAL3)"
