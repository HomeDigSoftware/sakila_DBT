{{ config(materialized='table') }}


select 
     f.*,
     l.name as lang,
     c.category_id, 
     c.name as category_name,
     case 
        when f.length > 120 then 'long'
        when f.length <= 75 then 'short'
        else 'medium'
     end as film_length,
     cardinality(string_to_array(trim(both '{}' from f.special_features), ',')) as f_count
from stg2.film f
left join stg2.language l on l.language_id = f.language_id
left join stg2.film_category fc on fc.film_id = f.film_id
left join stg2.category c on c.category_id = fc.category_id
