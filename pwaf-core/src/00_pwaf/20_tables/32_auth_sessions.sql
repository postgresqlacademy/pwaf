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

DROP INDEX pwaf.auth_sessions_ip_address_cookie_idx;

CREATE INDEX auth_sessions_ip_address_cookie_idx
  ON pwaf.auth_sessions
  USING btree
  (ip_address, cookie COLLATE pg_catalog."default");


--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM information_schema.columns WHERE table_catalog=current_database() and table_schema='pwaf' and table_name='auth_sessions' 
		and column_name='last_activity_date'
	) THEN

		ALTER TABLE pwaf.auth_sessions ADD COLUMN last_activity_date date;
		ALTER TABLE pwaf.auth_sessions ALTER COLUMN last_activity_date SET DEFAULT now();

	END IF;
END
$body$
;

DROP INDEX pwaf.auth_sessions_last_activity_date_idx;

CREATE INDEX auth_sessions_last_activity_date_idx
  ON pwaf.auth_sessions
  USING btree
  (last_activity_date);
--