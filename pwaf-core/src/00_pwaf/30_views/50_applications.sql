--
DO
$body$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_views WHERE schemaname='pwaf' and viewname='v_applications'
	) THEN

		CREATE OR REPLACE VIEW pwaf.v_applications AS 
 			SELECT DISTINCT n.nspname as name,
			(SELECT r2.path FROM pwaf.http_request_routes r2, pg_class c2, pg_namespace n2 WHERE r2.tableoid = c2.oid AND c2.relnamespace=n2.oid AND n.nspname=n2.nspname ORDER BY r2.id ASC LIMIT 1) default_path
 			FROM pwaf.http_request_routes r, pg_class c, pg_namespace n WHERE r.tableoid = c.oid AND c.relnamespace=n.oid AND n.nspname NOT IN ('pwaf') ORDER BY n.nspname ASC;

	END IF;
END
$body$
;

ALTER TABLE pwaf.v_applications OWNER TO pwaf;
--