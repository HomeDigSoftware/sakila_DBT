select
  staff_id,
  {{ dbt_utils.pivot(
      'amount',
      dbt_utils.get_column_values(ref('fact_payment'), 'amount'),
      'SUM'
  ) }}
from {{ ref('fact_payment') }}
group by staff_id
