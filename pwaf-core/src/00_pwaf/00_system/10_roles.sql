-- creating main role for PWAF framework with no login
DO
$body$
BEGIN
	IF NOT EXISTS (
   		SELECT 1 FROM pg_catalog.pg_user WHERE usename = 'pwaf'
   	) THEN

      CREATE ROLE pwaf LOGIN NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;

	END IF;
END
$body$
;
GRANT USAGE ON SCHEMA pg_catalog TO pwaf;
--

