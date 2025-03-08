--!jinja

-- Deploy load_csv_snowflake notebook to INTEGRATIONS schema
CREATE OR REPLACE NOTEBOOK IDENTIFIER('"NOAA_DB"."{{env}}_{{schema1}}"."{{env}}_05_load_csv_snowflake"')
    FROM '@"NOAA_DB"."INTEGRATIONS"."DEMO_GIT_REPO"/branches/"{{branch}}"/notebooks/05_load_csv_snowflake/'
    QUERY_WAREHOUSE = 'NOAA_WH'
    MAIN_FILE = '05_load_csv_snowflake.ipynb';

ALTER NOTEBOOK "NOAA_DB"."{{env}}_{{schema1}}"."{{env}}_05_load_csv_snowflake" ADD LIVE VERSION FROM LAST;

-- Deploy harmonize_data notebook to INTEGRATIONS schema
CREATE OR REPLACE NOTEBOOK IDENTIFIER('"NOAA_DB"."{{env}}_{{schema2}}"."{{env}}_06_harmonize_data"')
    FROM '@"NOAA_DB"."INTEGRATIONS"."DEMO_GIT_REPO"/branches/"{{branch}}"/notebooks/06_harmonize_data/'
    QUERY_WAREHOUSE = 'NOAA_WH'
    MAIN_FILE = '06_harmonize_data.ipynb';

ALTER NOTEBOOK "NOAA_DB"."{{env}}_{{schema2}}"."{{env}}_06_harmonize_data" ADD LIVE VERSION FROM LAST;

-- Deploy analytics notebook to INTEGRATIONS schema
CREATE OR REPLACE NOTEBOOK IDENTIFIER('"NOAA_DB"."{{env}}_{{schema3}}"."{{env}}_07_analytics"')
    FROM '@"NOAA_DB"."INTEGRATIONS"."DEMO_GIT_REPO"/branches/"{{branch}}"/notebooks/07_analytics/'
    QUERY_WAREHOUSE = 'NOAA_WH'
    MAIN_FILE = '07_analytics.ipynb';

ALTER NOTEBOOK "NOAA_DB"."{{env}}_{{schema3}}"."{{env}}_07_analytics" ADD LIVE VERSION FROM LAST;