column text75 format a75 head ##

set lines 145 pages 0 head off termout on long 10000 feed off

Spool ct_ext_study_rpt_ctl_CCR_CTMS_312.sql

select 'REM This code was generated from the script ' text75,
       'REM get_ct_ext_study_rpt_ctl_data.sql.' text75,
       ' ' text75
  from dual;

select
'Declare '                              text75,
' '                                     text75,
'  xOC_STUDY           VARCHAR2(30);'   text75,
'  xREPORT_TO          VARCHAR2(30);'   text75,
'  xVERSION            VARCHAR2(8);'    text75,
'  xREPORT_AS          VARCHAR2(30);'   text75,
'  xNOTE               VARCHAR2(240);'  text75,
'  xMRN_INST_CD        VARCHAR2(30);'   text75,
'  xCREATE_BY          VARCHAR2(30);'   text75,
'  xCREATION_DATE      DATE;'           text75,
'  '                                    text75,
'Begin '                                text75,
'  xOC_STUDY           := '''||oc_study||''';'  text75,
'  xREPORT_TO          := '''||REPORT_TO||''';' text75,
'  xVERSION            := '''||VERSION||''';'   text75,
'  xREPORT_AS          := '''||REPORT_AS||''';' text75,
'  xNOTE               := '''||NOTE||'''; '     text75,
'  xMRN_INST_CD        := '''||VERSION||''';'   text75,
'  xCREATE_BY          := USER;'                text75,
'  xCREATION_DATE      := SYSDATE;'             text75,
'   '                                           text75,
'INSERT INTO CT_EXT_STUDY_RPT_CTL$PRC ('        text75,
'  OC_STUDY,      REPORT_TO,  VERSION, '        text75,
'  REPORT_AS,     NOTE,       CREATE_BY, '      text75,
'  CREATION_DATE, MRN_INST_CD)'                 text75,
'Values ('                                      text75,
'  xOC_STUDY,      xREPORT_TO, xVERSION, '      text75,
'  xREPORT_AS,     xNOTE,      xCREATE_BY,'     text75,
'  xCREATION_DATE, xMRN_INST_CD);'              text75,
' '                                             text75,
'  commit;'                                     text75,
'  '                                            text75,
'End; '                                         text75,
'/'                                             text75
from CT_EXT_STUDY_RPT_CTL
where oc_study = 'CCR_CTMS_312'
 order by REPORT_TO;

spool off