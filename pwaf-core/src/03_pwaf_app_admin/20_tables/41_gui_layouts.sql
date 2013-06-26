--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf_app_admin' and tablename='gui_layouts'
	) THEN

		CREATE TABLE pwaf_app_admin.gui_layouts
		(
		  CONSTRAINT layouts_pkey PRIMARY KEY (id ),
		  CONSTRAINT layouts_xslt_stylesheet_fkey FOREIGN KEY (template)
		      REFERENCES pwaf_app_admin.gui_templates (id) MATCH SIMPLE
		      ON UPDATE NO ACTION ON DELETE NO ACTION
		)
		INHERITS (pwaf.gui_layouts)
		WITH (
		  OIDS=FALSE
		);

		CREATE INDEX fki_layouts_xslt_stylesheet_fkey
		  ON pwaf_app_admin.gui_layouts
		  USING btree
		  (template );

	END IF;
END
$body$
;

ALTER TABLE pwaf_app_admin.gui_layouts OWNER TO pwaf;
--