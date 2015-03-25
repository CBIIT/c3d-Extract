-- Simple Install Script for SQL Scripts

Spool install_log
select to_char(sysdate,'DD-MON-YYYY HH24:MI:SS') "Install Date",
       user "Install User"
from dual;

Column Text80 format a80 heading ''

-- Ehancement Comment
select 'Enhancement:' Text80,
       'This enhancement is for T312 Column Definitions' Text80
from dual;

-- Table, View and other Objects Here
set verify on echo on


set verify off echo off

-- Packages, Procedures, Functions Here
@ext_misc_pkg.sql

-- Data Changes Here
set verify on echo on
 
Set Verify off Echo off

Spool off
