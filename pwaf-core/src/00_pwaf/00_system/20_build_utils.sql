--
-- VIEW
--
CREATE OR REPLACE FUNCTION pwaf.build_utils_check_view_exists(text, text) 
RETURNS boolean AS
$BODY$
	SELECT EXISTS (SELECT 1 FROM pg_views WHERE schemaname=$1 and viewname=$2)
$BODY$
LANGUAGE sql VOLATILE;
ALTER FUNCTION pwaf.build_utils_check_view_exists(text, text) OWNER TO pwaf;
--
-- TABLE
--
CREATE OR REPLACE FUNCTION pwaf.build_utils_check_table_exists(text, text) 
RETURNS boolean AS
$BODY$
	SELECT EXISTS (SELECT 1 FROM pg_tables WHERE schemaname=$1 and tablename=$2)
$BODY$
LANGUAGE sql VOLATILE;
ALTER FUNCTION pwaf.build_utils_check_table_exists(text, text) OWNER TO pwaf;
--
-- ROLE
--
CREATE OR REPLACE FUNCTION pwaf.build_utils_check_role_exists(text) 
RETURNS boolean AS
$BODY$
	SELECT EXISTS (SELECT 1 FROM pg_catalog.pg_user WHERE usename = $1)
$BODY$
LANGUAGE sql VOLATILE;
ALTER FUNCTION pwaf.build_utils_check_role_exists(text) OWNER TO pwaf;
--
-- SCHEMA
--
CREATE OR REPLACE FUNCTION pwaf.build_utils_check_schema_exists(text) 
RETURNS boolean AS
$BODY$
	SELECT EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = $1)
$BODY$
LANGUAGE sql VOLATILE;
ALTER FUNCTION pwaf.build_utils_check_schema_exists(text) OWNER TO pwaf;
--
-- TYPE
--
CREATE OR REPLACE FUNCTION pwaf.build_utils_check_type_exists(text, text) 
RETURNS boolean AS
$BODY$
	SELECT EXISTS (SELECT 1 FROM pg_type JOIN pg_namespace ON typnamespace=pg_namespace.oid WHERE nspname=$1 AND typname=$2)
$BODY$
LANGUAGE sql VOLATILE;
ALTER FUNCTION pwaf.build_utils_check_type_exists(text, text) OWNER TO pwaf;