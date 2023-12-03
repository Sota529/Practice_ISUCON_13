#!/bin/sh

date=`TZ="Asia/Tokyo" date '+%Y-%m-%d'`
time=`TZ="Asia/Tokyo" date '+%H-%M-%S'`

if [ -d /home/isucon/log/$time ] ;then
  hoge=piyo
else
  mkdir -p /home/isucon/log/$time
fi

mv /var/log/nginx/access.log /var/log/nginx/access.log.$time

mv /var/log/mysql/slow.log /home/isucon/log/$time/mysql-slow-$time.log
mysqladmin flush-logs

sudo sh -c "sudo mysqldumpslow -s t /home/isucon/log/$time/mysql-slow-$time.log > /home/isucon/log/$time/long_time_$time.txt"
sudo sh -c "sudo mysqldumpslow -s c /home/isucon/log/$time/mysql-slow-$time.log > /home/isucon/log/$time/many_count_$time.txt"
sudo sh -c "sudo mysqldumpslow -s at /home/isucon/log/$time/mysql-slow-$time.log > /home/isucon/log/$time/slow_query_$time.txt"

sudo sh -c "sudo cat /var/log/nginx/access.log.$time | alp json --sort=sum -r > /home/isucon/log/$time/nginx_log_alp_$time"

echo "==== rotate log files ===="

nginx -s reopen

echo "===== finish rotate ====="
echo "/home/isucon/log/$time/access.log.$time created!"
echo "/home/isucon/log/$time/long_time_$time.txt created"
echo "/home/isucon/log/$time/many_count_$time.txt created"
echo "/home/isucon/log/$time/slow_query_$time.txt created"
