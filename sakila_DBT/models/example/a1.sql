{{ config(materialized='table') }}


select
    *
from stg2.city
