-- Stream: It is a first class object residing within schema and it is created on top of source table, could be a permanent table, transient table, temporary table or an external table. 
-- 1. Three column are added to an existing table Metadata$ACTION, Metadata$IsUpdate, Metadata$RowID
-- 2. When accessing the stream table it will only fetch the changes and not the entire source or base table
-- Types of streams: 
    -- 1. append_only = True , Only appended data is stored  
    -- 2. insert_only = True , Only inserted data is stored, need to be used with external keyword 
-- Can create multiple types of stream to same table, they will be independent of each other 

SELECT * FROM "team-project-dev"."team-project"."permanent-table";

USE ROLE admin;
CREATE OR REPLACE STREAM "team-project-dev"."team-project"."permanent-table-stream"
ON TABLE "team-project-dev"."team-project"."permanent-table";

SELECT * FROM "team-project-dev"."team-project"."permanent-table-stream"; -- 3 coumnms added, 0 rows

INSERT INTO "team-project-dev"."team-project"."permanent-table" VALUES('Axar', 'Patel', '5');
INSERT INTO "team-project-dev"."team-project"."permanent-table" VALUES('Ravindra', 'Jadeja', '6'); 

SELECT * FROM "team-project-dev"."team-project"."permanent-table-stream";

DELETE FROM "team-project-dev"."team-project"."permanent-table" WHERE col3 IN (5, 6);

SHOW STREAMS;