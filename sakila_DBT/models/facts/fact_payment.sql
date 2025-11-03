{{config(
    materialized='incremental',
    unique_key='pyment_id'
)}}


select
    *
from {{source('stg2', 'payment')}}