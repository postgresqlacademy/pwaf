---
CREATE OR REPLACE FUNCTION pwaf.pub_controller_security_oauth2_auth(in_request pwaf.http_request)
  RETURNS pwaf.http_response AS
$BODY$
/**
 * @package PWAF
 * @author Karolis Strumskis (karolis@strumskis.com)
 * @copyright (C) 2013-2019 postgresqlacademy.com and other contributors
 * @license Licensed under the MIT License
 * 
 * @version 0.1
 */
DECLARE
	
BEGIN

	-- login/crendential validation to make a token
	
	RETURN ('application/json'::pwaf.http_response_content_type,'{"status": "error"}',200,NULL)::pwaf.http_response;

END;$BODY$

LANGUAGE plpgsql VOLATILE;

ALTER FUNCTION pwaf.pub_controller_security_oauth2_auth(pwaf.http_request) OWNER TO pwaf;
---