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
     case   when special_features like '%Deleted Scenes%' then 1 else 0 end as is_deleted,
     case   when special_features like '%Behind the Scenes%'  then 1 else 0 end as is_behind_the_Scenes,
     case   when special_features like '%Commentaries%'  then 1 else 0 end as is_ommentaries,
     case   when special_features like '%Trailers%'  then 1 else 0 end as is_Trailers
from stg2.film f
left join stg2.language l on l.language_id = f.language_id
left join stg2.film_category fc on fc.film_id = f.film_id
left join stg2.category c on c.category_id = fc.category_id