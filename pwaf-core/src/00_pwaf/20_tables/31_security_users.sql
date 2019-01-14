--
DO
$body$
BEGIN
	IF NOT pwaf.build_utils_check_table_exists('pwaf', 'security_users') THEN

		CREATE TABLE pwaf.security_users
		(
		  id pwaf.g_serial NOT NULL,
		  user_name text NOT NULL,
		  auth_type_id integer NOT NULL,
		  password text,
		  salt text DEFAULT pwaf_extensions.gen_salt('bf'::text, 8),
		  CONSTRAINT users_pkey PRIMARY KEY (id ),
		  CONSTRAINT auth_type_fkey FOREIGN KEY (auth_type_id)
		      REFERENCES pwaf.security_auth_types (id) MATCH SIMPLE
		      ON UPDATE CASCADE ON DELETE CASCADE
		);

	END IF;
END
$body$
;

ALTER TABLE pwaf.security_users OWNER TO pwaf;
COMMENT ON COLUMN pwaf.security_users.password IS 'pwaf.crypt(new.password, new.salt)';
--