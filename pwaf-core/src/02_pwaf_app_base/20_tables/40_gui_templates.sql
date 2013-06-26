--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf_app_base' and tablename='gui_templates'
	) THEN

		CREATE TABLE pwaf_app_base.gui_templates
		(
		  	CONSTRAINT xslt_stylesheets_pkey PRIMARY KEY (id)
		)
		INHERITS (pwaf.gui_templates)
		WITH (
		  OIDS=FALSE
		);

	END IF;
END
$body$
;

ALTER TABLE pwaf_app_base.gui_templates OWNER TO pwaf;
--