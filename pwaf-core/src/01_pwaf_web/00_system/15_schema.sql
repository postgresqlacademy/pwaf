--
DO
$body$
BEGIN
    IF NOT pwaf.build_utils_check_schema_exists('pwaf_web') THEN

    	CREATE SCHEMA pwaf_web AUTHORIZATION pwaf;
    	
   	END IF;
END
$body$
;

GRANT ALL ON SCHEMA pwaf_web TO pwaf;
GRANT USAGE ON SCHEMA pwaf_web TO pwaf_web;
COMMENT ON SCHEMA pwaf_web IS 'This schema is uesd for exposing certain functions to the http connector (application that handles incoming request on web/80 port). This schema is security and abstraction measure.';
--