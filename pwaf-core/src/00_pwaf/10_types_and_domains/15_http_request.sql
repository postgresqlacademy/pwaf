--
DO
$body$
BEGIN
	IF NOT EXISTS (
    	SELECT 1 FROM pg_type JOIN pg_namespace ON typnamespace=pg_namespace.oid WHERE nspname='pwaf' AND typname='http_request'
    ) THEN
    	
		CREATE TYPE pwaf.http_request AS
		   (method pwaf.http_request_method,
		    path text[],
		    param_names text[],
		    param_values text[],
		    system_param_names text[],
		    system_param_values text[],
		    path_for_controller text[],
		    session_id int
		    );

   	END IF;
END
$body$
;

ALTER DOMAIN pwaf.http_request OWNER TO pwaf;

COMMENT ON TYPE pwaf.http_request IS 'Object of HTTP request. Carries request information, request unique ID, session information.';
--