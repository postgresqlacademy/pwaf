--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_tables WHERE schemaname='pwaf' and tablename='gui_views_layout_block_override'
	) THEN

		CREATE TABLE pwaf.gui_views_layout_block_override
		(
		  id pwaf.g_serial NOT NULL,
		  view integer,
		  block integer,
		  "position" integer,
		  zone integer,
		  action pwaf.gui_views_layout_block_override_action,
		  CONSTRAINT view_layout_block_override_pkey PRIMARY KEY (id ),
		  CONSTRAINT view_layout_block_override_block_fkey FOREIGN KEY (block)
		      REFERENCES pwaf.gui_blocks (id) MATCH SIMPLE
		      ON UPDATE NO ACTION ON DELETE NO ACTION,
		  CONSTRAINT view_layout_block_override_view_fkey FOREIGN KEY (view)
		      REFERENCES pwaf.gui_views (id) MATCH SIMPLE
		      ON UPDATE NO ACTION ON DELETE NO ACTION,
		  CONSTRAINT gui_views_layout_block_override_zone_check CHECK (zone > 1)
		)
		WITH (
		  OIDS=FALSE
		);

	END IF;
END
$body$
;

ALTER TABLE pwaf.gui_views_layout_block_override OWNER TO pwaf;
--