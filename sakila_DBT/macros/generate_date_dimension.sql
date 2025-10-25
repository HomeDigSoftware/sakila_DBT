{% macro generate_date_dimension(start_date, week_start_day='monday') %}
    with recursive date_series as (
        select 
            cast('{{ start_date }}' as date) as date_day
        union all
        select 
            date_day + interval '1 day'
        from date_series
        where date_day + interval '1 day' <= current_date
    )
    select
        date_day,
        extract(year from date_day) as year,
        extract(month from date_day) as month_number,
        to_char(date_day, 'Month') as month_name,
        extract(day from date_day) as day_number,
        extract(dow from date_day) as day_of_week_number,
        to_char(date_day, 'Day') as day_name,
        extract(quarter from date_day) as quarter,
        
        case 
            when lower('{{ week_start_day }}') = 'sunday' 
                then date_day - ((extract(dow from date_day) + 6) % 7) * interval '1 day'
            else 
                date_day - (extract(dow from date_day) - 1) * interval '1 day'
        end as week_start_date,
        
        case 
            when lower('{{ week_start_day }}') = 'sunday'
                then date_day + (7 - ((extract(dow from date_day) + 6) % 7) - 1) * interval '1 day'
            else 
                date_day + (7 - (extract(dow from date_day) - 1) - 1) * interval '1 day'
        end as week_end_date,

        case 
            when extract(dow from date_day) in (0,6) then true
            else false
        end as is_weekend,

        -- year-week (useful for grouping)
        to_char(date_day, 'IYYY-IW') as year_week

    from date_series
{% endmacro %}
