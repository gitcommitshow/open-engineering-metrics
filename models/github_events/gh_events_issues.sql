{{ config(materialized='view') }}

with gh_events_issues as (

    SELECT
        context_properties ->> 'action' AS action,
        (context_properties ->> 'issue')::json AS issue,
        (context_properties ->> 'sender')::json AS sender,
        (context_properties ->> 'repository')::json AS repository,
        sent_at::timestamp
    FROM {{ source('github_events', 'webhook_source_event') }}
    WHERE 
      context_properties ? 'issue'

)

select 
    (issue ->> 'id')::text AS id,
    (issue ->> 'number')::integer AS number,
    (issue ->> 'html_url')::text AS html_url,
    (issue ->> 'comments')::integer AS comments,
    (issue ->> 'created_at')::timestamp AS created_at,
    (issue ->> 'closed_at')::timestamp AS closed_at,
    *
from gh_events_issues