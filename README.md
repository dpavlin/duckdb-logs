Reading log files to duckdb

# Import nginx log files into duckdb

l.sql   - init schema
l.sh    - import 

# geoip.py

Read maxmind database CSV and import it into duckdb
based on https://github.com/duckdb/duckdb/discussions/10303

dpavlin@zamd:/zamd/dpavlin/duckdb-logs$ 

. /zamd/dpavlin/duckdb/venv/bin/activate
python3 geoip.py

(venv) dpavlin@zamd:/zamd/dpavlin/duckdb$ python geoip.py reload

# geo2.py

dhckdb python udf functions which use geoip2 module and mmdb

dpavlin@zamd:/zamd/dpavlin/duckdb-logs$ python -i geo2.py logs.duckdb rebuild

dpavlin@zamd:/zamd/dpavlin/duckdb-logs$ python -i geo2.py logs.duckdb
