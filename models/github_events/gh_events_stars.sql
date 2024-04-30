{{ config(materialized='view') }}

with gh_events_stars as (

    SELECT
        context_properties ->> 'action' AS action,
        context_properties ->> 'starred_at' AS starred_at,
        context_properties ->> 'sender' AS sender,
        context_properties ->> 'repository' AS repository,
        sent_at
    FROM {{ source('github_events', 'webhook_source_event') }}
    WHERE 
      context_properties ? 'starred_at'

)

select *
from gh_events_stars