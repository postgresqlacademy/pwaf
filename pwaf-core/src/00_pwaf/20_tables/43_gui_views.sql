--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf' and tablename='gui_views'
	) THEN

		CREATE TABLE pwaf.gui_views
		(
		  id pwaf.g_serial NOT NULL,
		  template integer,
		  layout integer,
		  code pwaf.html,
		  CONSTRAINT views_pkey PRIMARY KEY (id ),
		  CONSTRAINT views_layout_fkey FOREIGN KEY (layout)
		      REFERENCES pwaf.gui_layouts (id) MATCH SIMPLE
		      ON UPDATE CASCADE ON DELETE CASCADE,
		  CONSTRAINT views_xslt_stylesheet_fkey FOREIGN KEY (template)
		      REFERENCES pwaf.gui_templates (id) MATCH SIMPLE
		      ON UPDATE CASCADE ON DELETE CASCADE
		)
		WITH (
		  OIDS=FALSE
		);

	END IF;
END
$body$
;

ALTER TABLE pwaf.gui_views OWNER TO pwaf;
--