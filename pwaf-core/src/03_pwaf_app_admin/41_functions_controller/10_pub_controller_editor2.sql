---
CREATE OR REPLACE FUNCTION pwaf_app_admin.pub_controller_editor2(in_request pwaf.http_request)
  
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

	v_selector_html text;
	v_header_html text;

	v_mode text;
BEGIN

	v_header_html := '<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>';
	
	SELECT pwaf.pub_http_request_param_get(in_request,'data') INTO v_post_data;

	SELECT array_length(in_request.path_for_controller,1) INTO v_path_length;

	IF in_request.path_for_controller[1] = 'asset' THEN

		SELECT pwaf.t_dropdown_with_autoredirect('SELECT ''/pwaf_app_admin/editor2/asset/'' || n.nspname ||''/''|| a.name, n.nspname || '' | '' || a.name FROM pwaf.assets a, pg_class c, pg_namespace n WHERE a.tableoid = c.oid AND c.relnamespace = n.oid',
			'/pwaf_app_admin/editor2/asset/'||in_request.path_for_controller[2]||'/'||in_request.path_for_controller[3]) INTO v_selector_html;

	END IF;

	IF in_request.path_for_controller[1] = 'asset' AND v_path_length = 3 THEN

		IF v_post_data IS NOT NULL THEN
			UPDATE pwaf.assets as a SET data=v_post_data FROM pg_class c, pg_namespace n WHERE a.name=in_request.path_for_controller[3] AND a.tableoid = c.oid AND c.relnamespace=n.oid AND n.nspname=in_request.path_for_controller[2];
		END IF;

		SELECT a.data FROM pwaf.assets a, pg_class c, pg_namespace n  WHERE a.name=in_request.path_for_controller[3] AND a.tableoid = c.oid AND c.relnamespace=n.oid AND n.nspname=in_request.path_for_controller[2] INTO v_data;

	END IF;

	IF in_request.path_for_controller[1] = 'template' THEN

		v_resource_id := in_request.path_for_controller[array_lower(in_request.path_for_controller,1)::int+1];

		SELECT pwaf.t_dropdown_with_autoredirect('SELECT ''/pwaf_app_admin/editor2/template/'' || t.code, n.nspname || '' | '' || t.code || '' ( '' || t.description || '')'' FROM pwaf.gui_templates t, pg_class c, pg_namespace n WHERE t.tableoid = c.oid AND c.relnamespace = n.oid',
			'/pwaf_app_admin/editor2/template/'||v_resource_id) INTO v_selector_html;

	END IF;

	IF in_request.path_for_controller[1] = 'template' AND v_path_length = 2 THEN

		v_resource_id := in_request.path_for_controller[array_lower(in_request.path_for_controller,1)::int+1];

		IF v_post_data IS NOT NULL THEN
			UPDATE pwaf.gui_templates SET xslt_stylesheet=v_post_data WHERE code=v_resource_id;
		END IF;

		SELECT xslt_stylesheet FROM pwaf.gui_templates WHERE code=v_resource_id INTO v_data;

	END IF;

	IF in_request.path_for_controller[1] = 'template' THEN
		v_mode := 'text/html';
	END IF;

	IF in_request.path_for_controller[1] = 'asset' THEN
		v_mode := 'text/css';
	END IF;
	
	IF v_data IS NOT NULL THEN

		v_data := v_header_html||'
		<body style="margin:0;padding:0">

		<link data-name="vs/editor/editor.main" rel="stylesheet" href="https://microsoft.github.io/monaco-editor/node_modules/monaco-editor/min/vs/editor/editor.main.css">

		<script>var require = { paths: { "vs": "https://microsoft.github.io/monaco-editor/node_modules/monaco-editor/min/vs" } };</script>
		<script src="https://microsoft.github.io/monaco-editor/node_modules/monaco-editor/min/vs/loader.js"></script>
		<script src="https://microsoft.github.io/monaco-editor/node_modules/monaco-editor/min/vs/editor/editor.main.nls.js"></script>
		<script src="https://microsoft.github.io/monaco-editor/node_modules/monaco-editor/min/vs/editor/editor.main.js"></script>

		<script src="https://microsoft.github.io/monaco-editor/node_modules/monaco-editor/min/vs/language/css/cssMode.js"></script>
		<script src="https://microsoft.github.io/monaco-editor/node_modules/monaco-editor/min/vs/basic-languages/src/css.js"></script>
		<script src="https://microsoft.github.io/monaco-editor/node_modules/monaco-editor/min/vs/base/worker/workerMain.js"></script>


		<div style="background:#d4d4d4;border-bottom:1px solid #333; padding: 3px;">
			'||v_selector_html||'
			<input type="submit" value="Save" style="margin:0 10px" />
			<a href="/pwaf_app_admin/">Back to Dashboard</a>
		</div>
		<textarea style="display:none" name="data" id="data">'||v_data||'</textarea>
		<div id="container" style="height:100%;"></div>
		
		<script>
			monaco.editor.create(document.getElementById("container"), {
				value: jQuery("#data").val(),
				language: "css"
			});
		</script>';
		v_response := ('text/html;charset=utf-8'::pwaf.http_response_content_type,v_data,200,NULL)::pwaf.http_response;

	ELSE
		
		v_data := v_header_html||'
		<body style="margin:0;padding:0">
		<div style="background:#d4d4d4;border-bottom:1px solid #333; padding: 3px;">
			Please select an item to edit: '||v_selector_html||'
			<a href="/pwaf_app_admin/">Back to Dashboard</a>
		</div>';

		v_response := ('text/html;charset=utf-8'::pwaf.http_response_content_type,v_data,404,NULL)::pwaf.http_response;

	END IF;

	RETURN v_response;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf_app_admin.pub_controller_editor2(pwaf.http_request) OWNER TO pwaf;
---
