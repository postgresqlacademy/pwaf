--
CREATE OR REPLACE FUNCTION pwaf_app_dba.pub_controller_dashboard(in_request pwaf.http_request)
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
	v_html pwaf.html;
	v_final_json text;
BEGIN

	--v_final_json := pg_typeof(in_refcursor)::oid;

	IF array_length(in_request.path_for_controller,1) = 1 AND in_request.path_for_controller[1] = 'data.json' THEN
		
		v_final_json := pwaf.pub_util_tojson('SELECT schemaname||''.''||relname objectname,pg_stat_user_tables.* FROM pg_catalog.pg_stat_user_tables ORDER BY seq_scan DESC LIMIT 10'::pwaf.sql_query);
		v_response := ('application/json'::pwaf.http_response_content_type,v_final_json,200,NULL)::pwaf.http_response;

	ELSEIF array_length(in_request.path_for_controller,1) IS NOT NULL THEN
		v_response := ('text/html;charset=utf-8'::pwaf.http_response_content_type,'',307,'{"Location: /pwaf_app_dba/about"}')::pwaf.http_response;
	ELSE
		SELECT pwaf.pub_view_render(in_request, 'pwaf_app_dba_main', NULL, 'PWAF DBA') INTO v_html;
		v_response := ('text/html;charset=utf-8'::pwaf.http_response_content_type,v_html,200,NULL)::pwaf.http_response;
	END IF;

	RETURN v_response;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf_app_dba.pub_controller_dashboard(pwaf.http_request)
  OWNER TO pwaf;
