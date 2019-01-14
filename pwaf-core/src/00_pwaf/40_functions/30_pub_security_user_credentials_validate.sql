---
CREATE OR REPLACE FUNCTION pwaf.pub_security_user_credentials_validate(
    in_username text,
    in_password text)
  RETURNS boolean AS
$BODY$
/**
 * @package PWAF
 * @author Karolis Strumskis (karolis@strumskis.com)
 * @copyright (C) 2019 postgresqlacademy.com and other contributors
 * @license Licensed under the MIT License
 * 
 * @version 0.1
 */
DECLARE
	v_user_id	int;
	v_auth_type	text;
	v_salt		text;
BEGIN

	SELECT 
		security_users.id, 
		security_auth_types.auth_type, 
		security_users.salt 
	FROM 
		pwaf.security_users, 
		pwaf.security_auth_types 
	WHERE 
		security_auth_types.id=security_users.auth_type_id 
		AND 
		security_users.user_name = in_username 
	INTO v_user_id, v_auth_type, v_salt;

	--- check that there is only one username like this (double check because of inheritance, etc.)
	IF(SELECT count(1)>1 FROM pwaf.security_users WHERE user_name=in_username) THEN
		RETURN FALSE;
	END IF;

	IF v_user_id IS NOT NULL AND v_auth_type = 'local/crypt-bf8' THEN

		IF EXISTS(
			SELECT 1 FROM pwaf.security_users WHERE id = v_user_id AND password = pwaf_extensions.crypt(in_password, v_salt)
		) THEN
			RETURN TRUE;
		END IF;

	END IF;

	RETURN FALSE;
	
END;$BODY$

LANGUAGE plpgsql VOLATILE;

ALTER FUNCTION pwaf.pub_security_user_credentials_validate(text, text) OWNER TO pwaf;
---