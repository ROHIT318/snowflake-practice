-- Anti-Pattern: A solution to solve an issue in software dedvelopment world which in beginning seems good but later leads to Problems, Inefficiencies, counter productive 

-- -- Procedure: 
-- 1. Stored procedure acts like a subprogramm or function within database, allowing the encapsulation of complex logic and repititive tasks. 
-- 2. Paramterized queries.
-- 3. Maintanance of application logic.
-- 4. Ease of troubleshooting
-- 5. Security: Create a procedure that can access the table and provide access of that procedure to users/roles, no direct acces of table to users/roles.
-- 6. Usage includes: ETL processes, data cleaning and quality checks, Data archiving and partition management.
-- 7. best practices: odularity(Break complex logics into modular components), Parameterization of values, Error handling.

CREATE OR REPLACE PROCEDURE calculate_tax()
RETURNS FLOAT
LANGUAGE SQL
AS 
DECLARE
    -- <variable_name> <data_tye>;
    -- <variable_name> DEFAULT '<expression/value>';
    -- <variable_name> <data_type> DEFAULT '<expression/value>';
    -- <variable_name> are not case sensitive
    tax number(30,2) DEFAULT 0.00;
    base_salary number(10,2) DEFAULT 1000.0;
BEGIN 
    LET gross_salary number(10,2) := 10000.0;
    LET tax_rate number(10,2) := 0.20;  

    IF (gross_salary > base_salary) THEN
        tax := (gross_salary * tax_rate);
    END IF;
    RETURN tax;
    -- exception block
END;
-- call the procedure
call calculate_tax();

-- Query tag helps in tracking and auditing queries, grouping related queries, filtering in account usage or query history.
-- Can use the tags to identfy the costs, performance or for debugging. 
ALTER SESSION SET query_tag = 'stored-procedure';
-- Don't use cache memory 
ALTER SESSION SET USE_CACHED_RESULT = False;

-- Accessible to root account 
SELECT * FROM snowflake.account_usage.query_history;

CREATE OR REPLACE PROCEDURE current_date_time()
RETURNS STRING
LANGUAGE SQL
AS
DECLARE 
    current_date TEXT := current_date();
    current_time STRING := current_timestamp();
BEGIN 
    RETURN current_date || ' ' || current_time;
END;

CALL current_date_time();


CREATE OR REPLACE PROCEDURE current_date_time_no_declare()
RETURNS STRING
LANGUAGE SQL
AS
BEGIN
    LET current_date TEXT := current_date();
    LET current_time STRING := current_timestamp();
    RETURN current_date || ' ' || current_time;
END;

CALL current_date_time();

CREATE OR REPLACE PROCEDURE different_data_type()
RETURNS string
LANGUAGE SQL
AS
DECLARE
    var_txt TEXT DEFAULT 'ROHIT SHARMA';
    num NUMBER(10) DEFAULT 1234567891;
    num_dec NUMBER(10,4) DEFAULT 123.123;
    dt DATE DEFAULT current_date();
    dt_time TIME DEFAULT current_time();
    dt_timestamp TIME DEFAULT current_timestamp();
    var_bool BOOLEAN DEFAULT TRUE;
    var_json VARIANT DEFAULT PARSE_JSON('{"data1": "data2"}');
    var_arr ARRAY DEFAULT '[1,2,3]';
    var_object OBJECT  DEFAULT {'obj1': 'data1', 'obj2': {'obj3': 'data3', 'obj4': 'data4'}};
BEGIN
    -- LET <var_name> <data_type> := <value>;
    -- RETURN var_txt;
    -- RETURN num;
    -- RETURN num_dec;
    -- RETURN dt;
    -- RETURN dt_time;
    -- RETURN dt_timestamp;
    -- RETURN var_bool;
    -- RETURN var_json;
    -- RETURN var_arr;
    RETURN var_object;
END;

CALL different_data_type();

-- Show details of procedures
SHOW PROCEDURES LIKE 'different_data_type';

-- description of procedure
DESC PROCEDURE different_data_type();

-- -- Creating procedure
-- CREATE OR REPLACE PROCEDURE sql_function (
--     SELECT * FROM "team-project-dev"."team-project"."permanent-table"
-- );

-- USE DATABASE "team-project-dev";
-- USE SCHEMA "team-project-dev"."team-project";
-- USE ROLE admin;
-- CREATE OR REPLACE PROCEDURE sql_function()
-- RETURNS TABLE (fname STRING, lname STRING, id INT)
-- LANGUAGE SQL
-- AS
-- $$
--     return
--     SELECT col1, col2, col3
--     FROM "team-project-dev"."team-project"."permanent-table";
-- $$;

-- CALL sql_function();