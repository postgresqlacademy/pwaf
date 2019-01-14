-- creating main role for PWAF framework with no login
DO
$body$
BEGIN
   	IF NOT pwaf.build_utils_check_role_exists('pwaf_web') THEN

      CREATE ROLE pwaf_web LOGIN NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION PASSWORD 'pwaf_web_pass';

   	END IF;
END
$body$
;
--
