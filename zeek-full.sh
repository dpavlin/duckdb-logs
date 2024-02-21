#!/bin/sh -xe

if [ ! -e zeek-full.duckdb ] ; then
	echo "# rebuild database"
	time ./duckdb -init zeek-attach.sql zeek-full.duckdb "create table cm as select * from c "

	exit 0
fi

time ./duckdb -init zeek-attach.sql zeek-full.duckdb "insert into cm select * from c where filename in (select filename from c where filename not in (select filename from cm)) order by filename ;" 
exit

&

pid=$!
echo kill -9 $pid
pidstat -R -s -t -u -h -H -p $pid -r -d 1 | tee pidstat.$pid
