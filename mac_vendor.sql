create table mac_vendor as select * from read_csv('mac_vendor.csv');

select min(resp_l2_addr),sum(orig_ip_bytes) as o,sum(resp_ip_bytes) as r,(select "Vendor Name" from mac_vendor where upper(left(resp_l2_addr,len("Mac Prefix"))) = "Mac Prefix") as org from c where ts > '2024-02-16 02:00:00' and ts < '2024-02-16 03:00:00' group by org order by o desc ;
