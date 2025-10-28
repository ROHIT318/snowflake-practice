SELECT * FROM "team-project-test"."team-project"."team-project-table1";
SELECT * FROM "team-project-dev"."team-project"."team-project-table1"; -- Database '"team-project-dev"' does not exist or not authorized.
INSERT INTO "team-project-test"."team-project"."team-project-table1" VALUES('Jasprit', 'Bumrah', '3'); -- 1 row inserted
INSERT INTO "team-project-dev"."team-project"."team-project-table1" VALUES('Jasprit', 'Bumrah', '3'); -- Database '"team-project-dev"' does not exist or not authorized.