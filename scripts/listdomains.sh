#!/bin/bash -eu

SQL="SELECT * FROM domains"

sudo docker exec -it $(docker-compose ps -q postgres) \
     psql mail -c "$SQL"
