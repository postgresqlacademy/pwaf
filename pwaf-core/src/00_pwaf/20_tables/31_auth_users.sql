--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf' and tablename='auth_users'
	) THEN

		CREATE TABLE pwaf.auth_users
		(
		  id pwaf.g_serial NOT NULL,
		  user_name text NOT NULL,
		  auth_type_id integer NOT NULL,
		  password text,
		  salt text DEFAULT pwaf.gen_salt('bf'::text, 8),
		  CONSTRAINT users_pkey PRIMARY KEY (id ),
		  CONSTRAINT auth_type_fkey FOREIGN KEY (auth_type_id)
		      REFERENCES pwaf.auth_types (id) MATCH SIMPLE
		      ON UPDATE CASCADE ON DELETE CASCADE
		)
		WITH (
		  OIDS=FALSE
		);

	END IF;
END
$body$
;

ALTER TABLE pwaf.auth_users OWNER TO pwaf;
COMMENT ON COLUMN pwaf.auth_users.password IS 'pwaf.crypt(new.password, new.salt)';
--