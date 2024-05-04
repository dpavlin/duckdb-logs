test -z "$LAST" && LAST=7

(

ls -tr zeek-20*.duckdb | tail -$LAST | sed "s/^zeek-\(.*\).duckdb/attach 'zeek-\1.duckdb' as c_\1 ;/" \
	| sed 's/\(c_[0-9]*\)-\([0-9]*\)-\([0-9]*\)/\1_\2_\3/' 

dates=$( ls -tr zeek-20*.duckdb | tail -$LAST | sed "s/^zeek-\(.*\).duckdb/\1/" | sed -e 's/^/select * from c_/' -e 's/$/.c union /' \
	| sed 's/\(c_[0-9]*\)-\([0-9]*\)-\([0-9]*\)/\1_\2_\3/' \
	| tr -d '\n' | sed 's/.c union $/.c ;/' )
echo "create or replace view c as $dates ;"

#echo "select orig_l2_addr, count(*) as c, sum(orig_ip_bytes) as o_b, sum(resp_ip_bytes) as r_b, min(ts), max(ts),min(vlan) from c where vlan is not null and vlan != 2 and ts > '2024-01-01' group by orig_l2_addr order by o_b;"
#echo "select count(*) as c, time_bucket('1 hour',ts) as t from c GROUP by t order by t ;"
#echo "select time_bucket('1 hour',ts) as t, count(*), bar(count(*),10000,1000000) as c from c GROUP by t order by t ;"

echo ".timer on"

) | tee zeek-attach.sql
