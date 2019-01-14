--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf_app_dba' and tablename='gui_views_layout_block_override'
	) THEN

		CREATE TABLE pwaf_app_dba.gui_views_layout_block_override
		(
			CONSTRAINT view_layout_block_override_pkey PRIMARY KEY (id ),
			CONSTRAINT view_layout_block_override_block_fkey FOREIGN KEY (block)
			  REFERENCES pwaf_app_dba.gui_blocks (id) MATCH SIMPLE
			  ON UPDATE NO ACTION ON DELETE NO ACTION,
			CONSTRAINT view_layout_block_override_view_fkey FOREIGN KEY (view)
			  REFERENCES pwaf_app_dba.gui_views (id) MATCH SIMPLE
			  ON UPDATE NO ACTION ON DELETE NO ACTION,
			CONSTRAINT gui_views_layout_block_override_zone_check CHECK (zone > 1)
		)
		INHERITS (pwaf.gui_views_layout_block_override)
		WITH (
		  OIDS=FALSE
		);

		CREATE INDEX fki_view_layout_block_override_block_fkey
		  ON pwaf_app_dba.gui_views_layout_block_override
		  USING btree
		  (block );

		CREATE INDEX fki_view_layout_block_override_view_fkey
		  ON pwaf_app_dba.gui_views_layout_block_override
		  USING btree
		  (view );

	END IF;
END
$body$
;

ALTER TABLE pwaf_app_dba.gui_views_layout_block_override OWNER TO pwaf;
--