#!/bin/bash -eu

if [ $# -ne 4 ]; then
  echo "Usage: addmailalias.sh alias-name alias.domain.com bob example.com"
  exit 1
fi

VAL1="'""$1""'"
VAL2="'""$2""'"
VAL3="'""$3""'"
VAL4="'""$4""'"

# Insert it into the database
PGPASSWORD='Cqg2amU7SY' psql -h postgres -U mail mail -c \
          "INSERT INTO alias (name, domain, aka_name, aka_domain) \
           VALUES ($VAL1, $VAL2, $VAL3, $VAL4)"
