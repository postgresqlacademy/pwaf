--
CREATE OR REPLACE FUNCTION pwaf.pub_util_http_response_standard(in_html text)
  RETURNS pwaf.http_response AS
$BODY$
/**
 * @package PWAF
 * @author Karolis Strumskis (karolis@strumskis.com)
 * @copyright (C) 2019 postgresqlacademy.com and other contributors
 * @license Licensed under the MIT License
 * 
 * @version 0.1
 */
DECLARE

BEGIN

	RETURN (
		'text/html;charset=utf-8'::pwaf.http_response_content_type,
		in_html,
		200,
		NULL
	)::pwaf.http_response;

END;$BODY$

LANGUAGE plpgsql VOLATILE;

ALTER FUNCTION pwaf.pub_util_http_response_standard(in_html text) OWNER TO pwaf;