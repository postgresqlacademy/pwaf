--
CREATE OR REPLACE FUNCTION pwaf.pub_controller_security_web_login(in_request pwaf.http_request)
  RETURNS pwaf.http_response AS
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
	v_response 	pwaf.http_response;
	v_data 		text;
	v_content_type	pwaf.http_response_content_type;
	v_username	text;
	v_password 	text;
	v_user_id	int;
	v_auth_type	text;
	v_salt		text;
BEGIN

	IF (pwaf.pub_http_request_param_get(in_request,'security_login_username') IS NOT NULL AND pwaf.pub_http_request_param_get(in_request,'security_login_password') IS NOT NULL) THEN
		
		v_username := pwaf.pub_http_request_param_get(in_request,'security_login_username');
		v_password := pwaf.pub_http_request_param_get(in_request,'security_login_password');

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
			security_users.user_name = v_username 
		INTO v_user_id, v_auth_type, v_salt;

		IF v_user_id IS NOT NULL AND v_auth_type = 'local/crypt-bf8' THEN

			IF EXISTS(
				SELECT 1 FROM pwaf.security_users WHERE id = v_user_id AND password = pwaf_extensions.crypt(v_password, v_salt)
			) THEN
				-- Success
				UPDATE pwaf.security_sessions SET user_id=v_user_id WHERE id=in_request.session_id;
				v_response := ('text/html;charset=utf-8'::pwaf.http_response_content_type,'',307,'{"Location: /"}')::pwaf.http_response;
			END IF;

		END IF;
		
	END IF;

	IF v_response IS NULL THEN

		v_data := '<form action="" method="POST"><input type="text" name="security_login_username" /><input type="password" name="security_login_password" /><input type="submit" value="OK" /></form>';
		v_response := ('text/html;charset=utf-8'::pwaf.http_response_content_type,v_data,200,NULL)::pwaf.http_response;

	END IF;

	RETURN v_response;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf.pub_controller_security_web_login(pwaf.http_request) OWNER TO pwaf;

DELETE FROM pwaf.http_request_routes WHERE path = '/security/login';
INSERT INTO pwaf.http_request_routes (id, path, controller) VALUES (401, '/security/login','pwaf.pub_controller_security_web_login');
--