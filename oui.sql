create or replace table oui as select * from read_csv('/usr/share/ieee-data/oui.csv', header=true);

select count(*) as c,split(resp_l2_addr,':')[1:3] as v,sum(resp_ip_bytes),(select "Organization name" from oui where Assignment = list_aggregate(v,'string_agg','')) from c where local_resp is true group by v having count(*) > 2 order by c;

select count(*) as c,split(resp_l2_addr,':')[1:3] as v,sum(resp_ip_bytes),(select "Organization name" from oui where Assignment = list_aggregate(v,'string_agg','')) as org from c where local_resp is true group by v having len(org) > 0 order by c;
