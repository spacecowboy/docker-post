#!/bin/bash -eu

if [ $# -lt 1 ]; then
  SQL="SELECT * FROM alias"
elif [ "$1" = "-h" ]; then
  echo "Usage: listalias.sh [username [domain]]"
  exit 1
elif [ $# -eq 1 ]; then
  SQL="SELECT * FROM alias WHERE aka_name='$1'"
elif [ $# -eq 2 ]; then
  SQL="SELECT * FROM alias WHERE aka_name='$1' AND aka_domain='$2'"
fi

sudo docker exec -it $(docker-compose ps -q postgres) \
     psql mail -c "$SQL"
