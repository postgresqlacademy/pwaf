--
CREATE OR REPLACE FUNCTION pwaf.pub_http_request_param_get(in_request pwaf.http_request, in_param_name text)
  RETURNS text AS
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
	v_param_name text;
	v_index int;
BEGIN

	FOR v_index IN SELECT * FROM generate_series(1, array_length(in_request.param_names,1)) LOOP
		IF in_request.param_names[v_index] = in_param_name THEN
			RETURN convert_from(decode(in_request.param_values[v_index], 'base64'),'UTF8');
		END IF;
	END LOOP;

	RETURN NULL;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf.pub_http_request_param_get(pwaf.http_request, text) OWNER TO pwaf;
--