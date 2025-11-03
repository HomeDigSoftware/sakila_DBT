{{ config(materialized='table') }}

select
    staff_id,
    first_name,
    last_name,
    email,
    last_update,
    case
        when st.active = 'TRUE' then 1
        else 0
    end as active_int ,
    case
        when st.active = 'TRUE' then 'yes'
        else 'no'
    end as active_desc
from {{source('stg2', 'staff')}}  st