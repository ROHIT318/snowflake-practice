-- Anti-Pattern: A solution to solve an issue in software dedvelopment world which in beginning seems good but later leads to Problems, Inefficiencies, counter productive 

-- -- Procedure: 
-- 1. Stored procedure acts like a subprogramm or function within database, allowing the encapsulation of complex logic and repititive tasks. 
-- 2. Paramterized queries.
-- 3. Maintanance of application logic.
-- 4. Ease of troubleshooting
-- 5. Security: Create a procedure that can access the table and provide access of that procedure to users/roles, no direct acces of table to users/roles.
-- 6. Usage includes: ETL processes, data cleaning and quality checks, Data archiving and partition management.
-- 7. best practices: odularity(Break complex logics into modular components), Parameterization of values, Error handling.

-- Query tag helps in tracking and auditing queries, grouping related queries, filtering in account usage or query history.
-- Can use the tags to identfy the costs, performance or for debugging. 
ALTER SESSION SET query_tag = 'stored-procedure';
-- Don't use cache memory 
ALTER SESSION SET USE_CACHED_RESULT = False;

-- Accessible to root account 
SELECT * FROM snowflake.account_usage.query_history;


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


-- using into to assign variable, can use both colon and not colon for variable reference
CREATE OR REPLACE PROCEDURE assign_using_into()
RETURNS NUMBER(5,2)
LANGUAGE SQL
AS
DECLARE 
    min_id NUMBER(5,2);
    max_id NUMBER(5,2);
BEGIN 
    -- SELECT MIN(col3), MAX(col3) INTO :min_id, :max_id FROM "team-project-dev"."team-project"."permanent-table";
    SELECT MIN(col3), MAX(col3) INTO min_id, max_id FROM "team-project-dev"."team-project"."permanent-table";
    
    -- RETURN min_id;
    RETURN max_id;
END;

CALL assign_using_into();


-- Return dev/test database table based on argument provided
CREATE OR REPLACE PROCEDURE var_table_name()
RETURNS TABLE(fname TEXT, lname TEXT, id NUMBER)
LANGUAGE SQL
AS
DECLARE
    res_table RESULTSET DEFAULT (SELECT * FROM "team-project-dev"."team-project"."S3_TABLE");
BEGIN
    -- This works too! 
    -- LET res_table RESULTSET DEFAULT (SELECT * FROM "team-project-dev"."team-project"."S3_TABLE");
    RETURN TABLE(res_table);
END;

CALL var_table_name();


CREATE OR REPLACE PROCEDURE calc_cgt(profit NUMBER, year NUMBER(4,2))
RETURNS NUMBER 
LANGUAGE SQL
AS
DECLARE
    -- profit NUMBER(10,2);
    -- year NUMBER(2,2);
    ltcg NUMBER(4,3) DEFAULT .125;
    stcg NUMBER(4,3) DEFAULT .20;
BEGIN
    IF (profit>=125000) THEN
        IF (year>=1) THEN 
            -- RETURN 'HERE1';
            RETURN (profit*ltcg);
        ELSE 
            -- RETURN 'HERE2';
            RETURN (profit*stcg);
        END IF;
    ELSE 
        -- RETURN 'HERE3';
        RETURN 0;
    END IF; 
END;

CALL calc_cgt(10000, 0.5); -- 0
CALL calc_cgt(200000, 0.5); -- 40000
CALL calc_cgt(200000, 2); -- 25000



CREATE OR REPLACE PROCEDURE iphone_price(price NUMBER, year NUMBER(10,2))
RETURNS NUMBER 
LANGUAGE SQL
AS
DECLARE
    asset_depr NUMBER(4,3) DEFAULT .20;
    num_var NUMBER;
BEGIN
    IF (price>=100000 AND year=1) THEN 
        num_var := price-(price*asset_depr);
        RETURN num_var;
    ELSEIF (price>=100000 AND year=2) THEN
        num_var := price-(price*asset_depr*2);
        RETURN num_var;
    ELSE
        num_var := (price/2);
        RETURN num_var;
    END IF; 
END;

CALL iphone_price(100000, 1); -- 80000
CALL iphone_price(100000, 2); -- 60000
CALL iphone_price(100000, 10); -- 50000



-- FOR LOOP 
CREATE OR REPLACE PROCEDURE for_loop(s NUMBER, e NUMBER)
RETURNS TABLE(straight TEXT, reversed TEXT)
LANGUAGE SQL
AS
DECLARE 
    straight TEXT DEFAULT '';
    reversed TEXT DEFAULT '';
BEGIN 
    FOR i IN s TO e DO
        -- BREAK/CONITNUE can be used in between;
        straight := straight || i || ' ';
    END FOR;

    FOR i IN REVERSE s TO e DO 
        reversed := reversed || i || ' ';
    END FOR;

    LET res RESULTSET := (SELECT :straight, :reversed);
    RETURN TABLE(res);
END;

CALL for_loop(1, 10); -- Two columnms, one row: 1 2 3 4 5 6 7 8 9 10 , 10 9 8 7 6 5 4 3 2 1 



-- FOR LOOP 
CREATE OR REPLACE PROCEDURE while_loop()
RETURNS TABLE(straight TEXT, reversed TEXT)
LANGUAGE SQL
AS
DECLARE 
    straight TEXT DEFAULT '';
    reversed TEXT DEFAULT '';
BEGIN 
    LET i := 1;
    WHILE (i<=10) DO
        -- BREAK/CONITNUE can be used in between;
        straight := straight || i || ' ';
        i := i + 1;
    END WHILE;

    WHILE (i>=0) DO
        -- BREAK/CONITNUE can be used in between;
        reversed := reversed || i || ' ';
        i := i - 1;
    END WHILE;

    LET res RESULTSET := (SELECT :straight, :reversed);
    RETURN TABLE(res);
END;

CALL while_loop(); -- Two columnms, one row: 1 2 3 4 5 6 7 8 9 10 , 10 9 8 7 6 5 4 3 2 1 


-- CREATE OR REPLACE PROCEDURE case_when()
-- RETURN TEXT 
-- LANGUAGE SQL
-- AS
-- BEGIN
--     CASE (expressin) 
--         WHEN (condition) THEN 
            -- execute statement;
--         WHEN (condition2) THEN 
            -- EXECUTE STATEMENT;
--         ELSE 
            -- EXECUTE STATEMENT;
--     END;
-- END;



CREATE OR REPLACE PROCEDURE procedure_one()
RETURNS STRING
LANGUAGE SQL
AS
BEGIN
    RETURN 'First operation completed....';
END;

CREATE OR REPLACE PROCEDURE nested_procedure()
RETURNS STRING 
LANGUAGE SQL
AS
BEGIN
    LET res := (procedure_one());
    RETURN res || ' ' || 'Second operation also completed....';
END;

CALL nested_procedure();