--
CREATE OR REPLACE FUNCTION pwaf.t__()
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
BEGIN
	
	RETURN;
	
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf.t__() OWNER TO pwaf;
COMMENT ON FUNCTION pwaf.t__() IS 't_ is a namespace for the interal PWAF templating engine';
--