--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf' and tablename='gui_templates'
	) THEN

		CREATE TABLE pwaf.gui_templates
		(
		  id pwaf.g_serial NOT NULL,
		  description text,
		  xslt_stylesheet text,
		  code pwaf.code,
		  CONSTRAINT xslt_stylesheets_pkey PRIMARY KEY (id )
		)
		WITH (
		  OIDS=FALSE
		);

	END IF;
END
$body$
;

ALTER TABLE pwaf.gui_templates OWNER TO pwaf;
--