--
DO
$body$
BEGIN
	IF NOT EXISTS (
    	SELECT 1 FROM pg_type JOIN pg_namespace ON typnamespace=pg_namespace.oid WHERE nspname='pwaf' AND typname='log_level'
    ) THEN
    	
		CREATE TYPE pwaf.log_level AS ENUM
		   ('WARNING',
		    'DEBUG',
		    'ERROR');
		
   	END IF;
END
$body$
;

ALTER DOMAIN pwaf.log_level OWNER TO pwaf;
--