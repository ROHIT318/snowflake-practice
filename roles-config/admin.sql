USE ROLE admin;

USE WAREHOUSE project_warehouse;

---- Craeting dev database ----
CREATE DATABASE "team-project-dev";
SELECT * FROM "team-project-dev".INFORMATION_SCHEMA.APPLICABLE_ROLES;
USE DATABASE "team-project-dev";
CREATE SCHEMA "team-project";
DROP TABLE "team-project-dev.team-project.team-project-table1";
CREATE TABLE "team-project-table1"(col1 VARCHAR(10),
col2 VARCHAR(10), col3 VARCHAR(10));
INSERT INTO "team-project-table1" VALUES('Rohit', 'Sharma', '1');
INSERT INTO "team-project-table1" VALUES('Virat', 'Kohli', '2');
INSERT INTO "team-project-table1" VALUES('Jasprit', 'Bumrah', '3');
SELECT * FROM "team-project-table1"; 


---- Craeting test database ----
USE DATABASE "team-project-test";
USE DATABASE "team-project-test";
CREATE SCHEMA "team-project";
DROP TABLE "team-project-dev.team-project.team-project-table1";
CREATE TABLE "team-project-table1"(col1 VARCHAR(10),
col2 VARCHAR(10), col3 VARCHAR(10));
INSERT INTO "team-project-table1" VALUES('Rohit', 'Sharma', '1');
INSERT INTO "team-project-table1" VALUES('Virat', 'Kohli', '2');
INSERT INTO "team-project-table1" VALUES('Jasprit', 'Bumrah', '3');
SELECT * FROM "team-project-table1"; 