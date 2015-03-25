column text75 format a75 head ##
column text   format a145 word
set lines 145 pages 0 head off termout on long 10000

Spool ct_ext_vw_ctl_CCR_CTMS_312.sql

select 'REM This code was generated from the script get_ct_ext_vw_ctl_data.sql.' text75,
       'REM Before the script can successfully executed, the output (this file) ' text75,
       'REM must be editted.  Substitute all single quotes '' for a pair of ' text75,
       'REM single qotes '''', then substitue all pound signs # with ' text75,
       'REM a single quote ''.'                                        text75,
       'REM ALSO NOTE:'                                                text75,
       'REM Some "TEXT" values may need editted to replace extraneous Hard-Returns' text75,
       'REM that will cause the view code to be interpretted incorrectly during    ' text75,
       'REM Data Extract execution.' text75,
       ' '                           text75
  from dual;


select
'Declare '                          text75,
' '                                 text75,
'  xOC_STUDY       varchar2(30);'   text75,
'  xVIEW_NAME      varchar2(30);'   text75,
'  xCRT_SEQ        NUMBER;'         text75,
'  xTEXT           LONG;'           text75,
'  xSYNONYM_NAME   varchar2(30);'   text75,
'  xCREATE_BY      varchar2(30);'   text75,
'  xCREATION_DATE  DATE;'           text75,
'  xNOTE           varchar2(2000);' text75,
'  xMODIFIED_BY    varchar2(30);'   text75,
'  xMODIFIED_DATE  DATE;'           text75,
'  '                                text75,
'Begin '                            text75,
'  xOC_STUDY       := #'||oc_study||'#;'    text75,
'  xVIEW_NAME      := #'||VIEW_NAME||'#;'   text75,
'  xCRT_SEQ        := '||CRT_SEQ||';'       text75,
'  xTEXT           := #'                    text75,
TEXT,
'#;'        text75,
'  xSYNONYM_NAME   := #'||SYNONYM_NAME||'#;'  text75,
'  xCREATE_BY      := USER;'                  text75,
'  xCREATION_DATE  := SYSDATE;'               text75,
'  xNOTE           := #'||NOTE||'#;',
'  xMODIFIED_BY    := NULL;'                  text75,
'  xMODIFIED_DATE  := NULL;'                  text75,
'   '                                         text75,
'  Insert into CT_EXT_VW_CTL$PRC '                 text75,
'        (OC_STUDY, VIEW_NAME, CRT_SEQ, '          text75,
'         TEXT, SYNONYM_NAME, '                    text75,
'         CREATE_BY, CREATION_DATE, '              text75,
'         NOTE, MODIFIED_BY, MODIFIED_DATE)'       text75,
'  Values '                                        text75,
'        (xOC_STUDY,     xVIEW_NAME,   xCRT_SEQ,    xTEXT, ' text75,
'         xSYNONYM_NAME, xCREATE_BY,   xCREATION_DATE, '     text75,
'         xNOTE,         xMODIFIED_BY, xMODIFIED_DATE);'      text75,
' '                                                           text75,
'  commit;'    text75,
'  '           text75,
'End; '        text75,
'/'        text75
from CT_EXT_VW_CTL
where oc_study = 'CCR_CTMS_312'
 order by VIEW_NAME, CRT_SEQ;

spool off