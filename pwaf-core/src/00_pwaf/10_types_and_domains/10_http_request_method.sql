--
DO
$body$
BEGIN
	IF NOT EXISTS (
    	SELECT 1 FROM pg_type JOIN pg_namespace ON typnamespace=pg_namespace.oid WHERE nspname='pwaf' AND typname='http_request_method'
    ) THEN
    	

		CREATE TYPE pwaf.http_request_method AS ENUM
		   ('GET',
		    'POST');

   	END IF;
END
$body$
;

ALTER TYPE pwaf.http_request_method OWNER TO pwaf;

--