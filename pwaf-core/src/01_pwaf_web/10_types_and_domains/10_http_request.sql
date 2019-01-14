--
DO
$body$
BEGIN
    IF NOT pwaf.build_utils_check_type_exists('pwaf_web','http_request') THEN
    	
		CREATE TYPE pwaf_web.http_request AS
		   (method pwaf.http_request_method,
		    path text[],
		    param_names text[],
		    param_values text[],
		    system_param_names text[],
		    system_param_values text[]);

   	END IF;
END
$body$
;

ALTER TYPE pwaf_web.http_request OWNER TO pwaf;
--