--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf_app_demobox' and tablename='data_room'
	) THEN

		CREATE TABLE pwaf_app_demobox.data_room
		(
		  id pwaf.g_serial NOT NULL,
		  key text NOT NULL DEFAULT pwaf.pub_util_random_string(24),
		  name text NOT NULL,
		  location text,
		  CONSTRAINT data_room_pkey PRIMARY KEY (id),
		  CONSTRAINT data_room_key UNIQUE (key)
		);

	END IF;
END
$body$
;

ALTER TABLE pwaf_app_demobox.data_room OWNER TO pwaf;
--