--
CREATE OR REPLACE FUNCTION pwaf_app_admin.sys_controller_create(in_schema text, in_controller_shortname text)
  RETURNS void AS
$BODY$
/**
 * @package PWAF
 * @author Karolis Strumskis (karolis@strumskis.com)
 * @copyright (C) 2014 postgresqlacademy.com and other contributors
 * @license Licensed under the MIT License
 * 
 * @version 0.1
 */
DECLARE
	v_id bigint;
	v_salt text;
BEGIN
	
	EXECUTE '
	CREATE OR REPLACE FUNCTION '||in_schema||'.pub_controller_'||in_controller_shortname||'(in_request pwaf.http_request)
	  RETURNS pwaf.http_response AS
	$_BODY_$
	/**
	 * ...
	 */
	DECLARE
		v_response pwaf.http_response;
		v_html pwaf.html;
	BEGIN

		v_html := ''<p>This is a blank controller</p>'';

		v_response := (''text/html;charset=utf-8''::pwaf.http_response_content_type,v_html,200,NULL)::pwaf.http_response;

		RETURN v_response;

	END;$_BODY_$
	  LANGUAGE plpgsql VOLATILE
	  COST 100
	';

	EXECUTE 'ALTER FUNCTION '||in_schema||'.pub_controller_'||in_controller_shortname||'(pwaf.http_request) OWNER TO pwaf';
	
	EXECUTE 'INSERT INTO '||in_schema||'.http_request_routes(path, controller) VALUES (''/'||in_schema||'/'||in_controller_shortname||''', '''||in_schema||'.pub_controller_'||in_controller_shortname||''')';

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf_app_admin.sys_controller_create(in_schema text, in_controller_shortname text)
  OWNER TO pwaf;
---
