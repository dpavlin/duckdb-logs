#!/bin/sh -e

# import log files into duckdb

rm logs.duckdb || true
cat l.sql | ./duckdb logs.duckdb

log2duckdb() {
	logfile=$1
	site=$( echo $logfile | sed -e 's,^.*/nginx/,,' -e 's/-*access-*//' -e 's/\.log.*$//'  -e 's/-ffzg-hr//')
	echo "# $site $logfile"
	echo "insert into nginx select '$site' as site,column0 as ip,column3 as ts,column5 as url,column6 as st,column7 as len,column8 as ref,column9 as ua from read_csv_auto('$logfile',delim=' ', ignore_errors=true,dateformat='%d/%b/%Y',timestampformat='[%d/%b/%Y:%H:%M:%S',filename=true);" | ./duckdb logs.duckdb || true
}

import_logs() {
	dir=$1

	find $dir -name '*access*.log*' -size +1 | while read logfile ; do
		log2duckdb $logfile
	done
}

if [ ! -z "$1" ] ; then
	log2duckdb $1
	exit
fi

import_logs /zamd/cluster/ws1.net.ffzg.hr/1/log/nginx/
import_logs /zamd/oscar/ws2/0/var/log/nginx/
import_logs /zamd/oscar/ws3/0/var/log/nginx/

exit 1

select 'tzk' as site,column0 as ip,column3 as ts,column5 as url,column6 as st,column7 as len,column8 as ref,column9 as ua from read_csv_auto('/zamd/cluster/ws1.net.ffzg.hr/1/log/nginx/access-tzk-ffzg-hr.log',delim=' ');

select count(ip),ip,min(st),max(st),sum(len),ref from nginx group by all order by count(ip) desc limit 10 ;
