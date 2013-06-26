--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf' and tablename='log'
	) THEN

		CREATE TABLE pwaf.log
		(
		  id pwaf.g_serial NOT NULL,
		  log_level pwaf.log_level,
		  app_name text,
		  log_message text,
		  CONSTRAINT log_table_pkey PRIMARY KEY (id )
		)
		WITH (
		  OIDS=FALSE
		);

	END IF;
END
$body$
;

ALTER TABLE pwaf.log OWNER TO pwaf;
--