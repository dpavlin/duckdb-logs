import duckdb
from duckdb.typing import *
import sys

# based on https://github.com/duckdb/duckdb/discussions/10303

reload=0

con = duckdb.connect("geoip.duckdb")

import ipaddress

def intasipv4(ip_int: int) -> str:

    try:
       ipv4 = str(ipaddress.ip_address(ip_int))
    except AddressValueError:
       ipv4 = None
    return ipv4

def ipv4asint(ip_str: str) -> int:

    try:
       ipv4 = int(ipaddress.ip_address(ip_str))
    except AddressValueError:
       ipv4 = None
    return ipv4

con.create_function("intasipv4", intasipv4, [int], str)
con.create_function("ipv4asint", ipv4asint, [str], int)

res_str = con.sql("SELECT intasipv4(3232235521)")
res_int = con.sql("SELECT ipv4asint('192.168.0.1')")

print(res_str)
print(res_int)


con.install_extension('inet')
con.load_extension('inet')

def ip_max(ip_str: str) -> str:

    try:
       net = ipaddress.ip_network(ip_str)
       #print("##",ip_str,"->",net[0],net[-1])
       ipv4 = str(ipaddress.ip_address(net[-1]))
    except AddressValueError:
       ipv4 = None
    return ipv4

con.create_function("ip_max", ip_max, [str], str)

res_int = con.sql("SELECT ip_max('193.198.212.0/25')")

print(res_int)

print("XXX", sys.argv, len(sys.argv))

if len(sys.argv) > 1:
    if sys.argv[1] == "reload":
        print('reload')
        con.sql("create or replace table ipv4 as select * from 'geoip/GeoLite2-Country-Blocks-IPv4.csv'")
        con.sql("create or replace table loc as select * from 'geoip/GeoLite2-Country-Locations-en.csv'");
        con.sql("create or replace table ipv4m as select cast(ip_max(network) as inet) as max_ip,ipv4.* from ipv4")
        con.sql("create or replace table geoip as select ipv4m.*,loc.* from ipv4m join loc using (geoname_id)")



con.sql("select * from geoip ").show()



con.sql("select * from geoip where  '193.198.212.8'::inet > network and '193.198.212.8'::inet < max_ip ;").show();





