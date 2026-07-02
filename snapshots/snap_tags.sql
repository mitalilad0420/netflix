{% snapshot snap_tags %}
/* new schema snapshot is added to movielens database sinc ethat's defined in below config */
{{
    config(
        target_schema='snapshots',
        unique_key=['user_id','movie_id','tag'],
        strategy='timestamp',
        updated_at='tag_timestamp',
        invalidate_hard_deletes=True
    )
}}

/* generating surrogate key for dim table for a combination of keys that exisst in source table
generate_surrogate_key() is a function available in dbt_utils that's defined in pakage.yml file */

SELECT
{{ dbt_utils.generate_surrogate_key(['user_id','movie_id','tag']) }} as row_key,
    user_id,
    movie_id,
    tag,
    CAST(tag_timestamp as TIMESTAMP_NTZ) as tag_timestamp
FROM {{ ref('src_tags') }}
LIMIT 100

{% endsnapshot %}

/* to test snapshot
1. change src_tags from view to table so we can update the row value
2. update tag and timestamp for existing user to new value 
3. run the snapshot to see the new row added as a part of SCD type 2

ROW_KEY	                            USER_ID	MOVIE_ID    TAG	                TAG_TIMESTAMP	        DBT_SCD_ID	                        DBT_UPDATED_AT	        DBT_VALID_FROM	        DBT_VALID_TO
af35238dfaa2173de479353fe8f634e9	18	    4141	    Mark Waters Retuens	2026-07-02 10:26:21.000	75b9aed59f86a0e7e06def71b61cfcf5	2026-07-02 10:26:21.000	2026-07-02 10:26:21.000	
b527b33eb0bbfafd997af4ca4a5c41e6	18	    4141	    Mark Waters	        2009-04-24 11:19:40.000	35a3a9d4993c8b770886e10f3d201ba0	2009-04-24 11:19:40.000	2009-04-24 11:19:40.000	2026-07-02 17:32:16.427
*/