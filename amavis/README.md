# spacecowboy/amavis

Amavis handles spam filtering and antivirus scanning. Run it with

```
docker run --rm --name=amavis \
      --net=mail_network \
      --hostname=mail.example.com \
      -v /root/mail:/var/vmail \
      -v /root/sa_db:/var/spamassassin/bayes_db \
      -t spacecowboy/amavis
```

where `--hostname` specifies the hostname of your mail server. Specify where your mails are stored instead of `/root/mail` so that spam training can be done. The results of the training is stored in a database which you want to save between runs probably, so set a suitable location for that also instead of `/root/sa_db`.

To train on spam, run

```
docker exec -t amavis /usr/local/bin/learn.sh
```

If not using the included SystemD scripts, you can add this line to
your crontab (remember to use the full path to `/usr/bin/docker` in
that case).
