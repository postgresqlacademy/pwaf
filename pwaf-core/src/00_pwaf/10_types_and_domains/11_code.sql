--
DO
$body$
BEGIN
	IF NOT EXISTS (
    	SELECT 1 FROM pg_type JOIN pg_namespace ON typnamespace=pg_namespace.oid WHERE nspname='pwaf' AND typname='code'
    ) THEN
    	

		CREATE DOMAIN pwaf.code AS text COLLATE pg_catalog."default";

   	END IF;
END
$body$
;

ALTER DOMAIN pwaf.code OWNER TO pwaf;
--