
# filter csv output to work with
# https://github.com/grafana/grafana-csv-datasource

#./duckdb -batch -stats -unredacted -header -csv zeek-full.duckdb \
time ./duckdb -init /dev/null -header -csv zeek-full.duckdb \
	"select time_bucket('15 seconds',ts) as t,count(*) as c from cm GROUP by t order by t;" \
	| sed -e 's/"//' -e 's/+01"//' \
	| tee csv/zeek-conn-c.csv | wc -l

rsync -rav csv/*.csv black:/var/www/csv/
