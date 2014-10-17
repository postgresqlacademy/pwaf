--
CREATE OR REPLACE FUNCTION pwaf.pub_util_tojson(in_query pwaf.sql_query)
  RETURNS text AS
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
	recordvar record;
	v_tmp_id int;
	v_final_json text;
	v_row_json text[];
	_value text;
	_values text[];
	_name text;
	_attnum int;
	_typcategory text;
	v_loop_count int;
BEGIN
	v_final_json := '';

	SELECT round(random()*100000) INTO v_tmp_id;
	
	EXECUTE 'CREATE TEMP TABLE tmp'||v_tmp_id||' AS '||in_query;

	v_loop_count:=0;
	FOR recordvar IN EXECUTE 'SELECT * FROM tmp'||v_tmp_id LOOP
		
		FOR _name, _attnum, _typcategory IN
			SELECT a.attname, a.attnum, t.typcategory::text FROM pg_catalog.pg_attribute a, pg_catalog.pg_class c, pg_type t WHERE a.attrelid=c.oid AND t.oid=a.atttypid AND a.attname NOT IN ('tableoid','cmax','xmax','cmin','xmin','ctid')  AND c.relname='tmp'||v_tmp_id
		LOOP
			EXECUTE 'SELECT ' || quote_ident(_name) || '::text FROM tmp'||v_tmp_id||' LIMIT 1 OFFSET '||v_loop_count INTO _value USING recordvar;
			IF _typcategory='N' THEN
				_values := array_append(_values, '"'||quote_ident(_name)||'":'||_value||'');
			ELSE
				_values := array_append(_values, '"'||quote_ident(_name)||'":"'||replace(_value,'"','\"')||'"');
			END IF;
			
			
		END LOOP;

		v_row_json := array_append(v_row_json, '{'||array_to_string(_values,',')||'}');

		v_loop_count:=v_loop_count+1;
	END LOOP;

	v_final_json := '{"data":['||array_to_string(v_row_json,',')||']}';

	EXECUTE 'DROP TABLE tmp'||v_tmp_id;

	RETURN v_final_json;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf.pub_util_tojson(pwaf.sql_query)
  OWNER TO pwaf;
