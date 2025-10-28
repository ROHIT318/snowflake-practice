USE ROLE admin;
USE WAREHOUSE project_warehouse;
-- Permanent Tables --
-- 1. Stores data permanently in the table until explicitly mentioned to drop.
-- 2. It has time travel and fail safe features 
-- Cons: Charged for data storage and time travel feature.
CREATE OR REPLACE TABLE "team-project-dev"."team-project"."permanent-table"(
    col1 STRING,
    col2 STRING,
    col3 STRING
);
INSERT INTO "team-project-dev"."team-project"."permanent-table" VALUES('Rohit', 'Sharma', '1');
INSERT INTO "team-project-dev"."team-project"."permanent-table" VALUES('Virat', 'Kohli', '2');
INSERT INTO "team-project-dev"."team-project"."permanent-table" VALUES('Jasprit', 'Bumrah', '3');
SELECT * FROM "team-project-dev"."team-project"."permanent-table";
SHOW TABLES LIKE 'permanent-table'; -- shows properties of the table like clustering, tracking, immutability, created_on, retention_time and owner
-- Time travel features
USE DATABASE "team-project-dev";
SHOW DATABASES; -- shows properties of the databse created_on, retention_time and owner
ALTER TABLE "team-project-dev"."team-project"."permanent-table" SET DATA_RETENTION_TIME_IN_DAYS = 90; -- retention time increased to 90 days, default was 1
SHOW TABLES LIKE 'permanent-table';
INSERT INTO "team-project-dev"."team-project"."permanent-table" VALUES('KL', 'Rahul', '4');
SELECT * FROM "team-project-dev"."team-project"."permanent-table"; -- Displays 4 rows
DROP TABLE "team-project-dev"."team-project"."permanent-table";
SELECT * FROM "team-project-dev"."team-project"."permanent-table"; -- Object '"team-project-dev"."team-project"."permanent-table"' does not exist or not authorized.
UNDROP TABLE "team-project-dev"."team-project"."permanent-table";
SELECT * FROM "team-project-dev"."team-project"."permanent-table"; -- Table is back and displayed.
SELECT *  FROM "team-project-dev"."team-project"."permanent-table" BEFORE (TIMESTAMP => '2025-10-28 12:30:00'); -- Timezone is UTC and shows only 3 rows
SELECT *  FROM "team-project-dev"."team-project"."permanent-table" AT (TIMESTAMP => '2025-10-28 12:30:00'); -- Same as above
SELECT *  FROM "team-project-dev"."team-project"."permanent-table" AT (OFFSET => -60*60); -- 1 hour ago -- returns only 3 rows
-- Fails safe is of 7 days after time travel ends, accessible only snowflake support and not to end users, 

-- -- Temporary Tables --
-- 1. Only visible and accessible in current session
-- 2. No time travel or fail safe feature 
-- 3. No metadata in INFORMATION_SCHEMA
-- 4. Can be used joins, sub-queries, ctes,....
-- 5. Access control doesn't apply
CREATE OR REPLACE TEMPORARY TABLE "team-project-dev"."team-project"."temporary-table"(
    col1 VARCHAR(50),
    col2 VARCHAR(50),
    col3 VARCHAR(50)
);
SELECT * FROM "team-project-dev"."team-project"."temporary-table";
SHOW TABLES LIKE 'temporary-table'; 
INSERT INTO "team-project-dev"."team-project"."temporary-table" VALUES('Rohit', 'Sharma', '1');
INSERT INTO "team-project-dev"."team-project"."temporary-table" VALUES('Virat', 'Kohli', '2');
INSERT INTO "team-project-dev"."team-project"."temporary-table" VALUES('Jasprit', 'Bumrah', '3');
SELECT * FROM "team-project-dev"."team-project"."temporary-table"; -- table disappeared after re-login

-- -- Transient Tables --
-- 1. Is persistent
-- 2. Does not use fail safe and time travel limited to  day
-- 3. Survives session change
CREATE OR REPLACE TRANSIENT TABLE "team-project-dev"."team-project"."transient-table"(
    col1 VARCHAR(50),
    col2 VARCHAR(50),
    col3 VARCHAR(50)
);
INSERT INTO "team-project-dev"."team-project"."transient-table" VALUES('Rohit', 'Sharma', '1');
INSERT INTO "team-project-dev"."team-project"."transient-table" VALUES('Virat', 'Kohli', '2');
INSERT INTO "team-project-dev"."team-project"."transient-table" VALUES('Jasprit', 'Bumrah', '3');
SELECT * FROM "team-project-dev"."team-project"."transient-table";
SHOW TABLES LIKE 'transient-table';


-- External Tables --

-- Permanent table has both time travel and fail safe feature, transient has only time travel feature