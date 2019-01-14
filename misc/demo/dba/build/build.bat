@echo off

echo --pwaf build > build.sql

FOR /R ..\src\ %%f IN (*) DO (
    copy /b build.sql+%%f build.sql
)
