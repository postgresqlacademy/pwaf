--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf' and tablename='auth_sessions'
	) THEN

		CREATE TABLE pwaf.auth_sessions
		(
		  id pwaf.g_serial NOT NULL,
		  user_id integer,
		  ip_address inet,
		  cookie text,
		  last_activity timestamp with time zone DEFAULT now(),
		  CONSTRAINT sessions_pkey PRIMARY KEY (id ),
		  CONSTRAINT user_fkey FOREIGN KEY (user_id)
		      REFERENCES pwaf.auth_users (id) MATCH SIMPLE
		      ON UPDATE CASCADE ON DELETE CASCADE
		)
		WITH (
		  OIDS=FALSE
		);

	END IF;
END
$body$
;

ALTER TABLE pwaf.auth_sessions OWNER TO pwaf;
--