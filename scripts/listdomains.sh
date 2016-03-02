#!/bin/bash -eu

SQL="SELECT * FROM domains"

sudo docker exec -it postgres \
     psql mail -c "$SQL"
