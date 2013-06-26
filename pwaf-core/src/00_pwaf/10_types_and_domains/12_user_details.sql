--
DO
$body$
BEGIN
	IF NOT EXISTS (
    	SELECT 1 FROM pg_type JOIN pg_namespace ON typnamespace=pg_namespace.oid WHERE nspname='pwaf' AND typname='user_details'
    ) THEN
    	
		CREATE TYPE pwaf.user_details AS (user_id integer, user_level text, username text);
		
   	END IF;
END
$body$
;

ALTER DOMAIN pwaf.user_details OWNER TO pwaf;
--