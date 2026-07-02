SELECT
     movie_id,
     tag_id,
     relevace_score
 FROM {{ ref('fct_genome_scores') }}
 WHERE relevace_score <= 0