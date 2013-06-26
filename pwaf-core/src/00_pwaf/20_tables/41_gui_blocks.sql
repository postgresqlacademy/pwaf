--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf' and tablename='gui_blocks'
	) THEN

		CREATE TABLE pwaf.gui_blocks
		(
		  id pwaf.g_serial NOT NULL,
		  template integer,
		  code pwaf.code,
		  function text,
		  CONSTRAINT blocks_pkey PRIMARY KEY (id ),
		  CONSTRAINT blocks_xslt_stilesheet_fkey FOREIGN KEY (template)
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

ALTER TABLE pwaf.gui_blocks OWNER TO pwaf;
--