.echo on
.timer on


--- [09/Feb/2024:00:00:03 +0100]
-- https://duckdb.org/docs/sql/functions/dateformat
create or replace table nginx as
select 'tzk' as site,column0 as ip,column3 as ts,column5 as url,column6 as st,column7 as len,column8 as ref,column9 as ua,filename from read_csv_auto('/zamd/cluster/ws1.net.ffzg.hr/1/log/nginx/access-tzk-ffzg-hr.log',delim=' ',ignore_errors=true,dateformat='%d/%b/%Y',timestampformat='[%d/%b/%Y:%H:%M:%S',filename=true);

-- select count(ip),ip,min(st),max(st),sum(len),ref from nginx group by all order by count(ip) desc limit 10 ;

-- select ip,count(*) as c,site,url,any_value(ua),sum(len) from nginx where st > 500 group by ip,site,url order by sum(len) desc limit 2 ;

-- delete from nginx;
