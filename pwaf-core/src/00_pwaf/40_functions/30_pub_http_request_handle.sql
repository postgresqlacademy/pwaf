--
CREATE OR REPLACE FUNCTION pwaf.pub_http_request_handle(request pwaf.http_request)
  RETURNS pwaf.http_response AS
$BODY$
/**
 * @package PWAF
 * @author Karolis Strumskis (karolis@strumskis.com)
 * @copyright (C) 2011 postgresqlacademy.com and other contributors
 * @license Licensed under the MIT License
 * 
 * @version 0.1
 */
DECLARE
    route pwaf.http_request_route;
    session_id int;
    v_response pwaf.http_response;
    controller_name text;
BEGIN

	SELECT * FROM pwaf.sys_session_init(request) INTO session_id;

	request := (
		request.method,
		request.path,
		request.param_names,
		request.param_values,
		request.system_param_names,
		request.system_param_values,
		NULL,
		session_id
	)::pwaf.http_request;

	SELECT * FROM pwaf.sys_http_request_route(request) INTO route;

	-- check if controller is limited for valid user only
	IF NOT EXISTS(SELECT 1 FROM pwaf.auth_sessions WHERE id = request.session_id AND user_id IS NOT NULL) AND EXISTS (SELECT 1 FROM pwaf.http_request_routes WHERE id=route.id AND require_valid_user = True) THEN

		v_response := ('text/html;charset=utf-8'::pwaf.http_response_content_type,'',307,'{"Location: /security/login"}')::pwaf.http_response;

	ELSE 

		request := (
			request.method,
			request.path,
			request.param_names,
			request.param_values,
			request.system_param_names,
			request.system_param_values,
			route.path_for_controller,
			session_id
		)::pwaf.http_request;

		EXECUTE 'SELECT * FROM '||route.controller_name||'($1)' INTO v_response USING request;

	END IF;

	RETURN v_response;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf.pub_http_request_handle(pwaf.http_request) OWNER TO pwaf;
--