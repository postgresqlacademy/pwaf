--
DO
$body$
BEGIN
	IF NOT EXISTS (
    	SELECT 1 FROM pg_type JOIN pg_namespace ON typnamespace=pg_namespace.oid WHERE nspname='pwaf' AND typname='g_serial'
    ) THEN
    	

		CREATE DOMAIN pwaf.g_serial AS bigint DEFAULT nextval('pwaf.g_seq'::regclass);

   	END IF;
END
$body$
;

ALTER DOMAIN pwaf.g_serial OWNER TO pwaf;
--