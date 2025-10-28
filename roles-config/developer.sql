SELECT * FROM "team-project-test"."team-project"."team-project-table1"; -- able to access
INSERT INTO "team-project-test"."team-project"."team-project-table1" VALUES('kL', 'RAHUL', 4); --Row inserted properly in test environment

SELECT * FROM "team-project-dev"."team-project"."team-project-table1"; -- able to access
INSERT INTO "team-project-dev"."team-project"."team-project-table1" VALUES('kL', 'RAHUL', 4); --Row inserted properly in dev environment