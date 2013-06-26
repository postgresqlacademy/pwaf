--
DO
$body$
BEGIN
	IF NOT EXISTS (
    	SELECT 1 FROM information_schema.schemata WHERE schema_name = 'pwaf_app_admin'
    ) THEN

    	CREATE SCHEMA pwaf_app_admin AUTHORIZATION pwaf;
    	
   	END IF;
END
$body$
;
--