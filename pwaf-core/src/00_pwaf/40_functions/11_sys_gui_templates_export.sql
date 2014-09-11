--
CREATE OR REPLACE FUNCTION pwaf.sys_gui_templates_export(in_template_code text)
  RETURNS text AS
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
	v_result text;
BEGIN

	SELECT regexp_replace(regexp_replace(xslt_stylesheet, '\r\n', '\\r\\n', 'g'), '\t' ,'    ', 'g') INTO v_result FROM pwaf.gui_templates WHERE code=in_template_code;

	RETURN v_result;
	
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf.sys_gui_templates_export(text) OWNER TO pwaf;
COMMENT ON FUNCTION pwaf.sys_gui_templates_export(text) IS 'Export template as a one liner for use in SQL data files';
--