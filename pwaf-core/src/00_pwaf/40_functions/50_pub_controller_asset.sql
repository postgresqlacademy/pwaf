--
CREATE OR REPLACE FUNCTION pwaf.pub_controller_asset(in_request pwaf.http_request)
  RETURNS pwaf.http_response AS
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
	v_response 	pwaf.http_response;
	v_data 		text;
	v_content_type	pwaf.http_response_content_type;
BEGIN

	IF array_length(in_request.path_for_controller,1) = 2 THEN

		SELECT content_type, data FROM pwaf.assets a, pg_class c, pg_namespace n  WHERE a.name=in_request.path_for_controller[2] AND a.tableoid = c.oid AND c.relnamespace=n.oid AND n.nspname=in_request.path_for_controller[1] INTO v_content_type, v_data;

		IF v_content_type IS NOT NULL THEN
			v_response := (v_content_type,v_data,200,NULL)::pwaf.http_response;
		END IF;
		
	END IF;

	-- if asset was not found or parameter not given
	IF v_response IS NULL THEN
		v_data := 'Not found.';
		v_response := ('text/html;charset=utf-8'::pwaf.http_response_content_type,v_data,404,NULL)::pwaf.http_response;
	END IF;

	RETURN v_response;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf.pub_controller_asset(pwaf.http_request) OWNER TO pwaf;

DELETE FROM pwaf.http_request_routes WHERE path = '/asset' AND controller = 'pwaf.pub_controller_asset';
INSERT INTO pwaf.http_request_routes (id, path,controller) VALUES (101, '/asset','pwaf.pub_controller_asset');
--