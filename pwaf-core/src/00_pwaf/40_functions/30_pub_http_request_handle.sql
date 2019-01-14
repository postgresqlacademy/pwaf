--
CREATE OR REPLACE FUNCTION pwaf.pub_http_request_handle(request pwaf.http_request)
  RETURNS pwaf.http_response AS
$BODY$
/**
 * @package PWAF
 * @author Karolis Strumskis (karolis@strumskis.com)
 * @copyright (C) 2011-2019 postgresqlacademy.com and other contributors
 * @license Licensed under the MIT License
 * 
 * @version 0.1
 */
DECLARE
    route pwaf.http_request_route;
    v_session_id int;
    v_response pwaf.http_response;
    controller_name text;
BEGIN

	SELECT pwaf.sys_security_session_init(request) INTO v_session_id;

	request := (
		request.method,
		request.path,
		request.param_names,
		request.param_values,
		request.system_param_names,
		request.system_param_values,
		NULL,
		v_session_id
	)::pwaf.http_request;

	SELECT * FROM pwaf.sys_http_request_route(request) INTO route;

	-- check if controller is limited for valid user only
	IF NOT EXISTS(SELECT 1 FROM pwaf.security_sessions WHERE id = request.session_id AND user_id IS NOT NULL) AND EXISTS (SELECT 1 FROM pwaf.http_request_routes WHERE id=route.id AND require_valid_user = True) THEN

		v_response := ('text/html;charset=utf-8'::pwaf.http_response_content_type,'',307,'{"Location: /security/login"}')::pwaf.http_response;
		-- should write "last request to session object", so that it could be used when successful authentication is done
		-- also, maybe we should return unauthorized instead? or depending on controller/request type?

		-- what about calling authorization function that would be assigned to the route?

	ELSE 

		-- query and executed before_handlers, pass request to it
		-- authentication, authorization could be also treated as "before_handler"

		request := (
			request.method,
			request.path,
			request.param_names,
			request.param_values,
			request.system_param_names,
			request.system_param_values,
			route.path_for_controller,
			v_session_id
		)::pwaf.http_request;

		EXECUTE 'SELECT * FROM '||route.controller_name||'($1)' INTO v_response USING request;

		-- query and executed after_handlers, pass request and v_response to it

	END IF;

	RETURN v_response;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

ALTER FUNCTION pwaf.pub_http_request_handle(pwaf.http_request) OWNER TO pwaf;
--