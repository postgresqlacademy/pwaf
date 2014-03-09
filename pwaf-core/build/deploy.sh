#!/bin/bash

export PGHOST=127.0.0.1
export PGPORT=5432
export PGUSER=pwaf_deploy_role
export PGPASSWORD=pwaf_deploy_pass
export PGDATABASE=pwaf_testing

psql -f build.sql