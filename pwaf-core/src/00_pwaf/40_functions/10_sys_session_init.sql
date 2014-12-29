--
CREATE OR REPLACE FUNCTION pwaf.sys_session_init(in_request pwaf.http_request)
  RETURNS int AS
$BODY$
/**
 * @package PWAF
 * @author Karolis Strumskis (karolis@strumskis.com)
 * @copyright (C) 2013 postgresqlacademy.com and other contributors
 * @license Licensed under the MIT License
 * 
 * @version 0.1
 */
DECLARE
	v_session_id int;
	v_remote_addr inet;
	v_cookie text;
BEGIN

	-- @TODO: implement better old session cleaning
	DELETE FROM pwaf.auth_sessions WHERE last_activity_date < (NOW() - INTERVAL '3 days')::date;

	IF ((pwaf.pub_http_request_system_param_get(in_request,'session_id') IS NOT NULL) AND (pwaf.pub_http_request_system_param_get(in_request,'Remote-Addr') IS NOT NULL)) THEN
	
		v_remote_addr := pwaf.pub_http_request_system_param_get(in_request,'Remote-Addr')::inet;
		v_cookie := pwaf.pub_http_request_system_param_get(in_request,'session_id');

		SELECT id FROM pwaf.auth_sessions WHERE ip_address = v_remote_addr AND cookie = v_cookie AND last_activity > ( now() - INTERVAL '1 hour' )::timestamp with time zone ORDER BY id DESC LIMIT 1 INTO v_session_id;

		IF v_session_id IS NULL THEN
			INSERT INTO pwaf.auth_sessions (ip_address, cookie, last_activity, last_activity_date) VALUES (v_remote_addr,v_cookie, now(), now()) RETURNING id INTO v_session_id;
		ELSE
			UPDATE pwaf.auth_sessions SET last_activity=now(), last_activity_date=now() WHERE id=v_session_id;
		END IF;

	END IF;
	
	RETURN v_session_id;
	
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pwaf.sys_session_init(pwaf.http_request) OWNER TO pwaf;
--