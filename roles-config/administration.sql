USE ROLE SYSADMIN;
USE WAREHOUSE COMPUTE_WH;
GRANT ROLE SYSADMIN TO USER project_admin;
REVOKE ROLE SYSADMIN FROM USER project_admin;

CREATE DATABASE "team-project-test";
USE DATABASE "team-project-test";
CREATE SCHEMA "team-project";
USE SCHEMA "team-project";
CREATE TABLE "team-project-table1"(col1 VARCHAR(10),
col2 VARCHAR(10), col3 VARCHAR(10));
INSERT INTO "team-project-table1" VALUES('Rohit', 'Sharma', '1');
INSERT INTO "team-project-table1" VALUES('Virat', 'Kohli', '2');
INSERT INTO "team-project-table1" VALUES('Jasprit', 'Bumrah', '3');
SELECT * FROM "team-project-table1"; 


---- Wokring with tester role ----
USE ROLE SYSADMIN;
CREATE ROLE tester
    COMMENT = "This role is for testers only";
CREATE WAREHOUSE project_warehouse
  WITH WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 300
  AUTO_RESUME = TRUE
  COMMENT = 'Warehouse for usage in project only';
GRANT USAGE, OPERATE ON WAREHOUSE project_warehouse TO ROLE tester;
GRANT SELECT ON DATABASE "team-project-test";
GRANT ROLE tester TO USER project_tester;
GRANT USAGE, MODIFY ON DATABASE "team-project-test" TO ROLE tester;
GRANT USAGE, MODIFY ON SCHEMA "team-project-test"."team-project" TO ROLE tester;
GRANT INSERT, DELETE, TRUNCATE, UPDATE ON TABLE "team-project-test"."team-project"."team-project-table1" TO ROLE tester;
---- Working with tester role ----


---- Working with developer role ----
USE ROLE SECURITYADMIN;
CREATE ROLE developer
    COMMENT = "This role is dedicated to developers only and they will have access to both the test and dev environment";
GRANT ROLE developer TO USER project_developer;
GRANT ROLE tester TO ROLE developer;
USE ROLE SYSADMIN;
GRANT USAGE, MODIFY ON DATABASE "team-project-dev" TO ROLE tester;
GRANT USAGE, MODIFY ON SCHEMA "team-project-dev"."team-project" TO ROLE tester;
---- Working with developer role ----


---- Working with admin role ----
USE ROLE SYSADMIN;
CREATE ROLE admin
    COMMENT = "This role has access to both dev and test data, should be given access to admins only";
GRANT ROLE developer TO ROLE admin;
-- Can later on assign privilidges to admin role for handling multiple projects databases
---- Working with developer role ----