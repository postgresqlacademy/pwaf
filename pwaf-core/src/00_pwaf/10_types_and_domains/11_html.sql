--
DO
$body$
BEGIN
	IF NOT EXISTS (
    	SELECT 1 FROM pg_type JOIN pg_namespace ON typnamespace=pg_namespace.oid WHERE nspname='pwaf' AND typname='html'
    ) THEN
    	

		CREATE DOMAIN pwaf.html AS text COLLATE pg_catalog."default";

   	END IF;
END
$body$
;

ALTER DOMAIN pwaf.html OWNER TO pwaf;
--