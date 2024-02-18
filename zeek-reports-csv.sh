
# filter csv output to work with
# https://github.com/grafana/grafana-csv-datasource

time ./duckdb -init /dev/null -header -csv zeek-full.duckdb \
	"select time_bucket('3 seconds',ts) as t,count(*) as c, sum(orig_ip_bytes) as o_b, sum(resp_ip_bytes) as r_b from cm GROUP by t order by t;" \
	| sed -e 's/"//' -e 's/+01"//' \
	| tee csv/zeek-conn-c-b.csv | wc -l

#./duckdb -batch -stats -unredacted -header -csv zeek-full.duckdb \
time ./duckdb -init /dev/null -header -csv zeek-full.duckdb \
	"select time_bucket('5 seconds',ts) as t,count(*) as c from cm GROUP by t order by t;" \
	| sed -e 's/"//' -e 's/+01"//' \
	| tee csv/zeek-conn-c.csv | wc -l

rsync -rav csv/*.csv black:/var/www/csv/
