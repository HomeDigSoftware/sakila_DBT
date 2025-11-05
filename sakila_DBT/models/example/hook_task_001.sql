{{config(
   pre_hook=[{"sql": "create table if not exists dwh.fact_log (id int, run_at timestamp, time_test timestamp)", "TRANSACTION": false}],
   post_hook='insert into dwh.fact_log (run_at, time_test) values (current_timestamp, now())'
)}}

select
*
from dwh.fact_log