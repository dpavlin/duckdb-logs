Reading log files to duckdb

# Import nginx log files into duckdb

## l.sql

init schema from one existing log file

## l.sh

import data from log files, if run without parameters, if
one log file is specified it will be just inserted


# geo.py

Read maxmind database CSV and import it into duckdb
based on https://github.com/duckdb/duckdb/discussions/10303

dpavlin@zamd:/zamd/dpavlin/duckdb-logs$ 

. /zamd/dpavlin/duckdb/venv/bin/activate
python3 -i geo.py

(venv) dpavlin@zamd:/zamd/dpavlin/duckdb$ python geo.py reload


# geo2.py

duckdb python udf functions which use geoip2 module and mmdb

dpavlin@zamd:/zamd/dpavlin/duckdb-logs$ python -i geo2.py logs.duckdb rebuild

dpavlin@zamd:/zamd/dpavlin/duckdb-logs$ python -i geo2.py logs.duckdb
