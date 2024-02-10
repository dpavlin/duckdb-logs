select count(*),sum(len),ua,i.g_asn from nginx join i using (ip) where ua ilike '%bot%' or ua like '%crawl%' group by ua,g_asn order by sum(len) desc limit 20;
