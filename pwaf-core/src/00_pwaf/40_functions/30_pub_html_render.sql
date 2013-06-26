--
CREATE OR REPLACE FUNCTION pwaf.pub_html_render(in_template_code pwaf.code, in_query pwaf.sql_query)
  RETURNS pwaf.html AS
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
	v_result pwaf.html;
BEGIN

	SELECT pwaf.xslt_process(
		(SELECT query_to_xml_and_xmlschema(in_query, true, false, ''))::text,
		(SELECT xslt_stylesheet FROM pwaf.gui_templates WHERE code=in_template_code)::text,
		''
	)::pwaf.html INTO v_result;

	RETURN v_result;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf.pub_html_render(pwaf.code, pwaf.sql_query) OWNER TO pwaf;
--

--
CREATE OR REPLACE FUNCTION pwaf.pub_html_render(in_template_code pwaf.code, in_data refcursor)
  RETURNS pwaf.html AS
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
	v_result pwaf.html;
    v_data_xml xml;
    v_data_xmlschema xml;
BEGIN

       SELECT cursor_to_xml(in_data::refcursor,1000, true, false, '')::xml INTO v_data_xml;
       SELECT cursor_to_xmlschema(in_data::refcursor, true, false, '')::xml INTO v_data_xmlschema;

	SELECT pwaf.xslt_process(
		xmlelement(name table,xmlconcat(v_data_xmlschema,v_data_xml))::text,
		(SELECT xslt_stylesheet FROM pwaf.gui_templates WHERE code=in_template_code)::text,
		''
	)::pwaf.html INTO v_result;

	RETURN v_result;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf.pub_html_render(pwaf.code, refcursor) OWNER TO pwaf;
--
