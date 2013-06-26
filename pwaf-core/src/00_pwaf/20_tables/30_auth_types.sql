--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf' and tablename='auth_types'
	) THEN

		CREATE TABLE pwaf.auth_types
		(
		  id pwaf.g_serial NOT NULL,
		  auth_type text,
		  CONSTRAINT auth_types_pkey PRIMARY KEY (id )
		)
		WITH (
		  OIDS=FALSE
		);

		INSERT INTO pwaf.auth_types (auth_type) VALUES ('local/crypt-bf8');

	END IF;
END
$body$
;

ALTER TABLE pwaf.auth_types OWNER TO pwaf;
--