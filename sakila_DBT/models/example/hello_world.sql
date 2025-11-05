{{ config(pre_hook= ["create table if not exists dwh.relearning_hooks ( id int , email varchar(150), time timestamp  ) ",
                    "insert into dwh.relearning_hooks (id, email, time) values (0, 'tt@tt.com', now())"],
          post_hook= "insert into dwh.relearning_hooks (id, email, time) values(1, 'test@example.com', now())",
          materialized='table'
) }}



select
    email
    ,'{{var("test_var")}}' as project_variable
    ,{{var("num_var")}} as num
    ,{{dbt_utils.star(
                        source('stg2', 'customer')
                        ,except=["email"]
                        ,relation_alias="c"
                        ,suffix="" )}}
from {{ source('stg2', 'customer') }} c


