--
CREATE OR REPLACE FUNCTION pwaf.sys_controller_default(request pwaf.http_request)
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
	v_response pwaf.http_response;
	v_html text;
BEGIN

	v_html := '<b>No route.</b>';

	v_response := ('text/html;charset=utf-8'::pwaf.http_response_content_type,html,404,NULL)::pwaf.http_response;
	
	RETURN v_response;

END;$BODY$

LANGUAGE plpgsql VOLATILE;

ALTER FUNCTION pwaf.sys_controller_default(pwaf.http_request) OWNER TO pwaf;
--