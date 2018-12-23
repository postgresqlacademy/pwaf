---
CREATE OR REPLACE FUNCTION pwaf.auth_security_token_cleanup()
  RETURNS trigger AS
$BODY$BEGIN
DELETE FROM pwaf.auth_security_tokens WHERE valid_till < NOW();
RETURN NEW;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf.auth_security_token_cleanup() OWNER TO pwaf;

DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM information_schema.triggers WHERE trigger_catalog=current_database() and trigger_schema='pwaf' and event_object_table='auth_security_tokens' and trigger_name='cleanup'
	) THEN

		CREATE TRIGGER cleanup
		  AFTER INSERT
		  ON pwaf.auth_security_tokens
		  FOR EACH STATEMENT
		  EXECUTE PROCEDURE pwaf.auth_security_token_cleanup();

	END IF;
END
$body$
;
---