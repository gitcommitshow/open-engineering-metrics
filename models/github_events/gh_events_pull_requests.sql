{{ config(materialized='view') }}

with gh_events_pull_requests as (

    SELECT
        context_properties ->> 'action' AS action,
        (context_properties ->> 'pull_request')::json AS pull_request,
        (context_properties ->> 'sender')::json AS sender,
        (context_properties ->> 'repository')::json AS repository,
        sent_at
    FROM {{ source('github_events', 'webhook_source_event') }}
    WHERE 
      context_properties ? 'number' AND 
      context_properties ? 'pull_request'

)

select 
    (pull_request ->> 'id')::text AS id,
    (pull_request ->> 'html_url')::text AS html_url,
    (pull_request ->> 'number')::integer AS number,
    (pull_request ->> 'title')::text AS title,
    (pull_request ->> 'created_at')::timestamp AS created_at,
    (pull_request ->> 'merged_at')::timestamp AS merged_at,
    *
from gh_events_pull_requests