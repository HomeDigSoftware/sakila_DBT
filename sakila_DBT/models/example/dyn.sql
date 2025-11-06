{{ config(materialized='table') }}



with t1 as (
SELECT DISTINCT TRIM(BOTH '"' FROM value) AS feature
FROM stg2.film,
LATERAL unnest(
    string_to_array(        -- מפרק את הטקסט למערך
            replace(replace(special_features, '{', ''), '}', ''), -- מסיר סוגריים
                    ','                -- מפריד לפי פסיק
                        )
                        ) AS value
), t2 as(
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
), t3 as (
    select
    distinct(t1.feature)
    from t1
)
select
t3.feature,
    length(t3.feature),
    t2.special_features,
    case   when t2.special_features like '%Deleted Scenes%' then 1 else 0 end as is_deleted,
    case   when t2.special_features like '%<t3.feature>%' then 1 else 0 end as is_deleted_02,
    case   when t2.special_features like '%Behind the Scenes%'  then 1 else 0 end as is_behind_the_Scenes,
    case   when t2.special_features like '%Commentaries%'  then 1 else 0 end as is_ommentaries,
    case   when t2.special_features like '%Trailers%'  then 1 else 0 end as is_Trailers
from t1, t2, t3

