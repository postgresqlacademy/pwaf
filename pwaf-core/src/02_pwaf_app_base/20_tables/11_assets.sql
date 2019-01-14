--
DO
$body$
BEGIN
	IF NOT pwaf.build_utils_check_table_exists('pwaf_app_base', 'assets') THEN

		CREATE TABLE pwaf_app_base.assets
		(
		  CONSTRAINT assets_pkey PRIMARY KEY (id)
		)
		INHERITS (pwaf.assets);

	END IF;
END
$body$
;

ALTER TABLE pwaf_app_base.assets OWNER TO pwaf;
--