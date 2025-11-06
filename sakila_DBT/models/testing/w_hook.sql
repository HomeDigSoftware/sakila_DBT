{{ config(materialized='table') }}

select
*
from {{ source('stg2', 'country') }} c