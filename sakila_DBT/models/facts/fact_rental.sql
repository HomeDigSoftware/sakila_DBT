{{config( unique_key='rental_id' )}}

select
    r.*,
    i.last_update as inventory_last_update,
    i.store_id,
    i.film_id,
    to_char(r.rental_date, 'YYYYMMDD') as date_key,
    round( extract(epoch from r.rental_date) / 3600,2 )::int as key_date,
    case
        when r.return_date is not null then '0'
        else '1'
    end as return_key_date
from {{ source('stg2', 'rental') }} r
left join {{ source('stg2', 'inventory') }} i on i.inventory_id = r.inventory_id

