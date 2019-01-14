--
DO
$body$
BEGIN
	IF NOT EXISTS (
    	SELECT 1 FROM information_schema.schemata WHERE schema_name = 'pwaf_app_dba'
    ) THEN

    	CREATE SCHEMA pwaf_app_dba AUTHORIZATION pwaf;
    	
   	END IF;
END
$body$
;
--