--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf_app_dba' and tablename='gui_templates'
	) THEN

		CREATE TABLE pwaf_app_dba.gui_templates
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

ALTER TABLE pwaf_app_dba.gui_templates OWNER TO pwaf;
--