--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf' and tablename='gui_layouts'
	) THEN

		CREATE TABLE pwaf.gui_layouts
		(
		  id pwaf.g_serial NOT NULL,
		  template integer,
		  code pwaf.code,
		  CONSTRAINT layouts_pkey PRIMARY KEY (id ),
		  CONSTRAINT layouts_xslt_stylesheet_fkey FOREIGN KEY (template)
		      REFERENCES pwaf.gui_templates (id) MATCH SIMPLE
		      ON UPDATE CASCADE ON DELETE CASCADE
		)
		WITH (
		  OIDS=FALSE
		);

		CREATE INDEX fki_layouts_xslt_stylesheet_fkey
		  ON pwaf.gui_layouts
		  USING btree
		  (template );

	END IF;
END
$body$
;

ALTER TABLE pwaf.gui_layouts OWNER TO pwaf;
--