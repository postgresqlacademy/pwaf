--
DO
$body$
BEGIN
	IF NOT EXISTS (
    	SELECT 1 FROM pg_type JOIN pg_namespace ON typnamespace=pg_namespace.oid WHERE nspname='pwaf' AND typname='sql_query'
    ) THEN
    	

		CREATE DOMAIN pwaf.sql_query AS text COLLATE pg_catalog."default";

   	END IF;
END
$body$
;

ALTER DOMAIN pwaf.sql_query OWNER TO pwaf;
--