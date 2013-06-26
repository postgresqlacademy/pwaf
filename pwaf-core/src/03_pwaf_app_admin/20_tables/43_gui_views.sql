--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf_app_admin' and tablename='gui_views'
	) THEN

		CREATE TABLE pwaf_app_admin.gui_views
		(
			CONSTRAINT views_pkey PRIMARY KEY (id ),
			CONSTRAINT views_layout_fkey FOREIGN KEY (layout)
			  REFERENCES pwaf_app_admin.gui_layouts (id) MATCH SIMPLE
			  ON UPDATE NO ACTION ON DELETE NO ACTION,
			CONSTRAINT views_xslt_stylesheet_fkey FOREIGN KEY (template)
			  REFERENCES pwaf_app_admin.gui_templates (id) MATCH SIMPLE
			  ON UPDATE NO ACTION ON DELETE NO ACTION
		)
		INHERITS (pwaf.gui_views)
		WITH (
		  OIDS=FALSE
		);

		CREATE INDEX fki_views_layout_fkey
		  ON pwaf_app_admin.gui_views
		  USING btree
		  (layout );

		CREATE INDEX fki_views_xslt_stylesheet_fkey
		  ON pwaf_app_admin.gui_views
		  USING btree
		  (template );

	END IF;
END
$body$
;

ALTER TABLE pwaf_app_admin.gui_views OWNER TO pwaf;
--