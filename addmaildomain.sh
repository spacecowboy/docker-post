#!/bin/bash -eu

if [ $# -lt 1 ]; then
  echo "Usage: addmaildomain.sh [-i/-D] example.com"
  echo ""
  echo "Example, insert new domain:"
  echo "addmaildomain.sh example.com"
  echo ""
  echo "Example, delete a domain (and all related users and aliases!):"
  echo "addmaildomain.sh -D example.org"
  exit 1
fi

MODE="-i"
if [ $# -eq 2 ]; then
  MODE="$1"
  shift
fi

DOMAIN="$1"

SQL=""
if [ "-D" = "$MODE" ]; then
  SQL="DELETE FROM domains WHERE domain='$DOMAIN'"
else
  SQL="INSERT INTO domains (domain) VALUES ('$DOMAIN')"
fi

echo "$SQL"

# Run SQL
sudo docker exec -it postgres \
     psql mail -c "$SQL"
