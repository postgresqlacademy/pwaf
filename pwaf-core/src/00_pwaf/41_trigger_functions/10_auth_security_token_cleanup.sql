---
CREATE OR REPLACE FUNCTION pwaf.sys_security_oauth2_token_cleanup()
  RETURNS trigger AS
$BODY$BEGIN
DELETE FROM pwaf.security_oauth2_tokens WHERE valid_till < NOW();
RETURN NEW;
END;$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION pwaf.sys_security_oauth2_token_cleanup() OWNER TO pwaf;

DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM information_schema.triggers WHERE trigger_catalog=current_database() and trigger_schema='pwaf' and event_object_table='security_oauth2_tokens' and trigger_name='cleanup'
	) THEN

		CREATE TRIGGER cleanup
		  AFTER INSERT
		  ON pwaf.security_oauth2_tokens
		  FOR EACH STATEMENT
		  EXECUTE PROCEDURE pwaf.sys_security_oauth2_token_cleanup();

	END IF;
END
$body$
;
---