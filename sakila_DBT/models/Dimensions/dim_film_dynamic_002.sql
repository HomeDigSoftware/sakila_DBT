{{ config(materialized='table') }}

{% set features_query %}
SELECT DISTINCT TRIM(BOTH '"' FROM value) AS feature
FROM {{ source('stg2', 'film') }},
LATERAL unnest(
    string_to_array(        
            replace(replace(special_features, '{', ''), '}', ''), 
            ','                
    )
) AS value
WHERE value IS NOT NULL
{% endset %}

{%- if execute -%}
    {%- set results = run_query(features_query) -%}
    {%- set features = [] -%}
    {%- for row in results.rows -%}
        {%- do features.append(row.feature) -%}
    {%- endfor -%}
    {{ log("Features found: " ~ features, info=True) }}
{%- else -%}
    {%- set features = [] -%}
{%- endif -%}



{%- if execute -%}
    {%- set test = run_query( dbt_utils.get_query_results_as_dict(
            features_query
        )) -%}
    {%- set features_09 = [] -%}
    {%- for row in test.rows -%}
        {%- do features_09.append(row.feature) -%}
    {%- endfor -%}
    {{ log("Features found: " ~ features_09, info=True) }}
{%- else -%}
    {%- set features_09 = [] -%}
{%- endif -%}


with special_features_pivot as (
    {{ dbt_utils.pivot(
        'feature',
        features_09,
        agg='max', 
        then_value=1,
        else_value=0,
        quote_identifiers=False,
        prefix='has_feature_',
        suffix='',
        distinct=True
    ) }}
    FROM (
        SELECT 
            film_id,
            TRIM(BOTH '"' FROM value) AS feature
        FROM {{ source('stg2', 'film') }},
        LATERAL unnest(
            string_to_array(        
                replace(replace(special_features, '{', ''), '}', ''), 
                ','                
            )
        ) AS value
        WHERE value IS NOT NULL
    ) features_unpacked
    GROUP BY film_id
)

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
    sf.*
from {{ source('stg2', 'film') }} f
left join {{ source('stg2', 'language') }} l on l.language_id = f.language_id
left join {{ source('stg2', 'film_category') }} fc on fc.film_id = f.film_id
left join {{ source('stg2', 'category') }} c on c.category_id = fc.category_id
left join special_features_pivot sf on sf.film_id = f.film_id