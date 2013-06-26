--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_views WHERE schemaname='pwaf' and viewname='v_gui_views_layout_block'
	) THEN

		CREATE OR REPLACE VIEW pwaf.v_gui_views_layout_block AS 
        	SELECT 

        		v.id AS view_id, 
        		v.code AS view_code, 
        		l.id AS layout_id, 
        		l.code AS layout_code, 
        		b.id AS block_id, 
        		b.code AS block_code, 
        		b.function AS block_function, 
        		t.code AS block_template, 
                CASE
                    WHEN ( SELECT count(*) = 1
                       FROM pwaf.gui_views_layout_block_override vlbo
                      WHERE vlbo.view = v.id::bigint AND vlbo.block = b.id::bigint AND (vlbo.action = ANY (ARRAY['change_zone'::pwaf.gui_views_layout_block_override_action, 'change_order_and_zone'::pwaf.gui_views_layout_block_override_action]))) THEN ( SELECT vlbo.zone
                       FROM pwaf.gui_views_layout_block_override vlbo
                      WHERE vlbo.view = v.id::bigint AND vlbo.block = b.id::bigint AND (vlbo.action = ANY (ARRAY['change_zone'::pwaf.gui_views_layout_block_override_action, 'change_order_and_zone'::pwaf.gui_views_layout_block_override_action])))
                    ELSE lb.zone
                END AS block_zone, 
                CASE
                    WHEN ( SELECT count(*) = 1
                       FROM pwaf.gui_views_layout_block_override vlbo
                      WHERE vlbo.view = v.id::bigint AND vlbo.block = b.id::bigint AND (vlbo.action = ANY (ARRAY['change_order'::pwaf.gui_views_layout_block_override_action, 'change_order_and_zone'::pwaf.gui_views_layout_block_override_action]))) THEN ( SELECT vlbo."position"
                       FROM pwaf.gui_views_layout_block_override vlbo
                      WHERE vlbo.view = v.id::bigint AND vlbo.block = b.id::bigint AND (vlbo.action = ANY (ARRAY['change_order'::pwaf.gui_views_layout_block_override_action, 'change_order_and_zone'::pwaf.gui_views_layout_block_override_action])))
                    ELSE lb."position"
                END AS block_position, 
                'original'::text AS block_type

           	FROM 

           		pwaf.gui_views v, 
           		pwaf.gui_layouts l, 
           		pwaf.gui_layouts_blocks lb, 
           		pwaf.gui_blocks b, 
           		pwaf.gui_templates t

          	WHERE 
          		v.layout = l.id::bigint 
          		AND 
          		lb.layout = l.id::bigint 
          		AND 
          		lb.block = b.id::bigint 
          		AND 
          		b.template = t.id::bigint 
          		AND 
      			(
      				(
      					SELECT 
      						count(*) = 1 
      					FROM 
      						pwaf.gui_views_layout_block_override vlbo 
      					WHERE 
      						vlbo.view = v.id::bigint 
      						AND 
      						vlbo.block = b.id::bigint 
      						AND 
      						vlbo.action = 'remove'::pwaf.gui_views_layout_block_override_action
      				)

      			) = false

			UNION 

         	SELECT

         		v.id AS view_id, 
         		v.code AS view_code, 
         		l.id AS layout_id,
         		l.code AS layout_code, 
         		b.id AS block_id, 
         		b.code AS block_code, 
         		b.function AS block_function, 
         		t.code AS block_template, 
         		vlbo.zone AS block_zone, 
         		vlbo."position" AS block_position, 
         		'added'::text AS block_type

           	FROM

           		pwaf.gui_views v, 
           		pwaf.gui_layouts l, 
           		pwaf.gui_blocks b, 
           		pwaf.gui_views_layout_block_override vlbo, 
           		pwaf.gui_templates t

          	WHERE 
          	
          		v.layout = l.id::bigint 
          		AND 
          		vlbo.block = b.id::bigint 
          		AND 
          		b.template = t.id::bigint 
          		AND 
          		vlbo.view = v.id::bigint 
          		AND 
          		vlbo.action = 'add'::pwaf.gui_views_layout_block_override_action

          	;

	END IF;
END
$body$
;

ALTER TABLE pwaf.v_gui_views_layout_block OWNER TO pwaf;
--