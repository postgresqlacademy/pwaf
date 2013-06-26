--
CREATE OR REPLACE FUNCTION pwaf.sys_http_request_route(request pwaf.http_request)
  RETURNS pwaf.http_request_route AS
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
	v_route pwaf.http_request_route;
	v_route_id int;
	v_path text;
	v_path_element text;
	v_path_element_count int;
	v_path_for_controller text[];
	v_path_for_route text[];
	v_controller_name text;
BEGIN

	v_path := '/' || array_to_string(request.path,'/');

	-- if found match
	SELECT controller, id INTO v_controller_name, v_route_id FROM pwaf.http_request_routes WHERE "path" LIKE v_path;

	IF v_controller_name IS NULL THEN

		v_path_for_route := request.path;
		v_path_element_count := 0;

		FOR v_path_element IN SELECT * FROM generate_series(1,array_upper(request.path,1)) LOOP

			v_path_for_route := v_path_for_route[array_lower(v_path_for_route,1) : array_upper(v_path_for_route,1)-1];

			v_path := '/' || array_to_string(v_path_for_route,'/');

			SELECT controller, id INTO v_controller_name, v_route_id FROM pwaf.http_request_routes WHERE "path" LIKE v_path;
			
			IF v_controller_name IS NOT NULL THEN
				EXIT;
			END IF;

			v_path_element_count := v_path_element_count+1;

		END LOOP;

		v_path_for_controller := request.path[(array_upper(request.path,1)-v_path_element_count) : array_upper(request.path,1)];
		
	END IF;

	IF v_controller_name IS NULL THEN
		v_controller_name := 'pwaf.sys_controller_default';
		v_path_for_route := array['/'];
	END IF;

	v_route := (v_route_id,v_controller_name,v_path_for_route,v_path_for_controller);

	RETURN v_route;
	
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf.sys_http_request_route(pwaf.http_request) OWNER TO pwaf;
--