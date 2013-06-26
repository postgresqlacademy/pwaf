--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf' and tablename='assets'
	) THEN

		CREATE TABLE pwaf.assets
		(
		  id pwaf.g_serial NOT NULL,
		  content_type pwaf.http_response_content_type,
		  data text,
		  name text,
		  CONSTRAINT assets_pkey PRIMARY KEY (id )
		)
		WITH (
		  OIDS=FALSE
		);

	END IF;
END
$body$
;

ALTER TABLE pwaf.assets OWNER TO pwaf;
--