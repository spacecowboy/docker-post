#!/bin/bash -eu

if [ $# -lt 3 ]; then
  echo "Usage: addmailuser.sh [-i/u] bob example.com averysecretpassword"
  echo ""
  echo "Example, insert new user:"
  echo "addmailuser.sh bob example.com apassword"
  echo ""
  echo "Example, update password:"
  echo "addmailuser.sh -u bob example.com newpassword"
  exit 1
fi

MODE="-i"
if [ $# -eq 4 ]; then
  MODE="$1"
  shift
fi

NAME=$1
DOMAIN=$2
PW=$3

# Generate password hash with dovecot
# Do NOT add -t here, Docker appends a carriage return then \r
PWHASH=$(sudo docker exec -i dovecot doveadm pw -s SHA512-CRYPT -p $PW)

SQL=""
if [ "-u" = "$MODE" ]; then
  SQL="UPDATE users SET password='$PWHASH' WHERE name='$NAME' and domain='$DOMAIN';"
else
  SQL="INSERT INTO users (name, domain, password) VALUES ('$NAME', '$DOMAIN', '$PWHASH');"
fi

echo "$SQL"

# Insert or Update into database
sudo docker exec -it postgres \
     psql mail -c "$SQL"
