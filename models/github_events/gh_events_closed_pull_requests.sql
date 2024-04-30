{{ config(materialized='view') }}

WITH closed_pull_requests AS (
    
    SELECT DISTINCT ON ((pull_request::json ->> 'id')::text)
        (pull_request::json ->> 'id')::text AS id,
        (pull_request::json ->> 'html_url')::text AS html_url,
        (pull_request::json ->> 'number')::integer AS number,
        (pull_request::json ->> 'title')::text AS title,
        (pull_request::json ->> 'created_at')::timestamp AS created_at,
        (pull_request::json ->> 'merged_at')::timestamp AS merged_at,
        (pull_request::json ->> 'closed_at')::timestamp AS closed_at,
        (pull_request::json ->> 'state')::text AS state,
        (pull_request::json ->> 'merge_commit_sha')::text AS merge_commit_sha,
        sender::json AS sender,
        sent_at::timestamp AS sent_at
    FROM {{ ref('gh_events_pull_requests') }}
    WHERE 
        action = 'closed' AND
        (pull_request::json ->> 'merged')::boolean = true AND
        (pull_request::json ->> 'state') = 'closed' AND
        (pull_request::json ->> 'merged_at') IS NOT NULL
    ORDER BY (pull_request::json ->> 'id')::text, sent_at DESC -- Corrected ORDER BY to match DISTINCT ON
    
)

SELECT 
    *,
    merged_at - created_at AS time_to_merge,
    (EXTRACT(EPOCH FROM (merged_at - created_at)) / 3600)::integer AS time_to_merge_hours
FROM closed_pull_requests