--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf_app_demobox' and tablename='api_rest_endpoint_routes'
	) THEN

		CREATE TABLE pwaf_app_demobox.api_rest_endpoint_routes
		(
		  CONSTRAINT api_rest_endpoint_routes_pkey PRIMARY KEY (id)
		)
		INHERITS (pwaf.api_rest_endpoint_routes);

		CREATE INDEX api_rest_endpoint_routes_idx 
			ON pwaf_app_demobox.api_rest_endpoint_routes
			USING btree
			(path COLLATE pg_catalog."default" );

	END IF;
END
$body$
;

ALTER TABLE pwaf_app_demobox.api_rest_endpoint_routes OWNER TO pwaf;
--