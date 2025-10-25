
{% macro generate_date_dimension(start_date, week_start_day='sunday') %}
    with recursive date_series as (
        select 
            cast('{{ start_date }}' as date) as date_day
        union all
        select 
            cast(date_day + interval '1 day' as date)
        from date_series
        where date_day + interval '1 day' <= current_date
    )
    select
        date_day,
        extract(year from date_day) as year,
        extract(month from date_day) as month_number,
        trim(to_char(date_day, 'Month')) as month_name,
        extract(day from date_day) as day_number,
        extract(dow from date_day) as day_of_week_number,
        trim(to_char(date_day, 'Day')) as day_name,
        extract(quarter from date_day) as quarter,

        -- תחילת השבוע לפי יום ראשון
        case 
            when lower('{{ week_start_day }}') = 'sunday' 
                then date_day - extract(dow from date_day) * interval '1 day'
            else 
                date_day - (extract(dow from date_day) - 1) * interval '1 day'
        end as week_start_date,

        -- סוף השבוע לפי יום ראשון (שבת)
        case 
            when lower('{{ week_start_day }}') = 'sunday'
                then date_day + (6 - extract(dow from date_day)) * interval '1 day'
            else 
                date_day + (7 - (extract(dow from date_day) - 1) - 1) * interval '1 day'
        end as week_end_date,

        -- שישי ושבת כסוף שבוע
        case 
            when extract(dow from date_day) in (5, 6) then true
            else false
        end as is_weekend,

        to_char(date_day, 'IYYY-IW') as year_week

    from date_series
{% endmacro %}
