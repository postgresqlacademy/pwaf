---
CREATE OR REPLACE FUNCTION pwaf.pub_security_oauth2_token_generate(in_user_id bigint)
  RETURNS text AS
$BODY$
/**
 * @package PWAF
 * @author Karolis Strumskis (karolis@strumskis.com)
 * @copyright (C) 2013-2019 postgresqlacademy.com and other contributors
 * @license Licensed under the MIT License
 * 
 * @version 0.1
 */
DECLARE
	v_key text;
BEGIN
	v_key := pwaf.pub_util_random_string(64);
	INSERT INTO pwaf.auth_security_tokens (key, user_id) VALUES (v_key, in_user_id);
	RETURN v_key;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf.pub_security_oauth2_token_generate(bigint)
  OWNER TO pwaf;
---