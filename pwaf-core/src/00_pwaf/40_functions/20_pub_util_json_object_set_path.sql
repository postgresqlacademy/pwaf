---
CREATE OR REPLACE FUNCTION pwaf.pub_util_json_object_set_path(
    json json,
    key_path text[],
    value_to_set anyelement)
  RETURNS json AS
$BODY$
SELECT CASE COALESCE(array_length("key_path", 1), 0)
         WHEN 0 THEN to_json("value_to_set")
         WHEN 1 THEN "json_object_set_key"("json", "key_path"[l], "value_to_set")
         ELSE "json_object_set_key"(
           "json",
           "key_path"[l],
           "json_object_set_path"(
             COALESCE(NULLIF(("json" -> "key_path"[l])::text, 'null'), '{}')::json,
             "key_path"[l+1:u],
             "value_to_set"
           )
         )
       END
  FROM array_lower("key_path", 1) l,
       array_upper("key_path", 1) u
$BODY$
  LANGUAGE sql IMMUTABLE STRICT
  COST 100;
ALTER FUNCTION pwaf.pub_util_json_object_set_path(json, text[], anyelement)
  OWNER TO pwaf;

---