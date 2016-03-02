#!/bin/bash -eu

if [ $# -ne 4 ]; then
  echo "Usage: addmailalias.sh alias-name alias.domain.com name domain"
  echo ""
  echo "Example, insert new alias for bob@example.com:"
  echo "addmailalias.sh smith alias.com bob example.com"
  exit 1
fi

ANAME="$1"
ADOMAIN="$2"
NAME="$3"
DOMAIN="$4"

SQL="INSERT INTO alias (name, domain, aka_name, aka_domain) VALUES ('$ANAME', '$ADOMAIN', '$NAME', '$DOMAIN')"

echo "$SQL"

# Insert into database
sudo docker exec -it $(docker-compose ps -q postgres) \
     psql mail -c "$SQL"
