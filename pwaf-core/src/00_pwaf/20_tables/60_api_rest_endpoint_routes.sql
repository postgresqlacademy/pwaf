--
DO
$body$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_tables WHERE schemaname='pwaf' and tablename='api_rest_endpoint_routes'
  ) THEN

    CREATE TABLE pwaf.api_rest_endpoint_routes
    (
      rest_resource_name text,
      supported_methods pwaf.http_request_method[],
      default_data_endpoint text,
      custom_actions text[],
      object_access_validator text,
      access_validator_property text,
      access_validator_value_query text,
      custom_ordering text,
      CONSTRAINT rest_api_endpoints_pkey PRIMARY KEY (id)
    )
    INHERITS (pwaf.http_request_routes)
    WITH (
      OIDS=FALSE
    );


    END IF;
END
$body$
;

ALTER TABLE pwaf.api_rest_endpoint_routes OWNER TO pwaf;
