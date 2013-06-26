--
DO
$body$
BEGIN
	IF NOT EXISTS (
    	SELECT 1 FROM pg_type JOIN pg_namespace ON typnamespace=pg_namespace.oid WHERE nspname='pwaf' AND typname='gui_views_layout_block_override_action'
    ) THEN
    	
		CREATE TYPE pwaf.gui_views_layout_block_override_action AS ENUM
		   ('add',
		    'remove',
		    'change_order',
		    'change_zone',
		    'change_order_and_zone');
		
   	END IF;
END
$body$
;

ALTER DOMAIN pwaf.gui_views_layout_block_override_action OWNER TO pwaf;
--