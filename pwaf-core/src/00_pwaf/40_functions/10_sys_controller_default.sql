--
CREATE OR REPLACE FUNCTION pwaf.sys_controller_default(request pwaf.http_request)
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
	response pwaf.http_response;
	html text;
BEGIN

	-- html := '<b>No route.</b> <br />'||array_to_string(request.path,'/');
	html := '<b>No route.</b>';

	response := ('text/html;charset=utf-8'::pwaf.http_response_content_type,html,404,NULL)::pwaf.http_response;
	
	RETURN response;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf.sys_controller_default(pwaf.http_request) OWNER TO pwaf;
--