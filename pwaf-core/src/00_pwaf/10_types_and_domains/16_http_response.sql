--
DO
$body$
BEGIN
	IF NOT EXISTS (
    	SELECT 1 FROM pg_type JOIN pg_namespace ON typnamespace=pg_namespace.oid WHERE nspname='pwaf' AND typname='http_response'
    ) THEN
    	
		CREATE TYPE pwaf.http_response AS
		   (content_type pwaf.http_response_content_type,
		    body text,
		    status_code pwaf.http_response_status_code,
		    additional_headers text[]);
		
   	END IF;
END
$body$
;

ALTER DOMAIN pwaf.http_response OWNER TO pwaf;
--