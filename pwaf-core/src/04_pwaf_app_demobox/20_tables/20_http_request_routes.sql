--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf_app_demobox' and tablename='http_request_routes'
	) THEN

		CREATE TABLE pwaf_app_demobox.http_request_routes
		(
		  CONSTRAINT http_request_routes_pkey PRIMARY KEY (id)
		)
		INHERITS (pwaf.http_request_routes);

		CREATE INDEX http_request_routes_path_idx 
			ON pwaf_app_demobox.http_request_routes
			USING btree
			(path COLLATE pg_catalog."default" );

	END IF;
END
$body$
;

ALTER TABLE pwaf_app_demobox.http_request_routes OWNER TO pwaf;
--