{{config(
    unique_key='payment_id'
)}}


select
    *
from {{source('stg2', 'payment')}}