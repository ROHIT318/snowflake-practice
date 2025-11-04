-- -- View: 
-- 1. Can be defined as a named query 
-- 2. Accessing the result of a query as if like it was a table

-- -- Non-Materialized Views (Standard Views) --
-- 1. No data is stored, query runs at access time
-- 2. Useful in simplifying complex joins, filters or transformations
-- Cons: Slower performance on large datasets 
SELECT * FROM "team-project-dev"."team-project"."team-project-table1";
USE DATABASE "team-project-dev";
USE SCHEMA "team-project";
USE WAREHOUSE project_warehouse;
USE ROLE ADMIN;
CREATE OR REPLACE VIEW "non-mat-view" AS
SELECT 
tpt1.col1 col11,
tpt1.col2 col12,
tpt1.col3 col13,
pt.col1 col21,
pt.col2 col22,
FROM 
"team-project-dev"."team-project"."team-project-table1" tpt1
LEFT JOIN "team-project-dev"."team-project"."permanent-table" pt
ON tpt1.col3 = pt.col3;

SELECT * FROM "team-project-dev"."team-project"."non-mat-view";


-- Materialized Views --
-- 1. This are the views that stores the result of the query beforehand.
-- 2. Can be used in scenarios where data tables are not updated that frequently and results are accessed frequently.
-- 3. Snowflake automatically maintains and updates the data for matrialized viws. Maintenance consumes snowflake credits.
-- 4. It is faster than non-materialized views as result is already stored.
-- cons: Supports only one table during querying, no joins are supported.
USE ROLE admin;
USE WAREHOUSE project_warehouse;
SELECT * FROM "team-project-dev"."team-project"."permanent-table";
SELECT * FROM "team-project-dev"."team-project"."team-project-table1";
CREATE OR REPLACE MATERIALIZED VIEW "mat-view" AS 
    SELECT * FROM "team-project-dev"."team-project"."permanent-table" pt 
    LEFT JOIN "team-project-dev"."team-project"."team-project-table1" tpt1
    ON pt.col3=tpt1.col3; -- won't work as multiple tables referenced in a single query
CREATE OR REPLACE MATERIALIZED VIEW "mat-view" AS 
    SELECT * FROM "team-project-dev"."team-project"."permanent-table" pt 
    WHERE pt.col3<=2; -- This will work
SELECT * FROM "team-project-dev"."team-project"."permanent-table" pt 
    WHERE pt.col3<=2; -- simple query
SELECT * FROM "team-project-dev"."team-project"."mat-view"; -- same query as above but this is faster.


-- Secure Views --
-- 1. It limits the access of the data definition of view such that sensitive data is not exposed to underlying tables
-- 2. Both materialized and non-materialized views can be defined as secure 
-- 3. Data privacy and sharing is improved
CREATE OR REPLACE SECURE VIEW "secure-view" AS 
    SELECT pt.col1, pt.col2, pt.col3, tpt1.col1 AS col11, tpt1.col2 AS col22, tpt1.col3 AS col33  
    FROM "team-project-dev"."team-project"."permanent-table" pt 
    LEFT JOIN "team-project-dev"."team-project"."team-project-table1" tpt1
    ON pt.col3=tpt1.col3;
SELECT * FROM "team-project-dev"."team-project"."secure-view";

USE ROLE developer;
SELECT * FROM "team-project-dev"."team-project"."mat-view";
SELECT * FROM "team-project-dev"."team-project"."secure-view";

USE SECONDARY ROLES NULL


-- Temporary Views --