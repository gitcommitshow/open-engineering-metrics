# Open Engineering Metrics

A dbt project to calculate metrics every Engineering Manager neeed

**Roadmap**

- [ ] DORA Metrics - WIP
- [x] PR Lifecycle Metrics

![github_metrics_dashboard_short](https://github.com/gitcommitshow/open-engineering-metrics/assets/56937085/6c5bfb54-b09f-4c21-a21f-d4071a0c59f5)


## Data Sources

- GitHub events data (following [RudderStack Event Specification](https://www.rudderstack.com/docs/event-spec/standard-events/))

## Setup guide : From data collection to transformation to visualization

### 1. Set up a database
You can set up any database and configure to use with this project. If you don't have any central data warehouse set up for all your organization data, the recommended method with the least changes required would be to set up a Postgres database. The easiest way to do this is via a serverless instance of [Neondb](https://neon.tech/github), the free tier is enough for this project.

### 2. Set up data collection

- The recommended method to collect data is via [RudderStack](http://github.com/rudderlabs/rudder-server), a Customer Data Platform. You may either self-host it or use the free tier of [RudderStack Cloud](https://www.rudderstack.com/docs/get-started/rudderstack-cloud/) which is enough for this use case.
- Once the RudderStack is set up, add a [webhook source](https://www.rudderstack.com/docs/sources/event-streams/cloud-apps/webhook-source/)
- Copy the webhook url received in the earlier step and configure this in your GitHub repos or organizations which needs to be analyzed. Here's a [quick guide](https://docs.github.com/en/webhooks/using-webhooks/creating-webhooks) on how to do that. tl;dr: Go to `Repo settings > Webhook`,  and fill in the webhook url from the last step in `Payload URL`, choose `application/json`, submit to add webhook. 
- Now you should have events flowing to RudderStack. But they're still not reaching your database. So add the database [destination in RudderStack connections](https://www.rudderstack.com/docs/destinations/overview/). For Postgres, follow [this guide](https://www.rudderstack.com/docs/destinations/warehouse-destinations/postgresql/).

Now, any event that occurs in your GitHub repo is being sent to your database and stored in appropriate tables in the [RudderStack standard events format](https://www.rudderstack.com/docs/event-spec/standard-events/).

### 3. Set up transformations

- Clone this repository
- [Install dbt-core](https://docs.getdbt.com/docs/core/pip-install), the quickest one - `python -m pip install dbt-core`
- Configure database with dbt. For Postgres, follow [this guide](https://docs.getdbt.com/docs/core/connect-data-platform/postgres-setup). 
tl;dr: Install the dbt adapter for your database e.g. `python -m pip install dbt-postgres` and configure databse credentials in your `~/.dbt/profiles.yml`
- `dbt run` when you want to analyze your GitHub repo data. Set up a cron job to run this periodically, once everyday is good enough for our use case.

Now, the models will be saved in your database. You can use those for  visualization.

### 4. Set up visualiuzation

You may use Grafana for visualization. Detailed instructions for this coming soon...

----

NOTE: All the recommended technologies (dbt, Postgres/Neon, RudderStack) in this project are Open Source, allowing full control over data. 
They all have generous free tiers as well (without credit card) allowing easy and quick setup.
