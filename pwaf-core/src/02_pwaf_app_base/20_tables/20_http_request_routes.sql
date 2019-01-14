--
DO
$body$
BEGIN
	IF NOT pwaf.build_utils_check_table_exists('pwaf_app_base', 'http_request_routes') THEN

		CREATE TABLE pwaf_app_base.http_request_routes
		(
		  CONSTRAINT http_request_routes_pkey PRIMARY KEY (id)
		)
		INHERITS (pwaf.http_request_routes);

		CREATE INDEX http_request_routes_path_idx 
			ON pwaf_app_base.http_request_routes
			USING btree
			(path COLLATE pg_catalog."default" );

	END IF;
END
$body$
;

ALTER TABLE pwaf_app_base.http_request_routes OWNER TO pwaf;
--