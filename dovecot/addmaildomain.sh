#!/bin/bash -eu

if [ $# -ne 1 ]; then
  echo "Usage: addmaildomain.sh example.com"
  exit 1
fi

VAL1="'""$1""'"

# Insert it into the database
PGPASSWORD='Cqg2amU7SY' psql -h postgres -U mail mail -c \
          "INSERT INTO domains (domain) VALUES ($VAL1)"
