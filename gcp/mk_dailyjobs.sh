#!/bin/bash

# make /etc/cron.d/dailyjobs

sh /root/gcp/gcp_start.sh

sh /root/gcp/gcp_stop.sh

rdir=/root/gcp
log="$rdir"/log_start.log
start_cron_list="$rdir"/start_cron_list
stop_cron_list="$rdir"/stop_cron_list
cron_tmp="$rdir"/dailyjobs.bk
dailyjobs="$rdir"/dailyjobs
cron=/etc/cron.d/dailyjobs

cd "$rdir"


cp -f "$cron_tmp" "$dailyjobs"
cat "$start_cron_list" >> "$dailyjobs"
cat "$stop_cron_list" >> "$dailyjobs"

cp -f "$dailyjobs" "$cron"

rm -f "$dailyjobs"
rm -f "$start_cron_list"
rm -f "$stop_cron_list"

date
echo "   updated dailyjobs"
