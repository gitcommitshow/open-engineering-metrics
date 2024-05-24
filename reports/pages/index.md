---
title: Welcome to Open Engineering Metrics
---


```sql repo
  select
    *
  from gh_repo_info_latest
```


<br/>
These are the metrics for GitHub repo : <Value data={repo} column=html_url />
<br/><br/>

<BigValue 
title="GitHub Watchers"
data={repo}
value=watchers_count
sparkline=sent_at
comparisonTitle="vs. Last Month"
/>

<BigValue 
title="Forks"
data={repo}
value=forks_count
sparkline=sent_at
comparisonTitle="vs. Last Month"
/>

<BigValue 
title="Open Issues"
data={repo}
value=open_issues_count
sparkline=sent_at
comparisonTitle="vs. Last Month"
/>

<BigValue 
title="Forks"
data={repo}
value=forks_count
sparkline=sent_at
comparisonTitle="vs. Last Month"
/>

---

<br/>

```sql pull_requests
  SELECT DISTINCT ON (number)
    number,
    title,
    action,
    created_at,
    merged_at,
    sent_at,
    html_url,
    pull_request,
    sender,
    repository
  FROM
    gh_events_pull_requests
  ORDER BY
    number, sent_at DESC
```

```sql open_pull_request_count
  SELECT count(*) as count
  FROM (
    SELECT DISTINCT ON (number)
      *
    FROM
      gh_events_pull_requests
    ORDER BY
      number, sent_at DESC
  ) as latest_entries
  WHERE
    merged_at is null
```


<BigValue 
title="Open Pull Requests"
data={open_pull_request_count}
value=count
/>

<br/>
<DataTable data={pull_requests} search=true/>

<br/>

```sql pull_requests_by_day
  SELECT
    date_trunc('day', created_at) as day,
    count(*) as count
  FROM
    gh_events_pull_requests
  GROUP BY
    date_trunc('day', created_at)
```

<br/>

<CalendarHeatmap
    data={pull_requests_by_day}
    date=day
    value=count
    title="New PR Heatmap"
    subtitle="Daily New PRs"
    yearLabel=false
/>

<br/><br/>