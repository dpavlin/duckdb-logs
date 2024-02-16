ls -d zeek/* | cut -d/ -f2 | xargs -i ./zeek2duckdb.sh {}
