--
CREATE OR REPLACE FUNCTION pwaf.t_dropdown_with_autoredirect(in_query_sql text, in_current_value text)
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
	v_col_value text;
	v_col_title text;
	v_selected text;
BEGIN
	
	v_result := '<select onchange="location.href=jQuery(this).val()">';

	IF in_current_value IS NULL THEN
		v_result := v_result||'<option>---</option>';
	END IF;

	FOR v_col_value, v_col_title IN EXECUTE in_query_sql LOOP
		
		v_selected := '';

		IF in_current_value = v_col_value THEN
			v_selected := ' selected ';
		END IF;

		v_result := v_result || '<option value="'||v_col_value||'" '||v_selected||'>'||v_col_title||'</option>';

	END LOOP;

	v_result := v_result || '</select>';

	RETURN v_result;
	
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf.t_dropdown_with_autoredirect(text, text) OWNER TO pwaf;
COMMENT ON FUNCTION pwaf.t_dropdown_with_autoredirect(text, text) IS '';
--