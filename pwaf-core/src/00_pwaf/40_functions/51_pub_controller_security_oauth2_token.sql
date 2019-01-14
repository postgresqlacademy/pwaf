---
CREATE OR REPLACE FUNCTION pwaf.pub_controller_security_oauth2_token(
	in_request pwaf.http_request
)
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
	v_username text;
	v_password text;
	v_grant_type text;
	v_client_id text;
	v_client_secret text;
	v_code text;
	v_redirect_uri text;

	v_cookie_id text;

	v_user_id bigint;
	v_key text;
	v_headers text[];
BEGIN

	v_headers = array['Allow: HEAD,GET,PUT,DELETE,OPTIONS',
		'Access-Control-Allow-Methods: HEAD,GET,PUT,DELETE,OPTIONS',
		'Access-Control-Allow-Origin: *',
		'Access-Control-Allow-Headers: X-Requested-With, Content-Type'];

	/**
	 *  some info: https://aaronparecki.com/articles/2012/07/29/1/oauth2-simplified
	 */
	
	v_username := pwaf.pub_http_request_param_get(in_request,'username');
	v_password := pwaf.pub_http_request_param_get(in_request,'password');
	v_grant_type := pwaf.pub_http_request_param_get(in_request,'grant_type');
	v_client_id := pwaf.pub_http_request_param_get(in_request,'client_id');
	v_client_secret := pwaf.pub_http_request_param_get(in_request,'client_secret');
	v_code := pwaf.pub_http_request_param_get(in_request,'code');
	v_redirect_uri := pwaf.pub_http_request_param_get(in_request,'redirect_uri');

	v_cookie_id := pwaf.pub_http_request_param_get(in_request,'tmp_id');

	-- implement the case where user is already authenticated and has cookie, we already know that it is that user, 
	--    we just need a token that would be different than cookie itself

	IF(v_grant_type='web_session' AND in_request.method!='OPTIONS'::pwaf.http_request_method) THEN

		--SELECT user_id INTO v_user_id FROM pwaf.security_sessions WHERE id=in_request.session_id;
		SELECT user_id INTO v_user_id FROM pwaf.security_sessions WHERE cookie=v_cookie_id;
		IF v_user_id>0 THEN
			v_key := pwaf.pub_security_oauth2_token_generate(v_user_id);
			RETURN ('application/json'::pwaf.http_response_content_type,'{"access_token":"'||v_key||'","expires_in":3600,"token_type":"bearer","scope":null}',200,v_headers)::pwaf.http_response;
		END IF;
		
	END IF;
	
	RETURN ('application/json'::pwaf.http_response_content_type,'{"status": "error"}',200,v_headers)::pwaf.http_response;

END;$BODY$

LANGUAGE plpgsql VOLATILE;

ALTER FUNCTION pwaf.pub_controller_security_oauth2_token(pwaf.http_request) OWNER TO pwaf;
---