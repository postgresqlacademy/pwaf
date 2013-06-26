--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf_app_admin' and tablename='gui_layouts_blocks'
	) THEN

		CREATE TABLE pwaf_app_admin.gui_layouts_blocks
		(
		  CONSTRAINT layout_block_rel_pkey PRIMARY KEY (id ),
		  CONSTRAINT layout_block_rel_block_pkey FOREIGN KEY (block)
		      REFERENCES pwaf_app_admin.gui_blocks (id) MATCH SIMPLE
		      ON UPDATE NO ACTION ON DELETE NO ACTION,
		  CONSTRAINT layout_block_rel_layout_pkey FOREIGN KEY (layout)
		      REFERENCES pwaf_app_admin.gui_layouts (id) MATCH SIMPLE
		      ON UPDATE NO ACTION ON DELETE NO ACTION,
		  CONSTRAINT gui_layouts_blocks_zone_check CHECK (zone > 1)
		)
		INHERITS (pwaf.gui_layouts_blocks)
		WITH (
		  OIDS=FALSE
		);

		CREATE INDEX fki_layout_block_rel_block_pkey
		  ON pwaf_app_admin.gui_layouts_blocks
		  USING btree
		  (block );

		CREATE INDEX fki_layout_block_rel_layout_pkey
		  ON pwaf_app_admin.gui_layouts_blocks
		  USING btree
		  (layout );

	END IF;
END
$body$
;

ALTER TABLE pwaf_app_admin.gui_layouts_blocks OWNER TO pwaf;
--