--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf_app_demobox' and tablename='data_box'
	) THEN

		CREATE TABLE pwaf_app_demobox.data_box
		(
		  id pwaf.g_serial NOT NULL,
		  key text NOT NULL DEFAULT pwaf.pub_util_random_string(24),
		  name text NOT NULL,
		  room integer NOT NULL,
		  CONSTRAINT data_box_pkey PRIMARY KEY (id),
		  CONSTRAINT data_box_key UNIQUE (key),
		  CONSTRAINT room_fkey FOREIGN KEY (room)
		      REFERENCES pwaf_app_demobox.data_room (id) MATCH SIMPLE
		      ON UPDATE CASCADE ON DELETE CASCADE
		);

	END IF;
END
$body$
;

ALTER TABLE pwaf_app_demobox.data_box OWNER TO pwaf;
--