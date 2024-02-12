#!/bin/sh -e

# import apache log files into duckdb
#

log2duckdb() {
	logfile=$1
	echo "# $site $logfile"

	PREFIX="insert into apache "
	test ! -e apache.duckdb && PREFIX="create table apache as "

	#echo "insert into nginx select '$site' as site,column0 as ip,column3 as ts,column5 as url,column6 as st,column7 as len,column8 as ref,column9 as ua,filename from read_csv_auto('$logfile',delim=' ', ignore_errors=true,dateformat='%d/%b/%Y',timestampformat='[%d/%b/%Y:%H:%M:%S',filename=true);" | ./duckdb logs.duckdb || true
	# koha.ffzg.hr:443 161.53.241.124 - - [09/Feb/2024:04:36:00 +0100] "GET /cgi-bin/koha/svc/vuFind.pl?biblionumber=244277 HTTP/1.0" 200 5115 "-" "-" 2 2733094
	#echo "$PREFIX select column0 as site,column1 as ip,column5 as ts,column6 as url,column7 as st,column8 as len,column9 as ref,column9 as ua,filename from read_csv_auto('$logfile',delim=' ', ignore_errors=true,dateformat='%d/%b/%Y',timestampformat='[%d/%b/%Y:%H:%M:%S',filename=true);" | tee /dev/stderr | ./duckdb apaache.duckdb || \



	echo "$PREFIX select column00 as site,column01 as ip,column04 as ts,column06 as url,column07 as st,column08 as len,column09 as ref,column10 as ua,filename from read_csv_auto('$logfile',delim=' ', ignore_errors=true,dateformat='%d/%b/%Y',timestampformat='[%d/%b/%Y:%H:%M:%S',filename=true) ;" \
	| tee /dev/stderr | ./duckdb -box apache.duckdb || (
		path=$( dirname $logfile | sed 's,/zamd/[^/]*/,/zamd/tmp/,' )
		to=$path/$( basename $logfile | sed 's/\.gz$//' )
		echo "# FIXMUP $logfile -> $to"
		gzip -cdf $logfile | sed 's/\\"//g' > $to
		lines=$( wc -l $to | cut -d' ' -f1)
		if [ -s $to ] ; then
			echo "$PREFIX select column00 as site,column01 as ip,column04 as ts,column06 as url,column07 as st,column08 as len,column09 as ref,column10 as ua,filename from read_csv_auto('$to',delim=' ', ignore_errors=true,dateformat='%d/%b/%Y',timestampformat='[%d/%b/%Y:%H:%M:%S',filename=true) ;" \
			| tee /dev/stderr | ./duckdb -box apache.duckdb || true
		else
			echo "# SKIP, zero size"
		fi

	)
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

import_logs /zamd/cluster/mjesec.ffzg.hr/0/var/log/apache2

