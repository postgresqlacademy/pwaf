--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf' and tablename='http_request_routes'
	) THEN

		CREATE TABLE pwaf.http_request_routes
		(
		  id pwaf.g_serial NOT NULL,
		  path text,
		  controller text,
		  require_valid_user boolean DEFAULT false,
		  CONSTRAINT http_request_routes_pkey PRIMARY KEY (id )
		)
		WITH (
		  OIDS=FALSE
		);

		CREATE INDEX http_request_routes_path_idx 
			ON pwaf.http_request_routes
			USING btree
			(path COLLATE pg_catalog."default" );

	END IF;
END
$body$
;

DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM information_schema.columns WHERE table_catalog=current_database() and table_schema='pwaf' and table_name='http_request_routes'
	) THEN

		ALTER TABLE pwaf.http_request_routes ADD COLUMN method pwaf.http_request_method;

	END IF;
END
$body$
;

ALTER TABLE pwaf.http_request_routes OWNER TO pwaf;
--