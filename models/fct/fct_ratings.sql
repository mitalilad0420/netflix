/* his config overwrites any config mentioned in project.yml file. 
If this would have not been defined then it would have been considered just a regulat table */
{{
    config( 
        materialized = 'incremental',
        on_schema_change = 'fail'
    )
}}

WITH src_ratings AS (
    SELECT * FROM {{ ref('src_ratings') }}
)

SELECT 
    user_id,
    movie_id,
    rating,
    rating_timestamp
FROM src_ratings
WHERE rating IS NOT NULL

{% if is_incremental() %}
  AND rating_timestamp > (SELECT MAX(rating_timestamp) FROM {{ this }})
{% endif %}

/* This block implements the incremental logic. the fct_ratings table has the rating timestamp from the last dbt model run. 
So when the new row comes in, rating_timestamp from src_ratings is compared with MAX(rating_tiemstamp from fct ratings). 
If the value is greater then that row from source will be updated in the fct table 
eg. if fct table has timestamp of 5pm and new row in src_ratings has timestamp of 6pm, then that will be captured as incremental value

To tets this change,
1. Chnage src ratings from view to table so we can insert new row
2. run the src ratings model
3. run the fct ratings model after insering a new row wih latest rating timestamp*/