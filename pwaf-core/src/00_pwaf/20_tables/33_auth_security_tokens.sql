--
DO
$body$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_tables WHERE schemaname='pwaf' and tablename='auth_security_tokens'
  ) THEN

      CREATE UNLOGGED TABLE pwaf.auth_security_tokens
      (
        id serial NOT NULL,
        valid_till timestamp with time zone DEFAULT (now() + '1 day'::interval),
        key text,
        user_id bigint,
        resource_access text,
        CONSTRAINT auth_security_tokens_pkey PRIMARY KEY (id)
      )
      WITH (
        OIDS=FALSE
      );

   END IF;
END
$body$
;   

ALTER TABLE pwaf.auth_security_tokens OWNER TO pwaf;

---

