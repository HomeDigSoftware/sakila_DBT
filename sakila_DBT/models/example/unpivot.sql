{{ dbt_utils.unpivot(
  relation=ref('dim_film'),
  exclude=['film_id', 'title', 'description'],
  remove=['language_id', 'original_language_id', 'rental_duration', 'rental_rate', 'length', 'replacement_cost', 'rating', 'special_features', 'last_update', 'category', 'language'],
  field_name='special_features_unpivoted',
  value_name='indicator'
) }}