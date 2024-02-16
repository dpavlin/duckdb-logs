ls zeek-*.duckdb | sed "s/^zeek-\(.*\).duckdb/attach 'zeek-\1.duckdb' as c_\1 ;/" \
	| sed 's/\(c_[0-9]*\)-\([0-9]*\)-\([0-9]*\)/\1_\2_\3/' 

dates=$( ls zeek-*.duckdb | sed "s/^zeek-\(.*\).duckdb/\1/" | sed -e 's/^/select * from c_/' -e 's/$/.c union /' \
	| sed 's/\(c_[0-9]*\)-\([0-9]*\)-\([0-9]*\)/\1_\2_\3/' \
	| tr -d '\n' | sed 's/.c union $/.c ;/' )
echo "create view c as $dates ;"

echo "select orig_l2_addr, count(*) as c, sum(orig_ip_bytes) as o_b, sum(resp_ip_bytes) as r_b, to_timestamp(min(ts)::int) as from, to_timestamp(max(ts)) as to,min(vlan) from c where vlan is not null and vlan != 2 and to_timestamp(ts) > '2024-01-01' group by orig_l2_addr order by o_b;"

