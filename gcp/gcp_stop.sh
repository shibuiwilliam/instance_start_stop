#!/bin/bash

# generate stop scripts for gcp compute instances

rdir=/root/gcp
dir="$rdir"/stop
log="$rdir"/log_stop.log
cron_list="$rdir"/stop_cron_list
cron_log="$rdir"/stop_cron.log

rm -f "$cron_list"
rm -rf "$dir"
mkdir -p "$dir"
cd "$dir"


stop_instance=`gcloud compute instances list --format json | jq -r '.[] | {name: .name, items: .metadata.items[]} | select(.items.key == "stoptime")'`

stop_instance_list=`gcloud compute instances list --format json | jq -r '.[] | {name: .name, items: .metadata.items[]} | select(.items.key == "stoptime") | .name'`

for i in `echo "$stop_instance_list"`; do
	shell_name="$i"_stop.sh
	shell_full="$dir"/"$shell_name"
	stoptime=`echo "$stop_instance" | jq -r "select (.name == \"$i\") | .items.value"`
	cron_value="$stoptime root sh $shell_full >> $cron_log"


cat << EOF > "$shell_full"
#!/bin/bash
# $i
gcloud compute instances stop $i
date
echo "    stopped $i"
EOF

	chmod 777 "$shell_full"

	echo "$cron_value" >> "$cron_list"

	date >> "$log"
	echo "made $shell_full" >> "$log"
	echo "insert stop_cron_list $cron_value" >> "$log"

done

