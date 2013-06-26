-- creating main role for PWAF framework with no login
DO
$body$
BEGIN
	IF NOT EXISTS (
   		SELECT 1 FROM pg_catalog.pg_user WHERE usename = 'pwaf_web'
   	) THEN

      CREATE ROLE pwaf_web LOGIN NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION PASSWORD 'pwaf_web_pass';

   	END IF;
END
$body$
;
--
