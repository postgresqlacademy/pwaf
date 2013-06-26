--
DO
$body$
BEGIN
	IF NOT EXISTS (
    	SELECT 1 FROM pg_type JOIN pg_namespace ON typnamespace=pg_namespace.oid WHERE nspname='pwaf' AND typname='http_request_route'
    ) THEN
    	

		CREATE TYPE pwaf.http_request_route AS
		   (
		   	id int,
		   	controller_name text,
		    path_for_route text[],
		    path_for_controller text[]
		   );

   	END IF;
END
$body$
;

ALTER TYPE pwaf.http_request_route OWNER TO pwaf;

--