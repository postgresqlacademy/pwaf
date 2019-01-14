---
CREATE OR REPLACE FUNCTION pwaf.pub_controller_api_rest_default(in_request pwaf.http_request)
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

	--- proceed with operations
	IF in_request.method='OPTIONS'::pwaf.http_request_method THEN

		v_response := ('text/html;charset=utf-8'::pwaf.http_response_content_type,v_html,200,v_headers)::pwaf.http_response;

	-- insert new object
	ELSEIF in_request.method='POST'::pwaf.http_request_method AND in_request.path_for_controller[1] IS NULL THEN

		v_json := pwaf.pub_http_request_param_get(in_request,'Request-Payload')::json;

		--- create a record
		v_new_key := pwaf.pub_util_random_string(32);

		--- get column list
		SELECT string_agg(column_name,',') INTO v_columns FROM information_schema.columns WHERE table_schema=(string_to_array(v_default_data_endpoint,'.'))[1] AND table_name=(string_to_array(v_default_data_endpoint,'.'))[2] AND column_name NOT IN ('id','key','created','modified','archived');
		
		--- check that access control property is set and is valid
		IF v_access_validator_property IS NOT NULL AND v_access_validator_value_query IS NOT NULL THEN

			--- get column list full sans access prop
			SELECT string_agg(column_name,',') INTO v_columns_full_without_access_property FROM information_schema.columns WHERE table_schema=(string_to_array(v_default_data_endpoint,'.'))[1] AND table_name=(string_to_array(v_default_data_endpoint,'.'))[2] AND column_name NOT IN (v_access_validator_property);

			--- check if data has essential column
			IF (SELECT (count(1)=0)::bool FROM (SELECT * FROM json_object_keys(v_json)) row WHERE row.json_object_keys=v_access_validator_property) THEN
				RETURN ('text/html;charset=utf-8'::pwaf.http_response_content_type,'Access control property #'||v_access_validator_property||'# value is not provided',400,v_headers)::pwaf.http_response;
			END IF;

			--- convert from key to id if necesary
			SELECT json_extract_path_text(v_json,v_access_validator_property)::text INTO v_valid_access_property_value;
			
			IF char_length(v_valid_access_property_value)=32 THEN
				EXECUTE 'SELECT id FROM '||v_abstract_data_store||' WHERE key=$1' INTO v_valid_access_property_value USING v_valid_access_property_value;

				SELECT pwaf.pub_util_json_object_set_key(v_json,v_access_validator_property,v_valid_access_property_value::int) INTO v_json;
			END IF;
			
			EXECUTE 'SELECT ('||v_valid_access_property_value::bigint||') IN ('||v_access_validator_value_query||')' INTO v_valid_access_property_value_is USING v_auth_token_user_id, v_json;

			IF NOT v_valid_access_property_value_is THEN
				RETURN ('text/html;charset=utf-8'::pwaf.http_response_content_type,'Access control property #'||v_access_validator_property||'# value is wrong',400,v_headers)::pwaf.http_response;
			END IF;

			EXECUTE 'INSERT INTO '||v_default_data_endpoint||' ('||v_columns||', key) select '||v_columns||', '''||v_new_key||''' from json_populate_record(null::'||v_default_data_endpoint||', $1)' USING v_json;

			EXECUTE 'select row_to_json(row)::text from (SELECT '||v_columns_full_without_access_property||', (SELECT ao.key FROM '||v_abstract_data_store||' ao WHERE ao.id='||v_access_validator_property||') '||v_access_validator_property||' FROM '||v_default_data_endpoint||' WHERE key=$2) row' INTO v_data USING v_auth_token_user_id, v_new_key;
		
		ELSE

			EXECUTE 'INSERT INTO '||v_default_data_endpoint||' ('||v_columns||', key) select '||v_columns||', '''||v_new_key||''' from json_populate_record(null::'||v_default_data_endpoint||', $1)' USING v_json;

			EXECUTE 'select row_to_json(row)::text from (SELECT * FROM '||v_default_data_endpoint||' WHERE key=$2) row' INTO v_data USING v_auth_token_user_id, v_new_key;
				
		END IF;

		IF v_data IS NULL THEN
			RETURN ('application/json'::pwaf.http_response_content_type,NULL,400,v_headers)::pwaf.http_response;
		END IF;

		RETURN ('application/json'::pwaf.http_response_content_type,v_data,201,array_append(v_headers,'Location: '||v_route_path||'/'||v_new_key||'?access_token='||pwaf.pub_http_request_param_get(in_request,'access_token')))::pwaf.http_response;


	-- insert new child for some object
	ELSEIF in_request.method='POST'::pwaf.http_request_method AND in_request.path_for_controller[2] IS NOT NULL THEN
		
		v_json := pwaf.pub_http_request_param_get(in_request,'Request-Payload')::json;

		--- create a record
		v_new_key := pwaf.pub_util_random_string(32);

		--- get column list
		SELECT string_agg(column_name,',') INTO v_columns FROM information_schema.columns WHERE table_schema=(string_to_array(v_child_default_data_endpoint,'.'))[1] AND table_name=(string_to_array(v_child_default_data_endpoint,'.'))[2] AND column_name NOT IN ('id','key','created','modified','archived');
		
		--- check that access control property is set and is valid
		IF v_child_access_validator_property IS NOT NULL AND v_child_access_validator_value_query IS NOT NULL THEN

			--- get column list full sans access prop
			SELECT string_agg(column_name,',') INTO v_columns_full_without_access_property FROM information_schema.columns WHERE table_schema=(string_to_array(v_child_default_data_endpoint,'.'))[1] AND table_name=(string_to_array(v_child_default_data_endpoint,'.'))[2] AND column_name NOT IN (v_child_access_validator_property);

			--- check if data has essential column
			IF v_child_access_validator_property!=v_rest_resource_name AND (SELECT (count(1)=0)::bool FROM (SELECT * FROM json_object_keys(v_json)) row WHERE row.json_object_keys=v_access_validator_property) THEN
				RETURN ('text/html;charset=utf-8'::pwaf.http_response_content_type,'Access control property #'||v_access_validator_property||'# value is not provided',400,v_headers)::pwaf.http_response;
			END IF;

			--- convert from key to id if necesary
			SELECT json_extract_path_text(v_json,v_access_validator_property)::text INTO v_valid_access_property_value;
			
			IF char_length(v_valid_access_property_value)=32 THEN
				EXECUTE 'SELECT id FROM '||v_abstract_data_store||' WHERE key=$1' INTO v_valid_access_property_value USING v_valid_access_property_value;

				SELECT pwaf.pub_util_json_object_set_key(v_json,v_access_validator_property,v_valid_access_property_value::int) INTO v_json;
			END IF;
			
			EXECUTE 'SELECT ('||v_valid_access_property_value::bigint||') IN ('||v_access_validator_value_query||')' INTO v_valid_access_property_value_is USING v_auth_token_user_id, v_json;

			IF NOT v_valid_access_property_value_is THEN
				RETURN ('text/html;charset=utf-8'::pwaf.http_response_content_type,'Access control property #'||v_access_validator_property||'# value is wrong',400,v_headers)::pwaf.http_response;
			END IF;

			EXECUTE 'INSERT INTO '||v_child_default_data_endpoint||' ('||v_columns||', key) select '||v_columns||', '''||v_new_key||''' from json_populate_record(null::'||v_default_data_endpoint||', $1)' USING v_json;

			EXECUTE 'UPDATE '||v_child_default_data_endpoint||' SET '||v_rest_resource_name||'=$1 WHERE key=$2' USING v_parent_object_id, v_new_key;

			EXECUTE 'select row_to_json(row)::text from (SELECT '||v_columns_full_without_access_property||', (SELECT ao.key FROM '||v_abstract_data_store||' ao WHERE ao.id='||v_access_validator_property||') '||v_access_validator_property||' FROM '||v_default_data_endpoint||' WHERE key=$2) row' INTO v_data USING v_auth_token_user_id, v_new_key;
		
		ELSE

			EXECUTE 'INSERT INTO '||v_child_default_data_endpoint||' ('||v_columns||', key) select '||v_columns||', '''||v_new_key||''' from json_populate_record(null::'||v_child_default_data_endpoint||', $1)' USING v_json;

			EXECUTE 'UPDATE '||v_child_default_data_endpoint||' SET '||v_rest_resource_name||'=$1 WHERE key=$2' USING v_parent_object_id, v_new_key;
			
			EXECUTE 'select row_to_json(row)::text from (SELECT * FROM '||v_child_default_data_endpoint||' WHERE key=$2) row' INTO v_data USING v_auth_token_user_id, v_new_key;
				
		END IF;

		IF v_data IS NULL THEN
			RETURN ('application/json'::pwaf.http_response_content_type,NULL,400,v_headers)::pwaf.http_response;
		END IF;

		RETURN ('application/json'::pwaf.http_response_content_type,v_data,201,array_append(v_headers,'Location: '||v_route_path||'/'||v_new_key||'?access_token='||pwaf.pub_http_request_param_get(in_request,'access_token')))::pwaf.http_response;
	
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

	--- get specific object
	ELSEIF in_request.method='GET'::pwaf.http_request_method AND in_request.path_for_controller[2] IS NULL THEN

		IF v_access_validator_property IS NOT NULL AND v_access_validator_value_query IS NOT NULL THEN
			--- get column list full sans access prop
			SELECT string_agg(column_name,',') INTO v_columns_full_without_access_property FROM information_schema.columns WHERE table_schema=(string_to_array(v_default_data_endpoint,'.'))[1] AND table_name=(string_to_array(v_default_data_endpoint,'.'))[2] AND column_name NOT IN (v_access_validator_property);
			
			v_object_access_validator := 'AND '||v_access_validator_property||' IN ('||v_access_validator_value_query||')';
			
			EXECUTE 'select row_to_json(row)::text from (SELECT '||v_columns_full_without_access_property||', (SELECT ao.key FROM '||v_abstract_data_store||' ao WHERE ao.id='||v_access_validator_property||') '||v_access_validator_property||' FROM '||v_default_data_endpoint||' WHERE key=$2 '||v_object_access_validator||') row' INTO v_data USING v_auth_token_user_id, in_request.path_for_controller[1];
			
		ELSE
			EXECUTE 'select row_to_json(row)::text from (SELECT * FROM '||v_default_data_endpoint||' WHERE key=$2) row' INTO v_data USING v_auth_token_user_id, in_request.path_for_controller[1];
		END IF;

		IF v_data IS NULL THEN
			RETURN ('application/json'::pwaf.http_response_content_type,'Resource doesn''t exist or no authorization to access the resource.',400,NULL)::pwaf.http_response;
		END IF;

		RETURN ('application/json'::pwaf.http_response_content_type,v_data,200,v_headers)::pwaf.http_response;

	-- get childs of specific object
	ELSEIF in_request.method='GET'::pwaf.http_request_method THEN

		IF v_access_validator_property IS NOT NULL AND v_child_access_validator_value_query IS NOT NULL THEN
			--- get column list full sans access prop
			SELECT string_agg(column_name,',') INTO v_columns_full_without_access_property FROM information_schema.columns WHERE table_schema=(string_to_array(v_child_default_data_endpoint,'.'))[1] AND table_name=(string_to_array(v_child_default_data_endpoint,'.'))[2] AND column_name NOT IN (v_child_access_validator_property);
			
			v_object_access_validator := ' '||v_child_access_validator_property||' IN ('||v_child_access_validator_value_query||')';
			
			EXECUTE 'select array_to_json(array_agg(row_to_json(row)))::text from (SELECT '||v_columns_full_without_access_property||', (SELECT ao.key FROM '||v_abstract_data_store||' ao WHERE ao.id='||v_child_access_validator_property||') '||v_child_access_validator_property||' FROM '||v_child_default_data_endpoint||' WHERE '||v_object_access_validator||' ORDER BY '||v_child_custom_ordering||') row LIMIT 100' INTO v_data USING v_auth_token_user_id;

		ELSE
			EXECUTE 'select array_to_json(array_agg(row_to_json(row)))::text from (SELECT * FROM '||v_child_default_data_endpoint||' WHERE '||v_rest_resource_name||'='||v_parent_object_id||' ORDER BY '||v_child_custom_ordering||') row LIMIT 100' INTO v_data;
		END IF;

		IF v_data IS NULL THEN
			v_data:='[]';
		END IF;
		
		RETURN ('application/json'::pwaf.http_response_content_type,v_data,200,v_headers)::pwaf.http_response;
		

	--- update child element
	ELSEIF in_request.method='PUT'::pwaf.http_request_method AND in_request.path_for_controller[1] IS NOT NULL AND in_request.path_for_controller[2] IS NOT NULL THEN

		v_json := pwaf.pub_http_request_param_get(in_request,'Request-Payload')::json;

		IF v_access_validator_property IS NOT NULL AND v_child_access_validator_value_query IS NOT NULL THEN
			--- get column list full sans access prop
			SELECT string_agg(column_name,',') INTO v_columns_full_without_access_property FROM information_schema.columns WHERE table_schema=(string_to_array(v_child_default_data_endpoint,'.'))[1] AND table_name=(string_to_array(v_child_default_data_endpoint,'.'))[2] AND column_name NOT IN (v_child_access_validator_property);
			
			v_object_access_validator := ' '||v_child_access_validator_property||' IN ('||v_child_access_validator_value_query||')';
			
			EXECUTE 'select id from (SELECT '||v_columns_full_without_access_property||', (SELECT ao.key FROM '||v_abstract_data_store||' ao WHERE ao.id='||v_child_access_validator_property||') '||v_child_access_validator_property||' FROM '||v_child_default_data_endpoint||' WHERE '||v_object_access_validator||' ORDER BY modified DESC) row LIMIT 100' INTO v_data_id USING v_auth_token_user_id;

		ELSE
			-- EXECUTE 'select id from (SELECT * FROM '||v_child_default_data_endpoint||' WHERE '||v_rest_resource_name||'='||v_parent_object_id||' ORDER BY modified DESC) row LIMIT 100' INTO v_data_id;
			EXECUTE 'select id from (SELECT * FROM '||v_child_default_data_endpoint||' WHERE key=$1) row' INTO v_data_id USING in_request.path_for_controller[3];
		END IF;

		IF v_data_id IS NULL THEN
			RETURN ('application/json'::pwaf.http_response_content_type,'Resource doesn''t exist or no authorization to access the resource.',400,NULL)::pwaf.http_response;

		ELSE
			-- EXECUTE 'DELETE FROM '||v_child_default_data_endpoint||' WHERE id=$1' USING v_data_id;

			v_json2 := json_extract_path(v_json,'property_values');
			IF(v_json2 IS NOT NULL) THEN
				EXECUTE 'UPDATE '||v_child_default_data_endpoint||' SET "property_values"=$2 WHERE id=$1' USING v_data_id, v_json2;
			END IF;

			---

			v_json2 := json_extract_path(v_json,'x');
			IF(v_json2 IS NOT NULL) THEN
				EXECUTE 'UPDATE '||v_child_default_data_endpoint||' SET "x"=$2 WHERE id=$1' USING v_data_id, v_json2::text::int;
			END IF;

			---

			v_json2 := json_extract_path(v_json,'y');
			IF(v_json2 IS NOT NULL) THEN
				EXECUTE 'UPDATE '||v_child_default_data_endpoint||' SET "y"=$2 WHERE id=$1' USING v_data_id, v_json2::text::int;
			END IF;

			---

			v_json2 := json_extract_path(v_json,'width');
			IF(v_json2 IS NOT NULL) THEN
				EXECUTE 'UPDATE '||v_child_default_data_endpoint||' SET "width"=$2 WHERE id=$1' USING v_data_id, v_json2::text::int;
			END IF;

			---

			v_json2 := json_extract_path(v_json,'height');
			IF(v_json2 IS NOT NULL) THEN
				EXECUTE 'UPDATE '||v_child_default_data_endpoint||' SET "height"=$2 WHERE id=$1' USING v_data_id, v_json2::text::int;
			END IF;

			---
			
			v_json2 := json_extract_path(v_json,'context_stage_width');
			IF(v_json2 IS NOT NULL) THEN
				EXECUTE 'UPDATE '||v_child_default_data_endpoint||' SET "context_stage_width"=$2 WHERE id=$1' USING v_data_id, v_json2::text::int;
			END IF;

			---
			
			v_json2 := json_extract_path(v_json,'context_stage_height');
			IF(v_json2 IS NOT NULL) THEN
				EXECUTE 'UPDATE '||v_child_default_data_endpoint||' SET "context_stage_height"=$2 WHERE id=$1' USING v_data_id, v_json2::text::int;
			END IF;

			---
			
			v_json2 := json_extract_path(v_json,'start_time');
			IF(v_json2 IS NOT NULL) THEN
				EXECUTE 'UPDATE '||v_child_default_data_endpoint||' SET "start_time"=$2 WHERE id=$1' USING v_data_id, v_json2::text::int;
			END IF;

			---

			v_json2 := json_extract_path(v_json,'end_time');
			IF(v_json2 IS NOT NULL) THEN
				EXECUTE 'UPDATE '||v_child_default_data_endpoint||' SET "end_time"=$2 WHERE id=$1' USING v_data_id, v_json2::text::int;
			END IF;

			---

			v_json2 := json_extract_path(v_json,'title');
			IF(v_json2 IS NOT NULL) THEN
				EXECUTE 'UPDATE '||v_child_default_data_endpoint||' SET "title"=$2 WHERE id=$1' USING v_data_id, v_json->>'title';
			END IF;

			---

			RETURN ('application/json'::pwaf.http_response_content_type,v_json2,200,v_headers)::pwaf.http_response;

			RETURN ('application/json'::pwaf.http_response_content_type,v_json2,404,v_headers)::pwaf.http_response;
			
		END IF;

		RETURN ('application/json'::pwaf.http_response_content_type,NULL,200,v_headers)::pwaf.http_response;
		
	ELSEIF in_request.method='DELETE'::pwaf.http_request_method AND in_request.path_for_controller[1] IS NOT NULL AND in_request.path_for_controller[2] IS NULL THEN

		IF v_access_validator_property IS NOT NULL AND v_access_validator_value_query IS NOT NULL THEN
			--- get column list full sans access prop
			SELECT string_agg(column_name,',') INTO v_columns_full_without_access_property FROM information_schema.columns WHERE table_schema=(string_to_array(v_default_data_endpoint,'.'))[1] AND table_name=(string_to_array(v_default_data_endpoint,'.'))[2] AND column_name NOT IN (v_access_validator_property);
			
			v_object_access_validator := 'AND '||v_access_validator_property||' IN ('||v_access_validator_value_query||')';
			
			EXECUTE 'select id from (SELECT '||v_columns_full_without_access_property||', (SELECT ao.key FROM '||v_abstract_data_store||' ao WHERE ao.id='||v_access_validator_property||') '||v_access_validator_property||' FROM '||v_default_data_endpoint||' WHERE key=$2 '||v_object_access_validator||') row' INTO v_data_id USING v_auth_token_user_id, in_request.path_for_controller[1];
			
		ELSE
			EXECUTE 'select id from (SELECT * FROM '||v_default_data_endpoint||' WHERE key=$2 '||v_object_access_validator||') row' INTO v_data_id USING v_auth_token_user_id, in_request.path_for_controller[1];
		END IF;

		IF v_data_id IS NULL THEN
			RETURN ('application/json'::pwaf.http_response_content_type,'Resource doesn''t exist or no authorization to access the resource.',400,NULL)::pwaf.http_response;

		ELSE
			EXECUTE 'DELETE FROM '||v_default_data_endpoint||' WHERE id=$1' USING v_data_id;
		END IF;

		RETURN ('application/json'::pwaf.http_response_content_type,NULL,200,v_headers)::pwaf.http_response;

	ELSEIF in_request.method='DELETE'::pwaf.http_request_method AND in_request.path_for_controller[1] IS NOT NULL AND in_request.path_for_controller[2] IS NOT NULL THEN

		IF v_access_validator_property IS NOT NULL AND v_child_access_validator_value_query IS NOT NULL THEN
			--- get column list full sans access prop
			SELECT string_agg(column_name,',') INTO v_columns_full_without_access_property FROM information_schema.columns WHERE table_schema=(string_to_array(v_child_default_data_endpoint,'.'))[1] AND table_name=(string_to_array(v_child_default_data_endpoint,'.'))[2] AND column_name NOT IN (v_child_access_validator_property);
			
			v_object_access_validator := ' '||v_child_access_validator_property||' IN ('||v_child_access_validator_value_query||')';
			
			EXECUTE 'select id from (SELECT '||v_columns_full_without_access_property||', (SELECT ao.key FROM '||v_abstract_data_store||' ao WHERE ao.id='||v_child_access_validator_property||') '||v_child_access_validator_property||' FROM '||v_child_default_data_endpoint||' WHERE '||v_object_access_validator||' ORDER BY modified DESC) row LIMIT 100' INTO v_data_id USING v_auth_token_user_id;

		ELSE
			--EXECUTE 'select id from (SELECT * FROM '||v_child_default_data_endpoint||' WHERE '||v_rest_resource_name||'='||v_parent_object_id||' ORDER BY modified DESC) row LIMIT 100' INTO v_data_id;
			EXECUTE 'select id from (SELECT * FROM '||v_child_default_data_endpoint||' WHERE key=$1) row' INTO v_data_id USING in_request.path_for_controller[3];
		END IF;

		IF v_data_id IS NULL THEN
			RETURN ('application/json'::pwaf.http_response_content_type,'Resource doesn''t exist or no authorization to access the resource.',400,NULL)::pwaf.http_response;

		ELSE
			EXECUTE 'DELETE FROM '||v_child_default_data_endpoint||' WHERE id=$1' USING v_data_id;
		END IF;

		RETURN ('application/json'::pwaf.http_response_content_type,NULL,200,v_headers)::pwaf.http_response;
		
	ELSE

		---

	END IF;

	v_response := ('text/html;charset=utf-8'::pwaf.http_response_content_type,v_html,200,v_headers)::pwaf.http_response;
	
	RETURN v_response;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf.pub_controller_api_rest_default(pwaf.http_request)
  OWNER TO pwaf;
---
