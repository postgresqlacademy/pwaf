--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf' and tablename='gui_layouts_blocks'
	) THEN

		CREATE TABLE pwaf.gui_layouts_blocks
		(
		  id pwaf.g_serial NOT NULL,
		  layout integer,
		  block integer,
		  "position" integer,
		  zone integer,
		  CONSTRAINT layout_block_rel_pkey PRIMARY KEY (id ),
		  CONSTRAINT layout_block_rel_block_pkey FOREIGN KEY (block)
		      REFERENCES pwaf.gui_blocks (id) MATCH SIMPLE
		      ON UPDATE NO ACTION ON DELETE NO ACTION,
		  CONSTRAINT layout_block_rel_layout_pkey FOREIGN KEY (layout)
		      REFERENCES pwaf.gui_layouts (id) MATCH SIMPLE
		      ON UPDATE NO ACTION ON DELETE NO ACTION,
		  CONSTRAINT gui_layouts_blocks_zone_check CHECK (zone > 1)
		)
		WITH (
		  OIDS=FALSE
		);

		CREATE INDEX fki_layout_block_rel_block_pkey
		  ON pwaf.gui_layouts_blocks
		  USING btree
		  (block );

		CREATE INDEX fki_layout_block_rel_layout_pkey
		  ON pwaf.gui_layouts_blocks
		  USING btree
		  (layout );

	END IF;
END
$body$
;

ALTER TABLE pwaf.gui_layouts_blocks OWNER TO pwaf;
--