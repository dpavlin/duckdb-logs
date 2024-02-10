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
