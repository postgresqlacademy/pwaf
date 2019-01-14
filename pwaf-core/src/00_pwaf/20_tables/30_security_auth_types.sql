--
DO
$body$
BEGIN
	IF NOT pwaf.build_utils_check_table_exists('pwaf', 'security_auth_types') THEN

		CREATE TABLE pwaf.security_auth_types
		(
		  id pwaf.g_serial NOT NULL,
		  auth_type text,
		  CONSTRAINT auth_types_pkey PRIMARY KEY (id )
		)
		WITH (
		  OIDS=FALSE
		);

		INSERT INTO pwaf.security_auth_types (auth_type) VALUES ('local/crypt-bf8');

	END IF;
END
$body$
;

ALTER TABLE pwaf.security_auth_types OWNER TO pwaf;
--