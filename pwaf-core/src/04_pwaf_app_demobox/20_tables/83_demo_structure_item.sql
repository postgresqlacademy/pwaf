--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf_app_demobox' and tablename='data_item'
	) THEN

		CREATE TABLE pwaf_app_demobox.data_item
		(
		  id pwaf.g_serial NOT NULL,
		  name text NOT NULL,
		  box_id integer NOT NULL,
		  type_id integer NOT NULL,
		  CONSTRAINT data_item_pkey PRIMARY KEY (id),
		  CONSTRAINT box_fkey FOREIGN KEY (box_id)
		      REFERENCES pwaf_app_demobox.data_box (id) MATCH SIMPLE
		      ON UPDATE CASCADE ON DELETE CASCADE,
		  CONSTRAINT type_fkey FOREIGN KEY (type_id)
		      REFERENCES pwaf_app_demobox.data_item_type (id) MATCH SIMPLE
		      ON UPDATE CASCADE ON DELETE CASCADE
		);

	END IF;
END
$body$
;

ALTER TABLE pwaf_app_demobox.data_item OWNER TO pwaf;
--