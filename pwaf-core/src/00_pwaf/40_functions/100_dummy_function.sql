--
CREATE OR REPLACE FUNCTION pwaf.dummy_function(integer)
  RETURNS text AS
$BODY$
  -- one variable
  SELECT ''::text;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION pwaf.dummy_function(integer)
  OWNER TO pwaf;

--

CREATE OR REPLACE FUNCTION pwaf.dummy_function(integer,integer)
  RETURNS text AS
$BODY$
  -- two variables
  SELECT ''::text;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION pwaf.dummy_function(integer,integer)
  OWNER TO pwaf;

--
