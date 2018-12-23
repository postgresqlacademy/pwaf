--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf_app_demobox' and tablename='data_item_type'
	) THEN

		CREATE TABLE pwaf_app_demobox.data_item_type
		(
		  id pwaf.g_serial NOT NULL,
		  name text NOT NULL,
		  CONSTRAINT data_item_type_pkey PRIMARY KEY (id)
		);

	END IF;
END
$body$
;

ALTER TABLE pwaf_app_demobox.data_item_type OWNER TO pwaf;
--