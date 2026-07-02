/* ephemeral does not create any table or view. This code is executed and results are stored 
in memory so you can reference them in any other models. Helps to keep datawarehouse clean by reducing the clutter*/

{{
    config(
        materialized = 'ephemeral'
    )
}}

WITH movies as (
    SELECT * FROM {{ ref('dim_movies') }}
),
tags as (
    SELECT * FROM {{ ref('dim_genome_tags') }}
),
scores as (
    SELECT * FROM {{ ref('fct_genome_scores')}}
)

SELECT
    m.movie_id,
    m.movie_title,
    m.genres,
    t.tag_name,
    s.relevance_score
FROM movies m
LEFT JOIN scores s on m.movie_id = s.movie_id
LEFT JOIN tags t on t.tag_id = s.tag_id