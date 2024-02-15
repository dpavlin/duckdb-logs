#!/bin/sh -e

DB=zeek.duckdb
what="create or replace table c as"

duckdb() {
	echo $@ | ./duckdb $DB
}

find zeek/2024-02-15 -name 'conn.*' | while read file ; do

found=$( ./duckdb -csv --noheader zeek.duckdb "select count(*) as found from c where filename = '$file' ;" )

	if [ "$found" = 0 ] ; then

echo "$what select * \
from read_csv('$file',ignore_errors=true,skip=8,filename=true,names=[ts,uid,orig_h,orig_p,resp_h,resp_p,proto,service,duration,orig_bytes,resp_bytes,conn_state,local_orig,local_resp,missed_bytes,history,orig_pkts,orig_ip_bytes,resp_pkts,resp_ip_bytes,tunnel_parents,vlan,inner_vlan,orig_l2_addr,resp_l2_addr]); \
" | ./duckdb $DB
what="insert into c"

	else
		echo "SKIP $file"
	fi

done
