#!/bin/bash

# generate start scripts for gcp compute instances

rdir=/root/gcp
dir="$rdir"/start
log="$rdir"/log_start.log
cron_list="$rdir"/start_cron_list
cron_log="$rdir"/start_cron.log

rm -f "$cron_list"
rm -rf "$dir"
mkdir -p "$dir"
cd "$dir"


start_instance=`gcloud compute instances list --format json | jq -r '.[] | {name: .name, items: .metadata.items[]} | select(.items.key == "starttime")'`

start_instance_list=`gcloud compute instances list --format json | jq -r '.[] | {name: .name, items: .metadata.items[]} | select(.items.key == "starttime") | .name'`

for i in `echo "$start_instance_list"`; do
	shell_name="$i"_start.sh
	shell_full="$dir"/"$shell_name"
	starttime=`echo "$start_instance" | jq -r "select (.name == \"$i\") | .items.value"`
	cron_value="$starttime root sh $shell_full >> $cron_log"


cat << EOF > "$shell_full"
#!/bin/bash
# $i
gcloud compute instances start $i
date
echo "    started $i"
EOF

	chmod 777 "$shell_full"

	echo "$cron_value" >> "$cron_list"

	date >> "$log"
	echo "made $shell_full" >> "$log"
	echo "insert start_cron_list $cron_value" >> "$log"

done

