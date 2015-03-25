column text75 format a75 head ##
set lines 145 pages 0 head off termout on long 10000 feed off

Spool ct_ext_oc_obj_ctl_CCR_CTMS_312.sql

select 'REM This code was generated from the script get_ct_ext_oc_obj_ctl_data.sql.' text75,
       ' ' text75
  from dual;

select
'Declare '                                         text75,
' '                                                text75,
'  xOC_STUDY           VARCHAR2(30);'              text75,
'  xSYNONYM_NAME       VARCHAR2(30);'              text75,
'  xOBJECT_NAME        VARCHAR2(30);'              text75,
'  xOBJECT_OWNER       VARCHAR2(30);'              text75,
'  xCRT_SEQ            NUMBER;'                    text75,
'  xCREATE_BY          VARCHAR2(30);'              text75,
'  xCREATION_DATE      DATE;'                      text75,
'  '                                               text75,
'Begin '                                           text75,
'  xOC_STUDY           := '''||OC_STUDY||''';'     text75,
'  xSYNONYM_NAME       := '''||SYNONYM_NAME||''';' text75,
'  xOBJECT_NAME        := '''||OBJECT_NAME||''';'  text75,
'  xOBJECT_OWNER       := '''||OBJECT_OWNER||''';' text75,
'  xCRT_SEQ            := '||CRT_SEQ||';'          text75,
'  xCREATE_BY          := USER;'                   text75,
'  xCREATION_DATE      := SYSDATE;'                text75,
'   '                                              text75,
'INSERT INTO CT_EXT_OC_OBJ_CTL$PRC ('              text75,
'   OC_STUDY,     SYNONYM_NAME, OBJECT_NAME, '     text75,
'   OBJECT_OWNER, CRT_SEQ,      CREATE_BY, '       text75,
'   CREATION_DATE)  '                              text75,
'  Values ('                                       text75,
'   xOC_STUDY,     xSYNONYM_NAME, xOBJECT_NAME, '  text75,
'   xOBJECT_OWNER, xCRT_SEQ,      xCREATE_BY, '    text75,
'   xCREATION_DATE);'                              text75,
' '                                                text75,
'  commit;'                                        text75,
'  '                                               text75,
'End; '                                            text75,
'/'                                                text75
from CT_EXT_OC_OBJ_CTL
where oc_study = 'CCR_CTMS_312'
 order by SYNONYM_NAME;

spool off