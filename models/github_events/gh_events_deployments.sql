{{ config(materialized='view') }}

with gh_events_deployments as (

    SELECT
        context_properties ->> 'action' AS action,
        (context_properties ->> 'deployment')::json AS deployment,
        (context_properties ->> 'sender')::json AS sender,
        (context_properties ->> 'repository')::json AS repository,
        sent_at::timestamp
    FROM {{ source('github_events', 'webhook_source_event') }}
    WHERE 
      context_properties ? 'deployment'

)

select 
    (deployment ->> 'id')::text AS id,
    (deployment ->> 'created_at')::timestamp AS created_at,
    (deployment ->> 'description')::text AS description,
    (deployment ->> 'environment')::text AS environment,
    (deployment ->> 'production_environment')::boolean AS production_environment,
    *
from gh_events_deployments