--
CREATE OR REPLACE FUNCTION pwaf.pub_security_user_create(in_username text, in_password text)
  RETURNS bigint AS
$BODY$
/**
 * @package PWAF
 * @author Karolis Strumskis (karolis@strumskis.com)
 * @copyright (C) 2014-2019 postgresqlacademy.com and other contributors
 * @license Licensed under the MIT License
 * 
 * @version 0.1
 */
DECLARE
	v_id bigint;
	v_salt text;
BEGIN
	
	SELECT nextval('pwaf.g_seq'::regclass) INTO v_id;
	SELECT pwaf_extensions.gen_salt('bf'::text, 8) INTO v_salt;
	
	INSERT INTO pwaf.security_users(
            id, user_name, auth_type_id, password, salt)
    VALUES (v_id, in_username, 1000000, pwaf_extensions.crypt(in_password, v_salt), v_salt);

	RETURN v_id;
	
END;$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION pwaf.pub_security_user_create(in_username text, in_password text)
  OWNER TO pwaf;
