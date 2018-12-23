--
CREATE OR REPLACE FUNCTION pwaf_app_admin.pub_controller_main(in_request pwaf.http_request)
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
BEGIN

	
	v_data := '
	<body style="margin:0;padding:0">
	<h1>PWAF Admin Dashboard</h1>
	<div></div>
	<style>
	.disabled{
		color: #999;
	}
	</style>
	';
	v_data := v_data||'<b>Create new:</b><ul>';
	v_data := v_data||'<li><a href="#" class="disabled">App</a></li>';
	v_data := v_data||'<li><a href="#" class="disabled">App URL Controller</a></li>';
	v_data := v_data||'<li><a href="#" class="disabled">Asset</a></li>';
	v_data := v_data||'<li><a href="#" class="disabled">Template</a></li>';
	v_data := v_data||'<li><a href="#" class="disabled">User</a></li>';

	v_data := v_data||'</ul><b>Edit: </b><ul>';
	v_data := v_data||'<li><a href="/pwaf_app_admin/editor/asset/">Assets</a></li>';
	v_data := v_data||'<li><a href="/pwaf_app_admin/editor/template/">Templates</a></li>';
	v_data := v_data||'<li><a href="/pwaf_app_admin/editor/function/">Functions</a></li>';

	v_data := v_data||'</ul>';

	v_response := ('text/html;charset=utf-8'::pwaf.http_response_content_type,v_data,200,NULL)::pwaf.http_response;
	
	RETURN v_response;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf_app_admin.pub_controller_main(pwaf.http_request) OWNER TO pwaf;
--