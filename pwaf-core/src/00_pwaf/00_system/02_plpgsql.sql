--
CREATE EXTENSION IF NOT EXISTS plpgsql;

CREATE OR REPLACE TRUSTED PROCEDURAL LANGUAGE 'plpgsql'
    HANDLER plpgsql_call_handler
    VALIDATOR plpgsql_validator;
--