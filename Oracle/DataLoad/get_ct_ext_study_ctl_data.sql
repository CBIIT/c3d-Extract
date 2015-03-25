column text75 format a75 head ##
set lines 145 pages 0 head off termout on long 10000 feed off

Spool ct_ext_study_ctl_CCR_CTMS_312.sql

select 'REM This code was generated from the script get_ct_ext_study_ctl_data.sql.' text75,
       ' ' text75
  from dual;

select
'Declare '                                                text75,
' '                                                       text75,
'  xOC_STUDY             VARCHAR2(30);'                   text75,
'  xOC_OBJECT_OWNER      VARCHAR2(30);'                   text75,
'  xEXT_OBJECT_OWNER     VARCHAR2(30);'                   text75,
'  xEXT_OBJECT_OWNER_TS  VARCHAR2(30);'                   text75,
'  xCREATE_BY            VARCHAR2(30);'                   text75,
'  xCREATION_DATE        DATE;'                           text75,
'  '                                                      text75,
'Begin '                                                  text75,
'  xOC_STUDY           := '''||OC_STUDY||''';'            text75,
'  xOC_OBJECT_OWNER    := '''||OC_OBJECT_OWNER    ||''';' text75,
'  xEXT_OBJECT_OWNER   := '''||EXT_OBJECT_OWNER   ||''';' text75,
'  xEXT_OBJECT_OWNER_TS:= '''||EXT_OBJECT_OWNER_TS||''';' text75,
'  xCREATE_BY          := USER;'                          text75,
'  xCREATION_DATE      := SYSDATE;'                       text75,
'   '                                                     text75,
'INSERT INTO CT_EXT_STUDY_CTL$PRC ('                      text75,
'  OC_STUDY,  OC_OBJECT_OWNER, EXT_OBJECT_OWNER, '        text75,
'  CREATE_BY, CREATION_DATE,   EXT_OBJECT_OWNER_TS)'      text75,
'  Values ('                                              text75,
'  xOC_STUDY,  xOC_OBJECT_OWNER, xEXT_OBJECT_OWNER,'      text75,
'  xCREATE_BY, xCREATION_DATE,   xEXT_OBJECT_OWNER_TS);'  text75,
' '                                                       text75,
'  commit;'                                               text75,
'  '                                                      text75,
'End; '                                                   text75,
'/'                                                       text75
from CT_EXT_STUDY_CTL
where oc_study = 'CCR_CTMS_312'
 order by OC_OBJECT_OWNER;

spool off