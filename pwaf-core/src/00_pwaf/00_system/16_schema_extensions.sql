--
DO
$body$
BEGIN
	IF NOT EXISTS (
    	SELECT 1 FROM information_schema.schemata WHERE schema_name = 'pwaf_extensions'
    ) THEN

    	CREATE SCHEMA pwaf_extensions AUTHORIZATION pwaf;
    	
   	END IF;
END
$body$
;
--