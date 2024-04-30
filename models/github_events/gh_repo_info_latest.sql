{{ config(materialized='view') }}

with gh_repo_info_latest as (

    SELECT DISTINCT ON (context_properties->'repository'->>'id')
        (context_properties -> 'repository') ->> 'html_url' AS html_url,
        (context_properties -> 'repository') ->> 'stargazers_count' AS stargazers_count,
        (context_properties -> 'repository') ->> 'open_issues_count' AS open_issues_count,
        (context_properties -> 'repository') ->> 'watchers_count' AS watchers_count,
        (context_properties -> 'repository') ->> 'forks_count' AS forks_count,
        context_properties ->> 'sender' AS sender,
        context_properties ->> 'repository' AS repository,
        sent_at
    FROM {{ source('github_events', 'webhook_source_event') }}
    WHERE 
      context_properties ? 'repository'
    ORDER BY (context_properties->'repository'->>'id'), sent_at DESC

)

select *
from gh_repo_info_latest