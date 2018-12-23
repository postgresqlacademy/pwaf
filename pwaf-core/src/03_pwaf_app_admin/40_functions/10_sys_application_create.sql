---
CREATE OR REPLACE FUNCTION pwaf_app_admin.sys_application_create(in_name text)
  RETURNS void AS
$BODY$
/**
 * @package PWAF
 * @author Karolis Strumskis (karolis@strumskis.com)
 * @copyright (C) 2014 postgresqlacademy.com and other contributors
 * @license Licensed under the MIT License
 * 
 * @version 0.1
 */
DECLARE
	v_id bigint;
	v_salt text;
BEGIN
	
	EXECUTE 'CREATE SCHEMA '||in_name||' AUTHORIZATION pwaf';

	EXECUTE '
	CREATE TABLE '||in_name||'.http_request_routes
	(
	  CONSTRAINT http_request_routes_pkey PRIMARY KEY (id)
	)
	INHERITS (pwaf.http_request_routes)
	WITH (
	  OIDS=FALSE
	);
	';
	EXECUTE 'ALTER TABLE '||in_name||'.http_request_routes OWNER TO pwaf';
	EXECUTE '
	CREATE INDEX http_request_routes_path_idx
	  ON '||in_name||'.http_request_routes
	  USING btree
	  (path COLLATE pg_catalog."default");

	';

	-----

	EXECUTE 'CREATE TABLE '||in_name||'.assets
	(
	  CONSTRAINT assets_pkey PRIMARY KEY (id)
	)
	INHERITS (pwaf.assets)
	WITH (
	  OIDS=FALSE
	)';
	EXECUTE 'ALTER TABLE '||in_name||'.assets OWNER TO pwaf';

	-----

	EXECUTE 'CREATE TABLE '||in_name||'.gui_templates
	(
	  CONSTRAINT xslt_stylesheets_pkey PRIMARY KEY (id)
	)
	INHERITS (pwaf.gui_templates)
	WITH (
	  OIDS=FALSE
	)';
	EXECUTE 'ALTER TABLE '||in_name||'.gui_templates OWNER TO pwaf;';

	-----

	EXECUTE 'CREATE TABLE '||in_name||'.gui_blocks
	(
	  CONSTRAINT blocks_pkey PRIMARY KEY (id),
	  CONSTRAINT blocks_xslt_stilesheet_fkey FOREIGN KEY (template)
	      REFERENCES '||in_name||'.gui_templates (id) MATCH SIMPLE
	      ON UPDATE NO ACTION ON DELETE NO ACTION
	)
	INHERITS (pwaf.gui_blocks)
	WITH (
	  OIDS=FALSE
	)';
	EXECUTE 'ALTER TABLE '||in_name||'.gui_blocks OWNER TO pwaf';
	EXECUTE 'CREATE INDEX fki_blocks_xslt_stilesheet_fkey ON '||in_name||'.gui_blocks USING btree (template)';

	-----

	EXECUTE 'CREATE TABLE '||in_name||'.gui_layouts
	(
	  CONSTRAINT layouts_pkey PRIMARY KEY (id),
	  CONSTRAINT layouts_xslt_stylesheet_fkey FOREIGN KEY (template)
	      REFERENCES '||in_name||'.gui_templates (id) MATCH SIMPLE
	      ON UPDATE NO ACTION ON DELETE NO ACTION
	)
	INHERITS (pwaf.gui_layouts)
	WITH (
	  OIDS=FALSE
	)';
	EXECUTE 'ALTER TABLE '||in_name||'.gui_layouts OWNER TO pwaf;';
	EXECUTE 'CREATE INDEX fki_layouts_xslt_stylesheet_fkey ON '||in_name||'.gui_layouts USING btree (template)';

	-----
	
	EXECUTE 'CREATE TABLE '||in_name||'.gui_layouts_blocks
	(
	  CONSTRAINT layout_block_rel_pkey PRIMARY KEY (id),
	  CONSTRAINT layout_block_rel_block_pkey FOREIGN KEY (block)
	      REFERENCES '||in_name||'.gui_blocks (id) MATCH SIMPLE
	      ON UPDATE NO ACTION ON DELETE NO ACTION,
	  CONSTRAINT layout_block_rel_layout_pkey FOREIGN KEY (layout)
	      REFERENCES '||in_name||'.gui_layouts (id) MATCH SIMPLE
	      ON UPDATE NO ACTION ON DELETE NO ACTION,
	  CONSTRAINT gui_layouts_blocks_zone_check CHECK (zone > 1)
	)
	INHERITS (pwaf.gui_layouts_blocks)
	WITH (
	  OIDS=FALSE
	)';
	EXECUTE 'ALTER TABLE '||in_name||'.gui_layouts_blocks OWNER TO pwaf';
	EXECUTE 'CREATE INDEX fki_layout_block_rel_block_pkey ON '||in_name||'.gui_layouts_blocks USING btree (block)';
	EXECUTE 'CREATE INDEX fki_layout_block_rel_layout_pkey ON '||in_name||'.gui_layouts_blocks USING btree (layout)';

	-----
	
	EXECUTE 'CREATE TABLE '||in_name||'.gui_views
	(
	  CONSTRAINT views_pkey PRIMARY KEY (id),
	  CONSTRAINT views_layout_fkey FOREIGN KEY (layout)
	      REFERENCES '||in_name||'.gui_layouts (id) MATCH SIMPLE
	      ON UPDATE NO ACTION ON DELETE NO ACTION,
	  CONSTRAINT views_xslt_stylesheet_fkey FOREIGN KEY (template)
	      REFERENCES '||in_name||'.gui_templates (id) MATCH SIMPLE
	      ON UPDATE NO ACTION ON DELETE NO ACTION
	)
	INHERITS (pwaf.gui_views)
	WITH (
	  OIDS=FALSE
	)';
	EXECUTE 'ALTER TABLE '||in_name||'.gui_views OWNER TO pwaf';
	EXECUTE 'CREATE INDEX fki_views_layout_fkey ON '||in_name||'.gui_views USING btree (layout)';
	EXECUTE 'CREATE INDEX fki_views_xslt_stylesheet_fkey ON '||in_name||'.gui_views USING btree (template)';

	-----
	
	EXECUTE 'CREATE TABLE '||in_name||'.gui_views_layout_block_override
	(
	  CONSTRAINT view_layout_block_override_pkey PRIMARY KEY (id),
	  CONSTRAINT view_layout_block_override_block_fkey FOREIGN KEY (block)
	      REFERENCES '||in_name||'.gui_blocks (id) MATCH SIMPLE
	      ON UPDATE NO ACTION ON DELETE NO ACTION,
	  CONSTRAINT view_layout_block_override_view_fkey FOREIGN KEY (view)
	      REFERENCES '||in_name||'.gui_views (id) MATCH SIMPLE
	      ON UPDATE NO ACTION ON DELETE NO ACTION,
	  CONSTRAINT gui_views_layout_block_override_zone_check CHECK (zone > 1)
	)
	INHERITS (pwaf.gui_views_layout_block_override)
	WITH (
	  OIDS=FALSE
	)';
	EXECUTE 'ALTER TABLE '||in_name||'.gui_views_layout_block_override OWNER TO pwaf;';
	EXECUTE 'CREATE INDEX fki_view_layout_block_override_block_fkey ON '||in_name||'.gui_views_layout_block_override USING btree (block)';
	EXECUTE 'CREATE INDEX fki_view_layout_block_override_view_fkey ON '||in_name||'.gui_views_layout_block_override USING btree (view)';
	
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf_app_admin.sys_application_create(in_name text)
  OWNER TO pwaf;
---