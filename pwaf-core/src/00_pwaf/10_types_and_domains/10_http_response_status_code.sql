--
DO
$body$
BEGIN
	IF NOT EXISTS (
    	SELECT 1 FROM pg_type JOIN pg_namespace ON typnamespace=pg_namespace.oid WHERE nspname='pwaf' AND typname='http_response_status_code'
    ) THEN
    	

		CREATE DOMAIN pwaf.http_response_status_code AS integer DEFAULT 200;

   	END IF;
END
$body$
;

ALTER DOMAIN pwaf.http_response_status_code OWNER TO pwaf;
--