{{ config(materialized='table') }}



select
    email
    ,'{{var("test_var")}}' as project_variable
    ,{{var("num_var")}} as num
    ,{{dbt_utils.star(
                        source('stg2', 'customer')
                        ,except=["email"]
                        ,relation_alias="c"
                        ,suffix="" )}}
from {{ source('stg2', 'customer') }}


