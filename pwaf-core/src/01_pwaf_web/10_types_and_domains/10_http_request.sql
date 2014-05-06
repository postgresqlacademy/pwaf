--
DO
$body$
BEGIN
	IF NOT EXISTS (
    	SELECT 1 FROM pg_type JOIN pg_namespace ON typnamespace=pg_namespace.oid WHERE nspname='pwaf_web' AND typname='http_request'
    ) THEN
    	
		CREATE TYPE pwaf_web.http_request AS
		   (method pwaf.http_request_method,
		    path text[],
		    param_names text[],
		    param_values text[],
		    system_param_names text[],
		    system_param_values text[]);

   	END IF;
END
$body$
;

ALTER TYPE pwaf_web.http_request OWNER TO pwaf;
--