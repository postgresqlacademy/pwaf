--
CREATE OR REPLACE FUNCTION pwaf.pub_view_render(in_request pwaf.http_request, in_view_code pwaf.code, in_data_refcursor refcursor, in_title text)
  RETURNS pwaf.html AS
$BODY$
/**
 * @package PWAF
 * @author Karolis Strumskis (karolis@strumskis.com)
 * @copyright (C) 2013 postgresqlacademy.com and other contributors
 * @license Licensed under the MIT License
 * 
 * @version 0.1
 */
DECLARE
	v_view_html 	pwaf.html;
	v_layout_html 	pwaf.html;
	v_response 		pwaf.html;
	v_template_code	pwaf.code;
	v_layout_template_code	pwaf.code;
	v_block			pwaf.v_gui_views_layout_block%rowtype;
	v_content		text[];
	v_content_temp	pwaf.html;
	v_content_cur	refcursor;
	v_tmp			text DEFAULT '';
BEGIN

	-- get view parameters
	SELECT template_code, layout_template_code FROM pwaf.v_gui_views WHERE code=in_view_code INTO v_template_code, v_layout_template_code;

	-- generating html of the view
	SELECT pwaf.pub_html_render(v_template_code, in_data_refcursor) INTO v_view_html;

	v_content[0] := v_view_html;

	-- generating html of layout blocks
	for v_block in select * from pwaf.v_gui_views_layout_block WHERE view_code=in_view_code loop
		OPEN v_content_cur FOR EXECUTE 'SELECT * FROM '||v_block.block_function||'($1,$2)'  USING in_request, v_block.block_code::pwaf.code;
		SELECT pwaf.pub_html_render(v_block.block_template, v_content_cur) INTO v_content_temp;
		CLOSE v_content_cur;
		IF v_content[v_block.block_zone-1] IS NULL THEN
			v_content[v_block.block_zone-1] = '';
		END IF;
		v_content[v_block.block_zone-1] := v_content[v_block.block_zone-1]::text||v_content_temp::text;
	end loop;

	-- put everything into layout
	OPEN v_content_cur FOR SELECT * FROM unnest(v_content);
	SELECT pwaf.pub_html_render(v_layout_template_code, v_content_cur) INTO v_layout_html;
	CLOSE v_content_cur;

	v_response:= replace(v_layout_html,'${title}',in_title);

	RETURN v_response;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf.pub_view_render(pwaf.http_request, pwaf.code, refcursor, text) OWNER TO pwaf;
--