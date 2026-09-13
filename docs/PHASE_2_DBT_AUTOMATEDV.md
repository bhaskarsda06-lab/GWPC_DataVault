# Phase 2 - dbt + AutomateDV + Staging

## Objective

Connect dbt to Databricks, install AutomateDV, define GWPC sources, and create
the staging layer.

## File creation order

1. `dbt_project.yml`
2. `packages.yml`
3. local `profiles.yml` copied from `profiles.yml.example`
4. `models/staging/_sources.yml`
5. staging models
6. `models/staging/schema.yml`

## Commands

Activate the environment:

```cmd
cd C:\GWPC_DataVault
.venv\Scripts\activate
```

Install dependencies:

```cmd
pip install -r requirements.txt
```

Install AutomateDV:

```cmd
dbt deps
```

Check the connection:

```cmd
dbt debug --target dev
```

Parse the project:

```cmd
dbt parse --target dev
```

List models:

```cmd
dbt ls --target dev
```

Build only staging:

```cmd
dbt build --select tag:staging --target dev
```

## Important

Phase 2 does not create Hubs, Links, or Satellites.

Do not manually execute the original target DDL.

The source business logic supplied for the GWPC project is preserved as the
basis for the next Data Vault modeling phase.
