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
ALTER TABLE pwaf.http_request_routes ADD COLUMN method pwaf.http_request_method;
ALTER TABLE pwaf.http_request_routes OWNER TO pwaf;
--