{{config(
    pre_hook=[{"sql": "create table if not exists DWH.pre_hook_test (id int)", "TRANSACTION": false}],
    post_hook='create table DWH.post_hook_test (id int)'
)}}

select
*
from DWH.pre_hook_test
left join DWH.post_hook_test on DWH.pre_hook_test.id = DWH.post_hook_test.id
