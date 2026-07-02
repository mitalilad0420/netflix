with raw_links as (
    select * from {{ source('netflix', 'r_links') }}
)
select 
    movieId AS movie_id,
    imdbId AS imdb_id,
    tmdbId AS tmdb_id
from raw_links