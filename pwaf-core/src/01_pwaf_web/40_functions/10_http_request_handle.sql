--
CREATE OR REPLACE FUNCTION pwaf_web.http_request_handle(request pwaf_web.http_request)
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
	new_request pwaf.http_request;
	response pwaf.http_response;
	html text;
BEGIN

	new_request := (
		request.method,
		request.path,
		request.param_names,
		request.param_values,
		request.system_param_names,
		request.system_param_values,
		NULL,
		NULL
	)::pwaf.http_request;

	SELECT * FROM pwaf.pub_http_request_handle(new_request) INTO response;

	RETURN response;

END;$BODY$

  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;

ALTER FUNCTION pwaf_web.http_request_handle(pwaf_web.http_request) OWNER TO pwaf;
GRANT EXECUTE ON FUNCTION pwaf_web.http_request_handle(pwaf_web.http_request) TO pwaf_web;

--