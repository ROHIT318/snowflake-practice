-- Resource Creation: best practices for creating User, Role, 
-- creation of Database, Schema, table, view, stage, interface, stage, procedure
-- Providing Privelege,  

-- Create user and roles always using USERADMIN 
CREATE USER project_user;

CREATE OR REPLACE ROLE <role_name>;

CREATE OR REPLACE USER <user_name>
  PASSWORD = '<password>'
  LOGIN_NAME = '<login_name>'
  DEFAULT_ROLE = '<default_role>'
  MUST_CHANGE_PASSWORD = { TRUE | FALSE }
  COMMENT = '<comment_string>';


CREATE OR REPLACE TABLE <table_name>(cols data_types, so on);
