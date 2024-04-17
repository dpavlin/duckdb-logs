#!/bin/sh -xe

DB=zeek-mac.duckdb

rm -f $DB
time ./duckdb -init zeek-attach.sql $DB "create table cm as select * from c where orig_l2_addr = '$1' or resp_l2_addr = '$1'"

