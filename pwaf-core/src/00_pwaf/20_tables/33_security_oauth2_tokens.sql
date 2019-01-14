--
DO
$body$
BEGIN
  IF NOT pwaf.build_utils_check_table_exists('pwaf', 'security_oauth2_tokens') THEN

      CREATE UNLOGGED TABLE pwaf.security_oauth2_tokens
      (
        id serial NOT NULL,
        valid_till timestamp with time zone DEFAULT (now() + '1 day'::interval),
        key text,
        user_id bigint,
        resource_access text,
        CONSTRAINT auth_security_tokens_pkey PRIMARY KEY (id)
      );

   END IF;
END
$body$
;   

ALTER TABLE pwaf.security_oauth2_tokens OWNER TO pwaf;

---

