--
CREATE OR REPLACE FUNCTION pwaf.pub_controller_security_web_logout(in_request pwaf.http_request)
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

	-- Success
	UPDATE pwaf.security_sessions SET user_id=NULL WHERE id=in_request.session_id;
	v_response := ('text/html;charset=utf-8'::pwaf.http_response_content_type,'',307,'{"Location: /"}')::pwaf.http_response;

	RETURN v_response;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf.pub_controller_security_web_logout(pwaf.http_request) OWNER TO pwaf;

DELETE FROM pwaf.http_request_routes WHERE path = '/security/logout';
INSERT INTO pwaf.http_request_routes (id, path, controller) VALUES (402, '/security/logout','pwaf.pub_controller_security_web_logout');
--