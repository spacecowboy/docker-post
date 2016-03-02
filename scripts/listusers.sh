#!/bin/bash -eu

SQL="SELECT * FROM users"

sudo docker exec -it $(docker-compose ps -q postgres) \
     psql mail -c "$SQL"
