--
DO
$body$
BEGIN
	IF NOT EXISTS (
    	SELECT 1 FROM information_schema.schemata WHERE schema_name = 'pwaf'
    ) THEN

    	CREATE SCHEMA pwaf AUTHORIZATION pwaf;
    	
   	END IF;
END
$body$
;
--