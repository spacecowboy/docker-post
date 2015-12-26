#!/bin/bash -eu

if [ $# -ne 1 ]; then
  echo "Usage: addmaildomain.sh example.com"
  echo ""
  echo "Example, insert new domain:"
  echo "addmaildomain.sh example.com"
  exit 1
fi

DOMAIN="$1"

SQL="INSERT INTO domains (domain) VALUES ('$DOMAIN')"

echo "$SQL"

# Insert into database
sudo docker exec -it postgres \
     psql mail -c "$SQL"
