{{ config(materialized='table') }}

WITH date_series AS (
    SELECT 
        CAST(generate_series('2015-01-01'::date, '2024-12-31'::date, '1 day'::interval) AS DATE) AS date_actual
)

SELECT
    TO_CHAR(date_actual, 'YYYYMMDD')::INT AS date_key,
    date_actual,
    EXTRACT(YEAR FROM date_actual) AS year,
    EXTRACT(QUARTER FROM date_actual) AS quarter,
    EXTRACT(MONTH FROM date_actual) AS month,
    TO_CHAR(date_actual, 'Month') AS month_name,
    EXTRACT(DAY FROM date_actual) AS day,
    EXTRACT(DOW FROM date_actual) AS day_of_week, -- 0 for Sunday, 1 for Monday, ..., 6 for Saturday
    TO_CHAR(date_actual, 'Day') AS day_of_week_name,
    EXTRACT(WEEK FROM date_actual) AS week_of_year,
    EXTRACT(DOY FROM date_actual) AS day_of_year,
    CASE 
        WHEN EXTRACT(DOW FROM date_actual) IN (0, 6) THEN TRUE 
        ELSE FALSE 
    END AS is_weekend
FROM 
    date_series
ORDER BY
    date_actual