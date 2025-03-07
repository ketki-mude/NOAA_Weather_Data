--!jinja

CREATE OR REPLACE NOTEBOOK IDENTIFIER('"NOAA_DB"."{{env}}_SCHEMA"."{{env}}_05_load_csv_snowflake"')
    FROM '@"NOAA_DB"."INTEGRATIONS"."DEMO_GIT_REPO"/branches/"{{branch}}"/notebooks/05_load_csv_snowflake/05_load_csv_to_snowflake.ipynb'
    QUERY_WAREHOUSE = 'NOAA_WH'
    MAIN_FILE = '05_load_csv_to_snowflake.ipynb';

ALTER NOTEBOOK "NOAA_DB"."{{env}}_SCHEMA"."{{env}}_05_load_csv_snowflake" ADD LIVE VERSION FROM LAST;

CREATE OR REPLACE NOTEBOOK IDENTIFIER('"NOAA_DB"."{{env}}_SCHEMA"."{{env}}_06_harmonize_data"')
    FROM '@"NOAA_DB"."INTEGRATIONS"."DEMO_GIT_REPO"/branches/"{{branch}}"/notebooks/06_harmonize_data/06_harmonize_data.ipynb'
    QUERY_WAREHOUSE = 'NOAA_WH'
    MAIN_FILE = '06_harmonize_data.ipynb';

ALTER NOTEBOOK "NOAA_DB"."{{env}}_SCHEMA"."{{env}}_06_harmonize_data" ADD LIVE VERSION FROM LAST;

CREATE OR REPLACE NOTEBOOK IDENTIFIER('"NOAA_DB"."{{env}}_SCHEMA"."{{env}}_07_analytics"')
    FROM '@"NOAA_DB"."INTEGRATIONS"."DEMO_GIT_REPO"/branches/"{{branch}}"/notebooks/07_analytics/07_analytics.ipynb'
    QUERY_WAREHOUSE = 'NOAA_WH'
    MAIN_FILE = '07_analytics.ipynb';

ALTER NOTEBOOK "NOAA_DB"."{{env}}_SCHEMA"."{{env}}_07_analytics" ADD LIVE VERSION FROM LAST;
