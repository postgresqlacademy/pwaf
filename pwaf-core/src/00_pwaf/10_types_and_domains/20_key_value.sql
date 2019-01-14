--
DO
$body$
BEGIN
	IF NOT pwaf.build_utils_check_type_exists('pwaf','key_value') THEN

		CREATE TYPE pwaf.key_value AS (
			key text,
		    value text
		);

	END IF;
END
$body$
;
ALTER TYPE pwaf.key_value OWNER TO pwaf;
--
