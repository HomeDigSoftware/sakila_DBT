{{ dbt_utils.union_relations(
    relations=[ref('dim_customer_new'), source('stg2', 'customer')]
    ,exclude=["store_id"]
    ,column_override={'customer_id': 'varchar(100)' }
    ,where='active = 1'
) }}