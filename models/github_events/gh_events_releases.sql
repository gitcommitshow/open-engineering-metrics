{{ config(materialized='view') }}

with gh_events_releases as (

    SELECT
        context_properties ->> 'action' AS action,
        (context_properties -> 'release') ->> 'tag_name' AS tag_name,
        context_properties ->> 'release' AS release,
        context_properties ->> 'sender' AS sender,
        context_properties ->> 'repository' AS repository,
        sent_at
    FROM {{ source('github_events', 'webhook_source_event') }}
    WHERE 
      context_properties ? 'release'

)

select *
from gh_events_releases