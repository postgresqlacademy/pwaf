--
DO
$body$
BEGIN
	IF NOT pwaf.build_utils_check_table_exists('pwaf', 'security_sessions') THEN

		CREATE UNLOGGED TABLE pwaf.security_sessions
		(
		  id pwaf.g_serial NOT NULL,
		  user_id integer,
		  ip_address inet,
		  cookie text,
		  last_activity timestamp with time zone DEFAULT now(),
		  CONSTRAINT security_sessions_pkey PRIMARY KEY (id ),
		  CONSTRAINT user_fkey FOREIGN KEY (user_id)
		      REFERENCES pwaf.security_users (id) MATCH SIMPLE
		      ON UPDATE CASCADE ON DELETE CASCADE
		);

		CREATE INDEX security_sessions_ip_address_cookie_idx
		  ON pwaf.security_sessions
		  USING btree
		  (ip_address, cookie COLLATE pg_catalog."default");

	END IF;
END
$body$
;

ALTER TABLE pwaf.security_sessions OWNER TO pwaf;

--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM information_schema.columns WHERE table_catalog=current_database() and table_schema='pwaf' and table_name='security_sessions' 
		and column_name='last_activity_date'
	) THEN

		ALTER TABLE pwaf.security_sessions ADD COLUMN last_activity_date date;
		ALTER TABLE pwaf.security_sessions ALTER COLUMN last_activity_date SET DEFAULT now();

		CREATE INDEX security_sessions_last_activity_date_idx
		  ON pwaf.security_sessions
		  USING btree
		  (last_activity_date);

	END IF;
END
$body$
;


--