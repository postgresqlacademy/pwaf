--
DO
$body$
BEGIN
	IF NOT pwaf.build_utils_check_table_exists('pwaf', 'assets') THEN

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