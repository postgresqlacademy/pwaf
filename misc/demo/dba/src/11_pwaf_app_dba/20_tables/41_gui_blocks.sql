--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf_app_dba' and tablename='gui_blocks'
	) THEN

		CREATE TABLE pwaf_app_dba.gui_blocks
		(
		  	CONSTRAINT blocks_pkey PRIMARY KEY (id),
		  	CONSTRAINT blocks_xslt_stilesheet_fkey FOREIGN KEY (template)
      			REFERENCES pwaf_app_dba.gui_templates (id) MATCH SIMPLE
      			ON UPDATE NO ACTION ON DELETE NO ACTION
		)
		INHERITS (pwaf.gui_blocks)
		WITH (
		  OIDS=FALSE
		);

		CREATE INDEX fki_blocks_xslt_stilesheet_fkey
		  ON pwaf_app_dba.gui_blocks
		  USING btree
		  (template );


	END IF;
END
$body$
;

ALTER TABLE pwaf_app_dba.gui_blocks OWNER TO pwaf;
--