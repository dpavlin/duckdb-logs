import geoip2.database

import duckdb
from duckdb.typing import *

import sys

con = duckdb.connect(sys.argv[1])
con.install_extension('inet')
con.load_extension('inet')

reader = geoip2.database.Reader('geoip/GeoLite2-City.mmdb')

try:
    response = reader.city('104.128.21.34')
    print( 'iso_code', response.country.iso_code )
    print( 'name', response.country.name )
except geoip2.errors.AddressNotFoundError:
    print('error')

def g_country(ip_str: str) -> str:

    try:
        #print(ip_str)
        response = reader.city(ip_str)
        out = str(response.country.iso_code);
    except geoip2.errors.AddressNotFoundError:
        out = None
    return out

con.create_function("g_country", g_country, [str], str)

res = con.sql("SELECT g_country('193.198.212.8')")
print(res)


def g_city(ip_str: str) -> str:

    try:
        #print(ip_str)
        response = reader.city(ip_str)
        out = reader.city(ip_str).city.name
    except geoip2.errors.AddressNotFoundError:
        out = None
    return out

con.create_function("g_city", g_city, [str], str)

con.sql("SELECT g_city('193.198.212.8')").show()


r_asn = geoip2.database.Reader('geoip/GeoLite2-ASN.mmdb')

def g_asn(ip_str: str) -> str:

    try:
        #print(ip_str)
        out = r_asn.asn(ip_str).autonomous_system_organization
    except geoip2.errors.AddressNotFoundError:
        out = None
    return out

con.create_function("g_asn", g_asn, [str], str)

con.sql("SELECT g_asn('193.198.212.8')")








# re-create only with second argument
if len(sys.argv) > 2:
    print('# re-create table i')
    con.sql("create or replace table i as select distinct ip from nginx")
    con.sql("select ip,g_country(ip) from i").show()

    print('# add g_country')
    con.sql("alter table i add column g_country varchar")
    con.sql("update i set g_country=g_country(ip)")

    print('# add g_asn')
    con.sql("alter table i add column g_asn varchar")
    con.sql("update i set g_asn=g_asn(ip)")

    print('# add g_city')
    con.sql("alter table i add column g_city varchar")
    con.sql("update i set g_city=g_city(ip)")
else:
    print("## SKIP re-create")


con.sql("select count(*),site,i.g_country from nginx join i using (ip) group by site,i.g_country order by count(*) desc limit 25").show()
con.sql("select count(*),i.g_country,sum(len) from nginx join i using (ip) group by i.g_country order by count(*) desc limit 20").show()

print('# countries other than HR')
con.sql("select site,i.g_country,count(*) as hits,sum(len) as sum_len from nginx join i using (ip) where i.g_country != 'HR' group by i.g_country,site order by hits desc limit 20").show()

print('# traffic from outside HR')
con.sql("select site,i.g_country,count(*) as hits,sum(len) as sum_len from nginx join i using (ip) where i.g_country != 'HR' group by i.g_country,site order by sum_len desc limit 20").show()

con.sql("select site,i.g_country,count(*) as hits,bar(count(*),50000,500000,10) as hbar ,sum(len) as sum_len from nginx join i using (ip) where i.g_country != 'HR' group by i.g_country,site order by hits desc limit 20").show()

con.sql("select ip,i.g_country,count(*) as hits,bar(sum(len),899596907,4459835002,10) as hbar ,sum(len) as sum_len from nginx join i using (ip) where i.g_country != 'HR' group by i.g_country,ip order by sum_len desc limit 20").show()

con.sql("select min(ip),max(ip),i.g_asn,count(*) as hits,bar(sum(len),2392228908,97177038409,10) as hbar ,sum(len) as sum_len from nginx join i using (ip) where i.g_country != 'HR' group by i.g_asn order by sum_len desc limit 20").show()

#con.sql("")

