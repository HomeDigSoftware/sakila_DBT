{{ config(materialized='table') }}

select
c.customer_id,
c.store_id,
c.first_name,
c.last_name,
c.email,
c.create_date,
c.last_update,
c.active,
ad.address_id,
ad.address,
ad.district,
cy.city_id,
cy.city,
con.country_id,
con.country,
concat(c.first_name, ' ', c.last_name) as full_name,
substring(c.email from position('@' IN c.email) + 1) as domain,
case 
    when c.active = 1 then 'Yes'
    else 'No'
end as active_desc
from {{source('stg2', 'customer')}} c
join {{source('stg2', 'address')}} ad on ad.address_id = c.address_id
join {{source('stg2', 'city')}} cy on cy.city_id = ad.city_id
join {{source('stg2', 'country')}} con on con.country_id = cy.country_id

