@echo off

SET PSQL_PATH=C:\Program Files (x86)\pgAdmin III\1.14\psql.exe

SET PGHOST=10.220.0.196
SET PGPORT=5432
SET PGUSER=pwaf_deploy_role
SET PGPASSWORD=pwaf_deploy_pass
SET PGDATABASE=pwaf_testing

"%psql_path%" -f build.sql
