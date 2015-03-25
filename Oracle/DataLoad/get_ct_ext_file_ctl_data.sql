column text75 format a75 head ##
column text   format a145 word
set lines 145 pages 0 head off termout on long 10000 feed off

Spool ct_ext_file_ctl_CCR_CTMS_312.sql

select 'REM This code was generated from the script get_ct_ext_file_ctl_data.sql.' text75
  from dual;

select
'Declare '                              text75,
' '                                     text75,
'  xOC_STUDY           varchar2(30);'   text75,
'  xFILE_ID            varchar2(30);'   text75,
'  xINST_ID            varchar2(8);'    text75,
'  xEXT_IND            varchar2(1);'    text75,
'  xREPORT_TO          varchar2(30);'   text75,
'  xVERSION            varchar2(8);'    text75,
'  xLAST_EXT_DATE      DATE;'           text75,
'  xCURRENT_EXT_DATE   DATE;'           text75,
'  xUPD_LAST_EXT_DATE  varchar2(1);'    text75,
'  xEXTRACT_MODE       varchar2(30);'   text75,
'  xCREATE_BY          varchar2(30);'   text75,
'  xCREATION_DATE      DATE;'           text75,
'  '                                    text75,
'Begin '                                text75,
'  xOC_STUDY           := '''||oc_study||''';'            text75,
'  xFILE_ID            := '''||FILE_ID||''';'             text75,
'  xINST_ID            := '''||INST_ID||''';'             text75,
'  xEXT_IND            := '''||EXT_IND||''';'             text75,
'  xREPORT_TO          := '''||REPORT_TO||''';'           text75,
'  xVERSION            := '''||VERSION||''';'             text75,
'  xLAST_EXT_DATE      := NULL;'                          text75,
'  xCURRENT_EXT_DATE   := NULL;'                          text75,
'  xUPD_LAST_EXT_DATE  := '''||UPD_LAST_EXT_DATE||''';'   text75,
'  xEXTRACT_MODE       := '''||EXTRACT_MODE||''';'        text75,
'  xCREATE_BY          := USER;'                          text75,
'  xCREATION_DATE      := SYSDATE;'                       text75,
'   '                                                     text75,
'INSERT INTO CT_EXT_FILE_CTL$PRC ('                       text75,
'   OC_STUDY, FILE_ID, INST_ID, '                            text75,
'   EXT_IND, REPORT_TO, VERSION, '                           text75,
'   LAST_EXT_DATE, CURRENT_EXT_DATE, UPD_LAST_EXT_DATE, '    text75,
'   EXTRACT_MODE, CREATE_BY, CREATION_DATE) '                text75,
'  Values '                                                  text75,
'   (xOC_STUDY,      xFILE_ID,          xINST_ID,        '   text75,
'    xEXT_IND,       xREPORT_TO,        xVERSION,        '   text75,
'    xLAST_EXT_DATE, xCURRENT_EXT_DATE, xUPD_LAST_EXT_DATE,' text75,
'    xEXTRACT_MODE,  xCREATE_BY,        xCREATION_DATE);'     text75,
' '                   text75,
'  commit;'           text75,
'  '                  text75,
'End; '               text75,
'/'                   text75
from CT_EXT_FILE_CTL
where oc_study = 'CCR_CTMS_312'
 order by FILE_ID;

spool off