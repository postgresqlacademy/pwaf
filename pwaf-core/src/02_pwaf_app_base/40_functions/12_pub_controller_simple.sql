--
CREATE OR REPLACE FUNCTION pwaf_app_base.pub_controller_simple(in_request pwaf.http_request)
  RETURNS pwaf.http_response AS
$BODY$
/**
 * @package PWAF
 * @author Karolis Strumskis (karolis@strumskis.com)
 * @copyright (C) 2015 postgresqlacademy.com and other contributors
 * @license Licensed under the MIT License
 * 
 * @version 0.1
 */
DECLARE
	v_response pwaf.http_response;
	v_html pwaf.html;
BEGIN

	v_html := 'Empty response of a simple controller';

	v_response := ('text/html;charset=utf-8'::pwaf.http_response_content_type,pwaf.t_wrapper(v_html, 'Simple Controller'),200,NULL)::pwaf.http_response;

	RETURN v_response;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf_app_base.pub_controller_simple(pwaf.http_request) OWNER TO pwaf;
--