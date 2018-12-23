---
CREATE OR REPLACE FUNCTION pwaf.pub_controller_api_rest_search(in_request pwaf.http_request)
  RETURNS pwaf.http_response AS
$BODY$

DECLARE
	v_html text;
	v_data text;
	v_response pwaf.http_response;
	v_headers text[];
	v_route pwaf.http_request_route;

	v_object_access_validator text;
	v_access_validator_property text;
	v_access_validator_value_query text;
	v_default_data_endpoint text;
	v_auth_token text;
	v_auth_token_user_id bigint;
	v_readonly_fields text[];
	v_columns text;
	v_columns_full_without_access_property text;
	v_json json;
	v_json2 json;
	v_valid_access_property_value_is boolean;
	v_valid_access_property_value text;
	v_abstract_data_store text;
	v_new_key text;
	v_route_path text;
	v_rest_resource_name text;
	v_child_default_data_endpoint text;
	v_child_access_validator_property  text;
	v_child_access_validator_value_query text;
	v_child_route_path text;
	v_child_rest_resource_name text;
	v_parent_object_id int;
	v_data_id int;
	v_custom_ordering text;
	v_child_custom_ordering text;
BEGIN

	v_abstract_data_store = 'data_main.abstract_object';

	--- some config
	v_headers = array['Allow: HEAD,GET,PUT,DELETE,OPTIONS',
		'Access-Control-Allow-Methods: HEAD,GET,PUT,DELETE,OPTIONS',
		'Access-Control-Allow-Origin: *',
		'Access-Control-Allow-Headers: X-Requested-With, Content-Type'];

	--- some authorization
	SELECT user_id INTO v_auth_token_user_id FROM pwaf.auth_security_tokens WHERE valid_till>NOW() AND key=pwaf.pub_http_request_param_get(in_request,'access_token');
	
	IF v_auth_token_user_id IS NULL THEN
		RETURN ('application/json'::pwaf.http_response_content_type,'Bad token.',400,v_headers)::pwaf.http_response;
	END IF;

	--- endpoint config
	v_route := pwaf.sys_http_request_route(in_request);
	SELECT 
		default_data_endpoint,
		access_validator_property,
		access_validator_value_query,
		path,
		rest_resource_name,
		custom_ordering
	INTO 
		v_default_data_endpoint,
		v_access_validator_property,
		v_access_validator_value_query,
		v_route_path,
		v_rest_resource_name,
		v_custom_ordering
		
	FROM pwaf.api_rest_endpoint_routes WHERE id = v_route.id;

	IF v_custom_ordering IS NULL THEN
		v_custom_ordering := 'modified DESC';
	END IF;

	IF in_request.path_for_controller[2] IS NOT NULL THEN

		SELECT 
			default_data_endpoint,
			access_validator_property,
			access_validator_value_query,
			path,
			rest_resource_name,
			custom_ordering
		INTO 
			v_child_default_data_endpoint,
			v_child_access_validator_property,
			v_child_access_validator_value_query,
			v_child_route_path,
			v_child_rest_resource_name,
			v_child_custom_ordering
			
		FROM pwaf.api_rest_endpoint_routes WHERE rest_resource_name = in_request.path_for_controller[2];

		IF v_child_custom_ordering IS NULL THEN
			v_child_custom_ordering := 'modified DESC';
		END IF;

		EXECUTE 'SELECT id FROM '||v_default_data_endpoint||' WHERE key = $1' INTO v_parent_object_id USING in_request.path_for_controller[1];

	END IF;

	
	--- get list of objects
	ELSEIF in_request.method='GET'::pwaf.http_request_method AND in_request.path_for_controller[1] IS NULL THEN

		IF v_access_validator_property IS NOT NULL AND v_access_validator_value_query IS NOT NULL THEN
			--- get column list full sans access prop
			SELECT string_agg(column_name,',') INTO v_columns_full_without_access_property FROM information_schema.columns WHERE table_schema=(string_to_array(v_default_data_endpoint,'.'))[1] AND table_name=(string_to_array(v_default_data_endpoint,'.'))[2] AND column_name NOT IN (v_access_validator_property);
			
			v_object_access_validator := ' '||v_access_validator_property||' IN ('||v_access_validator_value_query||')';
			
			EXECUTE 'select array_to_json(array_agg(row_to_json(row)))::text from (SELECT '||v_columns_full_without_access_property||', (SELECT ao.key FROM '||v_abstract_data_store||' ao WHERE ao.id='||v_access_validator_property||') '||v_access_validator_property||' FROM '||v_default_data_endpoint||' WHERE '||v_object_access_validator||' ORDER BY '||v_custom_ordering||') row LIMIT 100' INTO v_data USING v_auth_token_user_id;
			
		ELSE
			EXECUTE 'select array_to_json(array_agg(row_to_json(row)))::text from (SELECT * FROM '||v_default_data_endpoint||' ORDER BY '||v_custom_ordering||') row LIMIT 100' INTO v_data;
		END IF;

		IF v_data IS NULL THEN
			v_data:='[]';
		END IF;
		
		RETURN ('application/json'::pwaf.http_response_content_type,v_data,200,v_headers)::pwaf.http_response;

	
	ELSE

		---

	END IF;

	v_response := ('text/html;charset=utf-8'::pwaf.http_response_content_type,v_html,200,v_headers)::pwaf.http_response;
	
	RETURN v_response;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf.pub_controller_api_rest_search(pwaf.http_request)
  OWNER TO pwaf;
---
