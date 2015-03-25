column text50 format a75 head ##
column text75 format a75 head ##
column text   format a145 word
set lines 145 pages 0 head off termout on long 10000

Spool ct_ext_crs_ctl_CCR_CTMS_312.sql

select 'REM This code was generated from the script get_ct_ext_crs_ctl_data.sql.' text75,
       'REM Before the script can successfully executed, the output (this file) ' text75,
       'REM must be editted.  Substitute all single quotes '' for a pair of ' text75,
       'REM single qotes '''', then substitue all pound signs # with '        text75,
       'REM a single quote ''.'                                               text75,
       '  ' text75
  from dual;


select
'Declare ' Text50,
' ' text50,
'  xOC_STUDY       varchar2(30);'   text50,
'  xREPORT_TO      varchar2(30); '  text50,
'  xVERSION        varchar2(8);'    text50,
'  xFILE_ID        varchar2(30);'   text50,
'  xCRS_NAME       varchar2(30);'   text50,
'  xCRS_TYPE       varchar2(30);'   text50,
'  xEXT_SEQ        NUMBER;'         text50,
'  xTEXT           LONG;'           text50,
'  xEXT_SOURCE     varchar2(1);'    text50,
'  xCREATE_BY      varchar2(30);'   text50,
'  xCREATION_DATE  DATE;'           text50,
'  xNOTE           varchar2(2000);' text50,
'  xMODIFIED_BY    varchar2(30);'   text50,
'  xMODIFIED_DATE  DATE;'           text50,
'  '     text50,
'Begin ' text50,
'  xOC_STUDY       := #'||oc_study||'#;'    text50,
'  xREPORT_TO      := #'||REPORT_TO||'#;'   text50,
'  xVERSION        := #'||VERSION||'#;'     text50,
'  xFILE_ID        := #'||FILE_ID||'#;'     text50,
'  xCRS_NAME       := #'||CRS_NAME||'#;'    text50,
'  xCRS_TYPE       := #'||CRS_TYPE||'#;'    text50,
'  xEXT_SEQ        := '||EXT_SEQ||';'       text50,
'  xTEXT           := #' TEXT50,
TEXT,
'#;'        text50,
'  xEXT_SOURCE     := #'||EXT_SOURCE||'#;'    text50,
'  xCREATE_BY      := USER;'                  text50,
'  xCREATION_DATE  := SYSDATE;'               text50,
'  xNOTE           := #'||NOTE||'#;',
'  xMODIFIED_BY    := NULL;'                  text50,
'  xMODIFIED_DATE  := NULL;'                  text50,
'   ' text50,
'  Insert into CT_EXT_CRS_CTL$PRC '                text75,
'        (OC_STUDY, REPORT_TO, VERSION, FILE_ID, ' text75,
'         CRS_NAME, CRS_TYPE, EXT_SEQ, TEXT, '     text75,
'         EXT_SOURCE, CREATE_BY, CREATION_DATE, '  text75,
'         NOTE, MODIFIED_BY, MODIFIED_DATE)'       text75,
'  Values '                                        text75,
'        (xOC_STUDY,   xREPORT_TO,   xVERSION,    xFILE_ID, ' text75,
'         xCRS_NAME,   xCRS_TYPE,    xEXT_SEQ,    xTEXT, '    text75,
'         xEXT_SOURCE, xCREATE_BY,   xCREATION_DATE, '        text75,
'         xNOTE,       xMODIFIED_BY, xMODIFIED_DATE);'        text75,
' '                                                           text75,
'  commit;'    text75,
'  '           text75,
'End; '        text75,
'/'            text75
from CT_EXT_CRS_CTL
where oc_study = 'CCR_CTMS_312'
 order by File_id, crs_name;

spool off