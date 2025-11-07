{% macro log_dbt(table_name, log_type) %}
    {% set insert_query %}
        INSERT INTO dwh.fact_logs 
            (model_name, full_time, run_type)
        VALUES 
            ('{{ table_name }}', clock_timestamp(), '{{ log_type }}')
    {% endset %}

    {% do run_query(insert_query) %}
{% endmacro %}