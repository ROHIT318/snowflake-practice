-- Storage Integration: It is an object that provides a secure way to connect snowflake with external cloud storage services like Amazon S3, Google Cloud Storage and Microsoft Azure.
-- 1. An external storage is first connected with a storage integration present inside snowflake.
-- 2. Storage intergration is then connected with AWS IAM user which is used by S3.
-- 3. Snowflake verifies IAM user on bucket before allowing or denying access.


-------------------------
--  Steps to implement --
-------------------------
-- 1. Create S3 bucket in AWS.
-- 2. Create Policy in AWS.
-- 3. Create Role in AWS and assign the policy created on step 2. 
-- 4. Create storage integration in Snowflake. Retrieve IAM USER ARN and external ID of it.
-- 5. In trust relationship of role created in step 3 replace ARN and external ID retrieved in step 4.
USE DATABASE "team-project-dev";
USE SCHEMA "team-project";
CREATE OR REPLACE STORAGE INTEGRATION s3_integration
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = 'S3'
    ENABLED = TRUE 
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::862939497306:role/snowflake-ingestion-role-0411'
    STORAGE_ALLOWED_LOCATIONS = ('S3://snowflake-data-ingestion-29-10/', 'S3://snowflake-data-ingestion-29-10/*')
    COMMENT = 'snowflake-data-ingestion-29-10';

-- Retrieve ARN for the IAM user and external ID created for the snowflke account 
DESC INTEGRATION s3_integration;

USE DATABASE "team-project-dev";
USE SCHEMA  "team-project";

-- Create file format 
CREATE OR REPLACE FILE FORMAT csv_format
  TYPE = 'CSV'
  FIELD_DELIMITER = ','
  RECORD_DELIMITER = '\n'
  SKIP_HEADER = 1;
-- See all file format
SHOW FILE FORMATS;

-- Create stage
CREATE OR REPLACE STAGE s3_stage
    STORAGE_INTEGRATION = s3_integration
    URL = 'S3://snowflake-data-ingestion-29-10/'
    FILE_FORMAT = 'csv_format';

-- Check the data present in snowflake stage
List @s3_stage;

-- Create the table 
CREATE OR REPLACE TABLE s3_table(
    fname VARCHAR(50)
    , lname VARCHAR(50)
    , id INTEGER
);

COPY INTO s3_table 
FROM @s3_stage;

SELECT * FROM s3_table;

CREATE OR REPLACE TABLE incorrect_table(
    col1 VARCHAR(50)
    , col2 VARCHAR(50)
    , col3 INTEGER
);

COPY INTO incorrect_table 
FROM @s3_stage;

SELECT * FROM incorrect_table; -- Data loaded even with incorrect format
