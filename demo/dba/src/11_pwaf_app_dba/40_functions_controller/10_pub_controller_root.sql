--
CREATE OR REPLACE FUNCTION pwaf_app_dba.pub_controller_root(in_request pwaf.http_request)
  RETURNS pwaf.http_response AS
$BODY$
/**
 * @package PWAF_APP_DBA
 * @author Karolis Strumskis (karolis@strumskis.com)
 * @copyright (C) 2013 postgresqlacademy.com and other contributors
 * @license Licensed under the GPLv3
 * 
 * @version 0.1
 */
DECLARE
	v_response pwaf.http_response;
BEGIN

	IF array_length(in_request.path_for_controller,1) IS NULL THEN
		v_response := ('text/html;charset=utf-8'::pwaf.http_response_content_type,'',307,'{"Location: /pwaf_app_dba/dashboard"}')::pwaf.http_response;
	ELSE
		v_response := ('text/html;charset=utf-8'::pwaf.http_response_content_type,'Not found.',404,NULL)::pwaf.http_response;
	END IF;
	
	RETURN v_response;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf_app_dba.pub_controller_root(pwaf.http_request) OWNER TO pwaf;
--