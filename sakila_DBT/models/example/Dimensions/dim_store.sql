{{ config(materialized='table') }}


select
    s.*,
    st.first_name,
    st.last_name,
    a.address,
    c.city,
    c.city_id,
    co.country,
    co.country_id
from stg2.store s 
join {{ref('dim_staff') }} st on st.staff_id = s.manager_staff_id
join stg2.address a on a.address_id = s.address_id
join stg2.city c on c.city_id = a.city_id
join stg2.country co on co.country_id = c.country_id