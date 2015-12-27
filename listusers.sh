#!/bin/bash -eu

SQL="SELECT * FROM users"

sudo docker exec -it postgres \
     psql mail -c "$SQL"
