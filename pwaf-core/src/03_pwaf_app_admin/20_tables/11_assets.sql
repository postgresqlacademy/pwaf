--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf_app_admin' and tablename='assets'
	) THEN

		CREATE TABLE pwaf_app_admin.assets
		(
		  CONSTRAINT assets_pkey PRIMARY KEY (id)
		)
		INHERITS (pwaf.assets)
		WITH (
		  OIDS=FALSE
		);

	END IF;
END
$body$
;

ALTER TABLE pwaf_app_admin.assets OWNER TO pwaf;
--