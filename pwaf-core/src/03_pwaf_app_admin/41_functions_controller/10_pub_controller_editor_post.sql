---
CREATE OR REPLACE FUNCTION pwaf_app_admin.pub_controller_editor_post(in_request pwaf.http_request)
  
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
	v_response 	pwaf.http_response;
	v_data 		text;
	v_post_data	text;
	v_content_type	pwaf.http_response_content_type;
	v_path_length int;

	v_resource_id text;
BEGIN

	
	SELECT pwaf.pub_http_request_param_get(in_request,'data') INTO v_post_data;

	SELECT array_length(in_request.path_for_controller,1) INTO v_path_length;

	IF in_request.path_for_controller[1] = 'asset' AND v_path_length = 3 THEN

		IF v_post_data IS NOT NULL THEN
			UPDATE pwaf.assets as a SET data=v_post_data FROM pg_class c, pg_namespace n WHERE a.name=in_request.path_for_controller[3] AND a.tableoid = c.oid AND c.relnamespace=n.oid AND n.nspname=in_request.path_for_controller[2];
		END IF;

	END IF;

	IF in_request.path_for_controller[1] = 'template' AND v_path_length = 2 THEN

		v_resource_id := in_request.path_for_controller[array_lower(in_request.path_for_controller,1)::int+1];

		IF v_post_data IS NOT NULL THEN
			UPDATE pwaf.gui_templates SET xslt_stylesheet=v_post_data WHERE code=v_resource_id;
		END IF;

	END IF;
	
	
	v_response := ('text/html;charset=utf-8'::pwaf.http_response_content_type,'ok',200,NULL)::pwaf.http_response;

	RETURN v_response;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf_app_admin.pub_controller_editor_post(pwaf.http_request) OWNER TO pwaf;
---
