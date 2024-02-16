#!/bin/sh

# usage: zeem2duckdb.sh [yyyy-mm-dd]

date=$( ls -td zeek/* | head -1 | cut -d/ -f2 )
test ! -z "$1" && date=$1
DB=zeek-$date.duckdb

what="create or replace table c as"
test -e $DB && what="insert into c"


duckdb() {
	echo $@ | ./duckdb $DB
}

ls zeek/$date/conn.* | while read file ; do

	found=$( test -f $DB && ./duckdb -csv --noheader $DB "select count(*) as found from c where filename = '$file' ;" | tail -1 | grep -v '^\.' )

	test -z "$found" && found=0

	if [ "$found" = "0" ] ; then

		echo "$what select to_timestamp(ts) as ts,orig_h,orig_p,resp_h,resp_p,proto,service,duration,orig_bytes,resp_bytes,conn_state,local_orig,local_resp,missed_bytes,history,orig_pkts,orig_ip_bytes,resp_pkts,resp_ip_bytes,tunnel_parents,vlan,inner_vlan,orig_l2_addr,resp_l2_addr, filename
from read_csv('$file',ignore_errors=true,skip=8,nullstr='-',filename=true,names=[ts,uid,orig_h,orig_p,resp_h,resp_p,proto,service,duration,orig_bytes,resp_bytes,conn_state,local_orig,local_resp,missed_bytes,history,orig_pkts,orig_ip_bytes,resp_pkts,resp_ip_bytes,tunnel_parents,vlan,inner_vlan,orig_l2_addr,resp_l2_addr]); \
" | ./duckdb $DB

		what="insert into c"

	else
		echo "SKIP $file [$found]"
	fi

done

#./duckdb $DB "copy c to 'zeek-$date.parquet'"
