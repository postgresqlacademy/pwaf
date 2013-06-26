--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_views WHERE schemaname='pwaf' and viewname='v_gui_views'
	) THEN

		CREATE OR REPLACE VIEW pwaf.v_gui_views AS 
 			SELECT v.id, v.code, v.template, t.code AS template_code, v.layout, l.code AS layout_code, t2.code AS layout_template_code
   			FROM pwaf.gui_views v, pwaf.gui_templates t, pwaf.gui_layouts l, pwaf.gui_templates t2
  			WHERE v.template = t.id::bigint AND v.layout = l.id::bigint AND t2.id::bigint = l.template;

	END IF;
END
$body$
;

ALTER TABLE pwaf.v_gui_views OWNER TO pwaf;
--