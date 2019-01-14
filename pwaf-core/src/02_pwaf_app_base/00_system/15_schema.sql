--
DO
$body$
BEGIN
   	IF NOT pwaf.build_utils_check_schema_exists('pwaf_app_base') THEN

    	CREATE SCHEMA pwaf_app_base AUTHORIZATION pwaf;
    	
   	END IF;
END
$body$
;
--