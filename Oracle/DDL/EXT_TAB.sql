CREATE TABLE CT_EXT_DATA (
  REC_SEQ                      VARCHAR2(30)     NOT NULL
 ,FILE_ID                      VARCHAR2(30)      NOT NULL
 ,VERSION                      VARCHAR2(4)      NOT NULL
 ,EXTRACTED                    DATE             NOT NULL
 ,RECEIVED_DCM_ID              NUMBER(10)      
 ,RECEIVED_DCM_ENTRY_TS        DATE            
 ,DOCNUM                       VARCHAR2(20)
 ,DEL_FLAG                     VARCHAR2(1)
 ,PROTOCOL                     VARCHAR2(12)     NOT NULL
 ,PT                           VARCHAR2(10)
 ,PATIENT                      VARCHAR2(12)
 ,KEY1                         VARCHAR2(120)
 ,KEY2                         VARCHAR2(120)
 ,KEY3                         VARCHAR2(120)
 ,KEY4                         VARCHAR2(120)
 ,KEY5                         VARCHAR2(120)
 ,LINE_TEXT                    VARCHAR2(2600)
 ,SUBMISSION_FLAG              NUMBER DEFAULT 1
 ,EXT_SOURCE                   VARCHAR2(1) DEFAULT 'N')
/

CREATE TABLE CT_DATA (
  REC_SEQ                      VARCHAR2(30)     NOT NULL
 ,FILE_ID                      VARCHAR2(30)      NOT NULL
 ,VERSION                      VARCHAR2(4)      NOT NULL
 ,EXTRACTED                    DATE             NOT NULL
 ,RECEIVED_DCM_ID              NUMBER(10)      
 ,RECEIVED_DCM_ENTRY_TS        DATE            
 ,DOCNUM                       VARCHAR2(20)
 ,DEL_FLAG                     VARCHAR2(1)
 ,PROTOCOL                     VARCHAR2(12)     NOT NULL
 ,PT                           VARCHAR2(10)
 ,PATIENT                      VARCHAR2(12)
 ,KEY1                         VARCHAR2(120)
 ,KEY2                         VARCHAR2(120)
 ,KEY3                         VARCHAR2(120)
 ,KEY4                         VARCHAR2(120)
 ,KEY5                         VARCHAR2(120)
 ,LINE_TEXT                    VARCHAR2(2600)
 ,SUBMISSION_FLAG              NUMBER DEFAULT 1
 ,EXT_SOURCE                   VARCHAR2(1) DEFAULT 'N')
/

CREATE BITMAP INDEX CTD_FILE_ID_I ON CT_DATA(FILE_ID)
/

CREATE BITMAP INDEX CTD_EXTRACTED_I ON CT_DATA(EXTRACTED)
/

CREATE BITMAP INDEX CTD_PT_I ON CT_DATA(PT)
/

CREATE BITMAP INDEX CTD_DEL_FLAG_I ON CT_DATA(DEL_FLAG)
/

CREATE BITMAP INDEX CTD_PROTOCOL_I ON CT_DATA(PROTOCOL)
/

CREATE BITMAP INDEX CTD_EXT_SOURCE_I ON CT_DATA(EXT_SOURCE)
/

CREATE BITMAP INDEX CTD_SUBMISSION_FLAG_I ON CT_DATA(SUBMISSION_FLAG)
/

CREATE TABLE CDUS_DATA (
  REC_SEQ                      VARCHAR2(30)     NOT NULL
 ,FILE_ID                      VARCHAR2(30)      NOT NULL
 ,VERSION                      VARCHAR2(4)      NOT NULL
 ,EXTRACTED                    DATE             NOT NULL
 ,RECEIVED_DCM_ID              NUMBER(10)      
 ,RECEIVED_DCM_ENTRY_TS        DATE            
 ,DOCNUM                       VARCHAR2(20)
 ,DEL_FLAG                     VARCHAR2(1)
 ,PROTOCOL                     VARCHAR2(12)     NOT NULL
 ,PT                           VARCHAR2(10)
 ,PATIENT                      VARCHAR2(12)
 ,KEY1                         VARCHAR2(120)
 ,KEY2                         VARCHAR2(120)
 ,KEY3                         VARCHAR2(120)
 ,KEY4                         VARCHAR2(120)
 ,KEY5                         VARCHAR2(120)
 ,LINE_TEXT                    VARCHAR2(2600)
 ,SUBMISSION_FLAG              NUMBER DEFAULT 1
 ,EXT_SOURCE                   VARCHAR2(1) DEFAULT 'N')
/

CREATE TABLE CT_REC_TYPE (
            FILE_ID                     VARCHAR2(30)
           ,VERSION                     VARCHAR2(4)
           ,EXTRACTED                   DATE
           ,RECEIVED_DCM_ID             NUMBER(10)
           ,RECEIVED_DCM_ENTRY_TS       DATE
           ,DOCNUM                      VARCHAR2(20)
           ,DEL_FLAG                    VARCHAR2(1)
           ,PROTOCOL                    VARCHAR2(12)
           ,PT                          VARCHAR2(10)
           ,PATIENT                     VARCHAR2(12)
           ,KEY1                         VARCHAR2(120)
           ,KEY2                         VARCHAR2(120)
           ,KEY3                         VARCHAR2(120)
           ,KEY4                         VARCHAR2(120)
           ,KEY5                         VARCHAR2(120)
           ,LINE_TEXT                   VARCHAR2(2600))
/

CREATE TABLE CT_EXT_TEMP (
  REC_SEQ                      VARCHAR2(30)     NOT NULL
 ,FILE_ID                      VARCHAR2(30)      NOT NULL
 ,VERSION                      VARCHAR2(4)      NOT NULL
 ,EXTRACTED                    DATE             NOT NULL
 ,RECEIVED_DCM_ID              NUMBER(10)      
 ,RECEIVED_DCM_ENTRY_TS        DATE            
 ,DOCNUM                       VARCHAR2(20)
 ,DEL_FLAG                     VARCHAR2(1)
 ,PROTOCOL                     VARCHAR2(12)     NOT NULL
 ,PT                           VARCHAR2(10)
 ,PATIENT                      VARCHAR2(12)
 ,KEY1                         VARCHAR2(120)
 ,KEY2                         VARCHAR2(120)
 ,KEY3                         VARCHAR2(120)
 ,KEY4                         VARCHAR2(120)
 ,KEY5                         VARCHAR2(120)
 ,LINE_TEXT                    VARCHAR2(2600)
 ,SUBMISSION_FLAG              NUMBER DEFAULT 1
 ,EXT_SOURCE                   VARCHAR2(1) DEFAULT 'N')
/

-------------------------------------

CREATE TABLE CT_EXT_STUDY_CTL
 (OC_STUDY              VARCHAR2(30)   NOT NULL
 ,OC_OBJECT_OWNER          VARCHAR2(30)
 ,EXT_OBJECT_OWNER         VARCHAR2(30)
 )
/

CREATE TABLE CT_EXT_FILE_CTL 
 (OC_STUDY                      VARCHAR2(30)   NOT NULL
 ,FILE_ID                       VARCHAR2(30)    NOT NULL
 ,INST_ID                       VARCHAR2(8)
 ,EXT_IND                       VARCHAR2(1)
 ,REPORT_TO             VARCHAR2(30)   NOT NULL
 ,VERSION               VARCHAR2(8)
 ,LAST_EXT_DATE         DATE
 ,CURRENT_EXT_DATE         DATE
 ,UPD_LAST_EXT_DATE        VARCHAR2(1)
 )
/

CREATE TABLE CT_EXT_STUDY_RPT_CTL
 (OC_STUDY              VARCHAR2(30)   NOT NULL
 ,REPORT_TO             VARCHAR2(30)   NOT NULL
 ,VERSION               VARCHAR2(8)   
 ,REPORT_AS             VARCHAR2(30)
 ,NOTE                  VARCHAR2(240)
 )
/

CREATE TABLE CT_EXT_VW_CTL
 (OC_STUDY              VARCHAR2(30)   NOT NULL
 ,VIEW_NAME             VARCHAR2(30)   NOT NULL
 ,CRT_SEQ               NUMBER
 ,TEXT                  LONG
 ,SYNONYM_NAME          VARCHAR2(30)
 )
/

CREATE TABLE CT_EXT_OC_OBJ_CTL
 (OC_STUDY              VARCHAR2(30)   NOT NULL
 ,SYNONYM_NAME          VARCHAR2(30)
 ,OBJECT_NAME           VARCHAR2(30)
 ,OBJECT_OWNER          VARCHAR2(30)
 ,CRT_SEQ               NUMBER
 )
/

CREATE TABLE CT_EXT_CRS_CTL
 (OC_STUDY              VARCHAR2(30)   NOT NULL
 ,REPORT_TO             VARCHAR2(30)   NOT NULL
 ,VERSION               VARCHAR2(8)
 ,FILE_ID               VARCHAR2(30)     NOT NULL
 ,CRS_NAME              VARCHAR2(30)
 ,CRS_TYPE              VARCHAR2(30)
 ,EXT_SEQ               NUMBER
 ,TEXT                  LONG
 ,EXT_SOURCE            VARCHAR2(1)
 )
/


CREATE TABLE CT_EXT_LOGS 
 (LOG_ID                        NUMBER        NOT NULL
 ,FILE_ID                       VARCHAR2(30)   NOT NULL
 ,PROC_NAME                     VARCHAR2(30)  NOT NULL
 ,STUDY                      VARCHAR2(30) 
 ,INST_ID                       VARCHAR2(8)
 ,LAST_EXT_DATE                 DATE
 ,EXT_STATUS                    VARCHAR2(30)
 ,START_DATE                    DATE          NOT NULL
 ,END_DATE                      DATE
 ,RECORD_READ_NUM NUMBER
 ,RECORD_INSERT_NUM NUMBER
 ,RECORD_UPDATE_NUM NUMBER
 ,RECORD_ERROR_NUM NUMBER
 ,PROC_DATE                     DATE   DEFAULT SYSDATE
 )
/

CREATE TABLE CT_EXT_ERRORS 
 (ERR_ID                        NUMBER        NOT NULL
 ,FILE_ID                       VARCHAR2(30)   NOT NULL
 ,STUDY                      VARCHAR2(30) 
 ,INST_ID                       VARCHAR2(8)
 ,PROC_NAME VARCHAR2(240)
 ,STEP_NAME VARCHAR2(30)
 ,KEY_VALUE VARCHAR2(240)
 ,SQL_ERROR_CODE VARCHAR2(30)
 ,SQL_ERROR_DESC VARCHAR2(240)
 ,CT_ERROR_DESC  VARCHAR2(2000)
 ,PROC_DATE                     DATE   DEFAULT SYSDATE
 )
/

CREATE TABLE CT_APP_META_DATA
 (NAME             VARCHAR2(30)
 ,VALUE            VARCHAR2(30)
 )
/

CREATE TABLE CT_DATA_VW_CTL
 (FILE_ID               VARCHAR2(30)   NOT NULL
 ,FIELD_NAME            VARCHAR2(30)   NOT NULL
 ,FIELD_SEQ             NUMBER
 ,START_POS             NUMBER
 ,FIELD_LENGTH          NUMBER
 ,VIEW_NAME             VARCHAR2(30)
 ,FIELD_TYPE            VARCHAR2(8)
 ,FIELD_PRECISION       NUMBER
 ,REPORT_TO             VARCHAR2(30) 
 ,VERSION               VARCHAR2(30) 
 )
/

CREATE TABLE CT_DATA_MAP_CTL
 (FILE_ID               VARCHAR2(30)   NOT NULL
 ,FIELD_NAME            VARCHAR2(30)   NOT NULL
 ,EXT_VIEW_NAME         VARCHAR2(30)
 ,EXT_COLUMN_NAME       VARCHAR2(30)
 ,EXT_FIELD_FUNC        VARCHAR2(120)
 ,EXT_COLUMN_NAME_FUL   VARCHAR2(30)
 ,EXT_FIELD_FUNC_FUL    VARCHAR2(120)
 ,OTH_VIEW_NAME         VARCHAR2(30)
 ,OTH_COLUMN_NAME       VARCHAR2(30)
 ,OTH_FIELD_FUNC        VARCHAR2(120)
 ,OTH_COLUMN_NAME_FUL   VARCHAR2(30)
 ,OTH_FIELD_FUNC_FUL    VARCHAR2(120)
 ,STUDY_NAME            VARCHAR2(30) 
 ,REPORT_TO             VARCHAR2(30) 
 ,VERSION               VARCHAR2(30) 
 )
/

CREATE INDEX CT_DVC_FILE_ID_I ON CT_DATA_VW_CTL(FILE_ID)
/

CREATE SEQUENCE CT_EXT_ERROR_ID_SEQ
 INCREMENT BY 1
 START WITH 1
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
 CACHE 20
 ORDER
/

CREATE SEQUENCE CT_EXT_LOG_ID_SEQ
 INCREMENT BY 1
 START WITH 1
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
 CACHE 20
 ORDER
/


CREATE TABLE CT_EXT_ACCOUNTS
 (USER_NAME              VARCHAR2(30)   NOT NULL
 )
/
