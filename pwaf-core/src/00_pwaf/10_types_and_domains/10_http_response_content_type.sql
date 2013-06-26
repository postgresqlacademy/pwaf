--
DO
$body$
BEGIN
	IF NOT EXISTS (
    	SELECT 1 FROM pg_type JOIN pg_namespace ON typnamespace=pg_namespace.oid WHERE nspname='pwaf' AND typname='http_response_content_type'
    ) THEN
    	

		CREATE TYPE pwaf.http_response_content_type AS ENUM
		   ('text/html;charset=utf-8',
		    'text/xml;charset=utf-8',
		    'text/css',
		    'application/javascript',
		    'image/png',
		    'image/jpeg',
		    'application/json',
		    'test',
		    'text/javascript');

   	END IF;
END
$body$
;

ALTER TYPE pwaf.http_response_content_type OWNER TO pwaf;

--