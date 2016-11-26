--
CREATE OR REPLACE FUNCTION pwaf.random_string(integer)
  RETURNS text AS
$BODY$
SELECT array_to_string(
    ARRAY (
        SELECT substring(
            '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
            FROM (ceil(random()*62))::int FOR 1
        )
        FROM generate_series(1, $1)
    ), 
    ''
)
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION pwaf.random_string(integer)
  OWNER TO pwaf;

--
