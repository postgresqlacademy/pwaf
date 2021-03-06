--
CREATE OR REPLACE FUNCTION pwaf.pub_util_random_string(integer)
  RETURNS text AS
$BODY$
/**
 * @package PWAF
 * @author Karolis Strumskis (karolis@strumskis.com)
 * @copyright (C) 2019 postgresqlacademy.com and other contributors
 * @license Licensed under the MIT License
 * 
 * @version 0.1
 */
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
LANGUAGE sql VOLATILE;
ALTER FUNCTION pwaf.pub_util_random_string(integer) OWNER TO pwaf;
--
