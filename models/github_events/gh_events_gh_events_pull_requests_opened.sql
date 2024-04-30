{{ config(materialized='view') }}

-- Use the `ref` function to select from other models

select *
from {{ ref('gh_events_pull_requests') }}
where action='opened'