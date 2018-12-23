--
DO
$body$
BEGIN
	IF NOT EXISTS (
    	SELECT 1 FROM pg_type JOIN pg_namespace ON typnamespace=pg_namespace.oid WHERE nspname='pwaf' AND typname='auth_security_tokens_id_seq'
    ) THEN
    	

		CREATE SEQUENCE pwaf.auth_security_tokens_id_seq
		  INCREMENT 1
		  MINVALUE 1
		  MAXVALUE 9223372036854775807
		  START 100000
		  CACHE 1;

   	END IF;
END
$body$
;

ALTER SEQUENCE pwaf.auth_security_tokens_id_seq OWNER TO pwaf;
--