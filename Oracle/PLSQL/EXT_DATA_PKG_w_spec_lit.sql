CREATE OR REPLACE PACKAGE EXT_DATA_PKG

 IS

-- Sub-Program Unit Declarations

  TYPE CT_CURTYPE IS REF CURSOR;

  TYPE CT_TAB IS TABLE OF CT_REC_TYPE%ROWTYPE
      INDEX BY BINARY_INTEGER;

PROCEDURE P_INS_CT_EXT_DATA
 (P_EXT_SOURCE                  IN VARCHAR2
 ,P_REC_SEQ                     IN VARCHAR2
 ,P_FILE_ID                     IN VARCHAR2
 ,P_VERSION                     IN VARCHAR2
 ,P_EXTRACTED                   IN DATE
 ,P_RECEIVED_DCM_ID             IN NUMBER
 ,P_RECEIVED_DCM_ENTRY_TS       IN DATE
 ,P_DOCNUM                      IN VARCHAR2
 ,P_DEL_FLAG                    IN VARCHAR2
 ,P_PROTOCOL                    IN VARCHAR2
 ,P_PT                          IN VARCHAR2
 ,P_PATIENT                     IN VARCHAR2
 ,P_KEY1                        IN VARCHAR2
 ,P_KEY2                        IN VARCHAR2
 ,P_KEY3                        IN VARCHAR2
 ,P_KEY4                        IN VARCHAR2
 ,P_KEY5                        IN VARCHAR2
 ,P_LINE_TEXT                   IN VARCHAR2
 ,P_DEBUG_MODE                  IN VARCHAR2 := 'CONT'
 );

PROCEDURE P_INS_CT_EXT_TEMP
 (P_EXT_SOURCE                  IN VARCHAR2
 ,P_REC_SEQ                     IN VARCHAR2
 ,P_FILE_ID                     IN VARCHAR2
 ,P_VERSION                     IN VARCHAR2
 ,P_EXTRACTED                   IN DATE
 ,P_RECEIVED_DCM_ID             IN NUMBER
 ,P_RECEIVED_DCM_ENTRY_TS       IN DATE
 ,P_DOCNUM                      IN VARCHAR2
 ,P_DEL_FLAG                    IN VARCHAR2
 ,P_PROTOCOL                    IN VARCHAR2
 ,P_PT                          IN VARCHAR2
 ,P_PATIENT                     IN VARCHAR2
 ,P_KEY1                        IN VARCHAR2
 ,P_KEY2                        IN VARCHAR2
 ,P_KEY3                        IN VARCHAR2
 ,P_KEY4                        IN VARCHAR2
 ,P_KEY5                        IN VARCHAR2
 ,P_LINE_TEXT                   IN VARCHAR2
 ,P_DEBUG_MODE                  IN VARCHAR2 := 'CONT'
 );

PROCEDURE P_INS_CT_TAB
 (P_CT_TAB                 IN OUT CT_TAB
 ,P_I                      IN NUMBER
 ,P_FILE_ID                IN VARCHAR2
 ,P_VERSION                IN VARCHAR2
 ,P_EXTRACTED              IN DATE
 ,P_RECEIVED_DCM_ID        IN NUMBER
 ,P_RECEIVED_DCM_ENTRY_TS  IN DATE
 ,P_DOCNUM                 IN VARCHAR2
 ,P_DEL_FLAG               IN VARCHAR2
 ,P_PROTOCOL               IN VARCHAR2
 ,P_PT                     IN VARCHAR2
 ,P_PATIENT                IN VARCHAR2
 ,P_KEY1                   IN VARCHAR2
 ,P_KEY2                   IN VARCHAR2
 ,P_KEY3                   IN VARCHAR2
 ,P_KEY4                   IN VARCHAR2
 ,P_KEY5                   IN VARCHAR2
 ,P_LINE_TEXT              IN VARCHAR2
 ,P_DEBUG_MODE             IN VARCHAR2 := 'CONT'
 );

PROCEDURE P_EXT_DATA
 (P_EXT_SOURCE        IN VARCHAR2
 ,P_CT_TAB            IN CT_TAB
 ,P_FILE_ID           IN VARCHAR2 := 'CA'
 ,P_VERSION           IN VARCHAR2 := 'T300'
 ,P_PROC_NAME         IN VARCHAR2 := 'NORMAL'
 ,P_CURRENT_EXT_DATE  IN DATE     := SYSDATE
 ,P_EXT_STATUS        IN OUT VARCHAR2
 ,P_DEBUG_MODE        IN VARCHAR2 := 'CONT'
 );

PROCEDURE P_EXT_TEMP
 (P_EXT_SOURCE        IN VARCHAR2
 ,P_CT_TAB            IN CT_TAB
 ,P_FILE_ID           IN VARCHAR2 := 'CA'
 ,P_VERSION           IN VARCHAR2 := 'T300'
 ,P_PROC_NAME         IN VARCHAR2 := 'NORMAL'
 ,P_CURRENT_EXT_DATE  IN DATE     := SYSDATE
 ,P_EXT_STATUS        IN OUT VARCHAR2
 ,P_DEBUG_MODE        IN VARCHAR2 := 'CONT'
 );

PROCEDURE P_EXTRACT
 (P_STUDY                         IN VARCHAR2
 ,P_REPORT_TO                     IN VARCHAR2
 ,P_ALL_DCM_FLAG                     IN VARCHAR2
 ,P_OTH_LAB_FLAG                     IN VARCHAR2
 ,P_OTH_LAB_UL_FLAG                  IN VARCHAR2
 ,P_SUBMISSION_FLAG                  IN VARCHAR2
 ,P_DEBUG_MODE                       IN VARCHAR2 := 'CONT'
 );

PROCEDURE P_ALL_DCM_FILE
 (P_STUDY             IN VARCHAR2
 ,P_REPORT_TO         IN VARCHAR2
 ,P_VERSION           IN VARCHAR2
 ,P_FILE_ID           IN VARCHAR2
 ,P_DEBUG_MODE        IN VARCHAR2 := 'CONT'
 );

PROCEDURE P_ALL_OTH_FILE
 (P_STUDY             IN VARCHAR2
 ,P_REPORT_TO         IN VARCHAR2
 ,P_VERSION           IN VARCHAR2
 ,P_FILE_ID           IN VARCHAR2
 ,P_UL_FLAG           IN VARCHAR2
 ,P_DEBUG_MODE        IN VARCHAR2 := 'CONT'
 );

PROCEDURE P_ONE_CRS
 (P_CRS               IN LONG
 ,P_CRS_TYPE          IN VARCHAR2
 ,P_STUDY             IN VARCHAR2
 ,P_FILE_ID           IN VARCHAR2
 ,P_VERSION           IN VARCHAR2
 ,P_CURRENT_EXT_DATE  IN DATE
 ,P_EXT_OWNER         IN VARCHAR2
 ,P_EXT_SOURCE        IN VARCHAR2
 ,P_EXT_STATUS        IN OUT VARCHAR2
 ,P_DEBUG_MODE        IN VARCHAR2 := 'CONT'
 );

PROCEDURE P_FILE_CRS
 (P_STUDY             IN VARCHAR2
 ,P_EXT_OWNER         IN VARCHAR2
 ,P_FILE_ID           IN VARCHAR2
 ,P_CRS_NAME          IN VARCHAR2
 ,P_REPORT_TO         IN VARCHAR2
 ,P_VERSION           IN VARCHAR2
 ,P_CURRENT_EXT_DATE  IN DATE
 ,P_EXT_SOURCE        IN VARCHAR2
 ,P_DEBUG_MODE        IN VARCHAR2 := 'CONT'
 );

PROCEDURE P_OTH_FILE_CRS
 (P_STUDY             IN VARCHAR2
 ,P_EXT_OWNER         IN VARCHAR2
 ,P_FILE_ID           IN VARCHAR2
 ,P_REPORT_TO         IN VARCHAR2
 ,P_VERSION           IN VARCHAR2
 ,P_CURRENT_EXT_DATE  IN DATE
 ,P_EXT_SOURCE        IN VARCHAR2
 ,P_DEBUG_MODE        IN VARCHAR2 := 'CONT'
 );

PROCEDURE P_INS_CRS_AE
 (P_CT_TAB                      IN OUT EXT_DATA_PKG.CT_TAB
 ,P_COUNT                       IN OUT NUMBER
 ,P_EXT_OWNER                   IN VARCHAR2
 ,P_DEBUG_MODE                  IN VARCHAR2 := 'CONT'
 );

PROCEDURE P_TX_CRS
 (P_STUDY             IN VARCHAR2
 ,P_EXT_OWNER         IN VARCHAR2
 ,P_FILE_ID           IN VARCHAR2
 ,P_REPORT_TO         IN VARCHAR2
 ,P_VERSION           IN VARCHAR2
 ,P_CURRENT_EXT_DATE  IN DATE
 ,P_DEBUG_MODE        IN VARCHAR2 := 'CONT'
 );

PROCEDURE P_SUBMISSION
 (P_STUDY        IN VARCHAR2
 ,P_REPORT_AS    IN VARCHAR2
 ,P_DEBUG_MODE   IN VARCHAR2 := 'CONT'
 );

PROCEDURE P_DELETE_ALL_2
 (P_STUDY            IN VARCHAR2
 ,P_DEBUG_MODE       IN VARCHAR2 := 'CONT'
 );

PROCEDURE P_SPECIAL_2
 (P_STUDY        IN VARCHAR2
 ,P_DEBUG_MODE   IN VARCHAR2 := 'CONT'
 );

PROCEDURE P_SPECIAL_BLANK
 (P_STUDY        IN VARCHAR2
 ,P_DEBUG_MODE   IN VARCHAR2 := 'CONT'
 );

PROCEDURE P_STUDY_NAME
 (P_STUDY       IN VARCHAR2
 ,P_REPORT_AS   IN VARCHAR2
 ,P_DEBUG_MODE  IN VARCHAR2 := 'CONT'
 );

FUNCTION F_STUDY_RPT_AS
 (P_STUDY      IN VARCHAR2
 ,P_REPORT_TO  IN VARCHAR2
 )
 RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES (F_STUDY_RPT_AS, WNDS, WNPS);

FUNCTION F_EXT_OWNER
 (P_STUDY      IN VARCHAR2
 )
 RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES (F_EXT_OWNER, WNDS, WNPS);

FUNCTION F_CT_DATA_TX_EXIST
 (P_FILE_ID     IN VARCHAR2
 ,P_PROTOCOL    IN VARCHAR2
 ,P_PT          IN VARCHAR2
 ,P_PATIENT     IN VARCHAR2
 ,P_KEY1        IN VARCHAR2
 ,P_KEY2        IN VARCHAR2
 ,P_KEY3        IN VARCHAR2
 ,P_LINE_TEXT   IN VARCHAR2)
 RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES (F_CT_DATA_TX_EXIST, WNDS, WNPS);

FUNCTION F_FIELD_POS
 (P_REPORT_TO    IN VARCHAR2
 ,P_VERSION      IN VARCHAR2
 ,P_FILE_ID      IN VARCHAR2
 ,P_POS          IN NUMBER
 )
 RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES (F_FIELD_POS, WNDS, WNPS);

FUNCTION F_LAB_OTH_UPD
 (P_FILE_ID     IN VARCHAR2
 ,P_PROTOCOL    IN VARCHAR2
 ,P_PT          IN VARCHAR2
 ,P_PATIENT     IN VARCHAR2
 ,P_KEY1        IN VARCHAR2
 ,P_KEY2        IN VARCHAR2
 ,P_KEY3        IN VARCHAR2
 ,P_LINE_TEXT   IN VARCHAR2
 )
 RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES (F_LAB_OTH_UPD, WNDS, WNPS);

PROCEDURE P_EXTRACT_CDUS
 (P_STUDY                         IN VARCHAR2
 ,P_REPORT_TO                     IN VARCHAR2
 ,P_DEBUG_MODE                       IN VARCHAR2 := 'CONT'
 );

PROCEDURE P_ALL_FILE_CDUS
 (P_STUDY             IN VARCHAR2
 ,P_REPORT_TO         IN VARCHAR2
 ,P_VERSION           IN VARCHAR2
 ,P_FILE_ID           IN VARCHAR2
 ,P_DEBUG_MODE        IN VARCHAR2 := 'CONT'
 );

PROCEDURE P_ONE_CRS_CDUS
 (P_CRS               IN LONG
 ,P_CRS_TYPE          IN VARCHAR2
 ,P_STUDY             IN VARCHAR2
 ,P_FILE_ID           IN VARCHAR2
 ,P_VERSION           IN VARCHAR2
 ,P_CURRENT_EXT_DATE  IN DATE
 ,P_EXT_OWNER         IN VARCHAR2
 ,P_EXT_SOURCE        IN VARCHAR2
 ,P_EXT_STATUS        IN OUT VARCHAR2
 ,P_DEBUG_MODE        IN VARCHAR2 := 'CONT'
 );

END EXT_DATA_PKG;
/

SHow Error

CREATE OR REPLACE PACKAGE BODY EXT_DATA_PKG

    IS
/*
**
** Modification History:
**
** PRC (Ekagra) - 06/13/2003 :
**    In proceddure P_ALL_CRS_CDUS, changed the cursor processor to include the CT_EXT_CRS_CTL table so
**      that the cursors would be selected by the field EXT_SEQ so that the file_id would be written to
**      the extract file in a specific order, not alphabetically.
**
*/
CURSOR GC_CT_DATA_TX_EXIST
         (P_FILE_ID IN VARCHAR2, P_PROTOCOL IN VARCHAR2
         ,P_PT IN VARCHAR2, P_PATIENT IN VARCHAR2
         ,P_KEY1 IN VARCHAR2, P_KEY2 IN VARCHAR2, P_KEY3 IN VARCHAR2) IS
       SELECT *
         FROM CT_DATA_LAST_EXT
        WHERE FILE_ID = P_FILE_ID
          AND PROTOCOL = P_PROTOCOL
          AND PT = P_PT
          AND PATIENT = P_PATIENT
          AND '*'||KEY1 = '*'||P_KEY1
          AND '*'||KEY2 = '*'||P_KEY2
          AND '*'||KEY3 = '*'||P_KEY3
          AND EXT_SOURCE = 'N';

CURSOR C_CT_DATA_LAB_OTH
         (P_FILE_ID IN VARCHAR2, P_PROTOCOL IN VARCHAR2
         ,P_PT IN VARCHAR2, P_PATIENT IN VARCHAR2
         ,P_KEY1 IN VARCHAR2, P_KEY2 IN VARCHAR2, P_KEY3 IN VARCHAR2) IS
       SELECT
              FILE_ID
             ,VERSION
             ,EXTRACTED
             ,RECEIVED_DCM_ID
             ,RECEIVED_DCM_ENTRY_TS
             ,DOCNUM
             ,DEL_FLAG
             ,PROTOCOL
             ,PT
             ,PATIENT
             ,KEY1
             ,KEY2
             ,KEY3
             ,KEY4
             ,KEY5
             ,LINE_TEXT
         FROM CT_DATA_LAST_EXT
        WHERE FILE_ID = P_FILE_ID
          AND PROTOCOL = P_PROTOCOL
          AND PT = P_PT
          AND P_PATIENT = P_PATIENT
          AND KEY1 = P_KEY1
          AND '*'||KEY2 = '*'||P_KEY2
          AND '*'||KEY3 = '*'||P_KEY3
          AND EXT_SOURCE = 'O';

  CURSOR C_FIELD_POS(
                 P_REPORT_TO   IN VARCHAR2
                ,P_VERSION     IN VARCHAR2
                ,P_FILE_ID     IN VARCHAR2
                ,P_POS         IN NUMBER) IS
         SELECT RPAD(START_POS, 8, ' ')||FIELD_LENGTH
          FROM CT_DATA_VW_CTL
         WHERE REPORT_TO  = P_REPORT_TO
           AND FILE_ID    = P_FILE_ID
           AND VERSION    = P_VERSION
           AND P_POS BETWEEN START_POS AND (START_POS + FIELD_LENGTH -1)
           AND ROWNUM = 1;

-- Program Data
G_END_DATE DATE;
G_BEGIN_DATE DATE := SYSDATE;
G_FATAL_ERR EXCEPTION;
G_CHECK_POINT CONSTANT INTEGER := NVL(EXT_UTIL_PKG.F_APP_META_DATA('CHECK_POINT'), 1000);
G_LOAD_DATE DATE := SYSDATE;
G_START_DATE DATE := SYSDATE;
-- PL/SQL Block
-- Sub-Program Units

PROCEDURE P_INS_CT_EXT_DATA
 (P_EXT_SOURCE                  IN VARCHAR2
 ,P_REC_SEQ                     IN VARCHAR2
 ,P_FILE_ID                     IN VARCHAR2
 ,P_VERSION                     IN VARCHAR2
 ,P_EXTRACTED                   IN DATE
 ,P_RECEIVED_DCM_ID             IN NUMBER
 ,P_RECEIVED_DCM_ENTRY_TS       IN DATE
 ,P_DOCNUM                      IN VARCHAR2
 ,P_DEL_FLAG                    IN VARCHAR2
 ,P_PROTOCOL                    IN VARCHAR2
 ,P_PT                          IN VARCHAR2
 ,P_PATIENT                     IN VARCHAR2
 ,P_KEY1                        IN VARCHAR2
 ,P_KEY2                        IN VARCHAR2
 ,P_KEY3                        IN VARCHAR2
 ,P_KEY4                        IN VARCHAR2
 ,P_KEY5                        IN VARCHAR2
 ,P_LINE_TEXT                   IN VARCHAR2
 ,P_DEBUG_MODE                  IN VARCHAR2 := 'CONT'
 )
 IS
  T_MOD_NAME           VARCHAR2(60)  := 'EXT_DATA_PKG.P_INS_CT_EXT_DATA';
  T_STEP_NAME          VARCHAR2(30)   := '1';
BEGIN
  ---- Insert one record into the error table
        INSERT INTO CT_EXT_DATA  (
                          REC_SEQ
                         ,FILE_ID
                         ,VERSION
                         ,EXTRACTED
                         ,RECEIVED_DCM_ID
                         ,RECEIVED_DCM_ENTRY_TS
                         ,DOCNUM
                         ,DEL_FLAG
                         ,PROTOCOL
                         ,PT
                         ,PATIENT
                         ,KEY1
                         ,KEY2
                         ,KEY3
                         ,KEY4
                         ,KEY5
                         ,EXT_SOURCE
                         ,LINE_TEXT     )
               VALUES (
                          P_REC_SEQ
                         ,P_FILE_ID
                         ,P_VERSION
                         ,P_EXTRACTED
                         ,P_RECEIVED_DCM_ID
                         ,P_RECEIVED_DCM_ENTRY_TS
                         ,P_DOCNUM
                         ,P_DEL_FLAG
                         ,P_PROTOCOL
                         ,P_PT
                         ,P_PATIENT
                         ,P_KEY1
                         ,P_KEY2
                         ,P_KEY3
                         ,P_KEY4
                         ,P_KEY5
                         ,P_EXT_SOURCE
                         ,P_LINE_TEXT  );
EXCEPTION
  WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20000,'Error occured in '||T_MOD_NAME||
                '--'||T_STEP_NAME||'--'||SQLCODE||'--'||SQLERRM);
END;

PROCEDURE P_INS_CT_EXT_TEMP
 (P_EXT_SOURCE                  IN VARCHAR2
 ,P_REC_SEQ                     IN VARCHAR2
 ,P_FILE_ID                     IN VARCHAR2
 ,P_VERSION                     IN VARCHAR2
 ,P_EXTRACTED                   IN DATE
 ,P_RECEIVED_DCM_ID             IN NUMBER
 ,P_RECEIVED_DCM_ENTRY_TS       IN DATE
 ,P_DOCNUM                      IN VARCHAR2
 ,P_DEL_FLAG                    IN VARCHAR2
 ,P_PROTOCOL                    IN VARCHAR2
 ,P_PT                          IN VARCHAR2
 ,P_PATIENT                     IN VARCHAR2
 ,P_KEY1                        IN VARCHAR2
 ,P_KEY2                        IN VARCHAR2
 ,P_KEY3                        IN VARCHAR2
 ,P_KEY4                        IN VARCHAR2
 ,P_KEY5                        IN VARCHAR2
 ,P_LINE_TEXT                   IN VARCHAR2
 ,P_DEBUG_MODE                  IN VARCHAR2 := 'CONT'
 )
 IS
  T_MOD_NAME           VARCHAR2(60)  := 'EXT_DATA_PKG.P_INS_CT_EXT_TEMP';
  T_STEP_NAME          VARCHAR2(30)   := '1';
BEGIN
  ---- Insert one record into the error table
        INSERT INTO CT_EXT_TEMP  (
                          REC_SEQ
                         ,FILE_ID
                         ,VERSION
                         ,EXTRACTED
                         ,RECEIVED_DCM_ID
                         ,RECEIVED_DCM_ENTRY_TS
                         ,DOCNUM
                         ,DEL_FLAG
                         ,PROTOCOL
                         ,PT
                         ,PATIENT
                         ,KEY1
                         ,KEY2
                         ,KEY3
                         ,KEY4
                         ,KEY5
                         ,EXT_SOURCE
                         ,LINE_TEXT     )
               VALUES (
                          P_REC_SEQ
                         ,P_FILE_ID
                         ,P_VERSION
                         ,P_EXTRACTED
                         ,P_RECEIVED_DCM_ID
                         ,P_RECEIVED_DCM_ENTRY_TS
                         ,P_DOCNUM
                         ,P_DEL_FLAG
                         ,P_PROTOCOL
                         ,P_PT
                         ,P_PATIENT
                         ,P_KEY1
                         ,P_KEY2
                         ,P_KEY3
                         ,P_KEY4
                         ,P_KEY5
                         ,P_EXT_SOURCE
                         ,P_LINE_TEXT  );

EXCEPTION
  WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20000,'Error occured in '||T_MOD_NAME||
                '--'||T_STEP_NAME||'--'||SQLCODE||'--'||SQLERRM);
END;

PROCEDURE P_INS_CT_TAB
 (P_CT_TAB                 IN OUT CT_TAB
 ,P_I                      IN NUMBER
 ,P_FILE_ID                IN VARCHAR2
 ,P_VERSION                IN VARCHAR2
 ,P_EXTRACTED              IN DATE
 ,P_RECEIVED_DCM_ID        IN NUMBER
 ,P_RECEIVED_DCM_ENTRY_TS  IN DATE
 ,P_DOCNUM                 IN VARCHAR2
 ,P_DEL_FLAG               IN VARCHAR2
 ,P_PROTOCOL               IN VARCHAR2
 ,P_PT                     IN VARCHAR2
 ,P_PATIENT                IN VARCHAR2
 ,P_KEY1                   IN VARCHAR2
 ,P_KEY2                   IN VARCHAR2
 ,P_KEY3                   IN VARCHAR2
 ,P_KEY4                   IN VARCHAR2
 ,P_KEY5                   IN VARCHAR2
 ,P_LINE_TEXT              IN VARCHAR2
 ,P_DEBUG_MODE             IN VARCHAR2 := 'CONT'
 )
 IS
  T_MOD_NAME           VARCHAR2(60)  := 'EXT_DATA_PKG.P_INS_CT_TAB';
  T_STEP_NAME          VARCHAR2(30)   := '1';
BEGIN
           P_CT_TAB(P_I).FILE_ID     := P_FILE_ID;
           P_CT_TAB(P_I).VERSION     := P_VERSION;
           P_CT_TAB(P_I).EXTRACTED   := P_EXTRACTED;
           P_CT_TAB(P_I).RECEIVED_DCM_ID       := P_RECEIVED_DCM_ID;
           P_CT_TAB(P_I).RECEIVED_DCM_ENTRY_TS := P_RECEIVED_DCM_ENTRY_TS;
           P_CT_TAB(P_I).DOCNUM      := P_DOCNUM;
           P_CT_TAB(P_I).DEL_FLAG    := P_DEL_FLAG;
           P_CT_TAB(P_I).PROTOCOL    := P_PROTOCOL;
           P_CT_TAB(P_I).PT          := P_PT;
           P_CT_TAB(P_I).PATIENT     := P_PATIENT;
           P_CT_TAB(P_I).KEY1        := P_KEY1;
           P_CT_TAB(P_I).KEY2        := P_KEY2;
           P_CT_TAB(P_I).KEY3        := P_KEY3;
           P_CT_TAB(P_I).KEY4        := P_KEY4;
           P_CT_TAB(P_I).KEY5        := P_KEY5;
           P_CT_TAB(P_I).LINE_TEXT   := P_LINE_TEXT;
EXCEPTION
  WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,'Error occured in '||T_MOD_NAME||
                '--'||T_STEP_NAME||'--'||SQLCODE||'--'||SQLERRM);
END;

PROCEDURE P_EXT_DATA
 (P_EXT_SOURCE        IN VARCHAR2
 ,P_CT_TAB            IN CT_TAB
 ,P_FILE_ID           IN VARCHAR2 := 'CA'
 ,P_VERSION           IN VARCHAR2 := 'T300'
 ,P_PROC_NAME         IN VARCHAR2 := 'NORMAL'
 ,P_CURRENT_EXT_DATE  IN DATE     := SYSDATE
 ,P_EXT_STATUS        IN OUT VARCHAR2
 ,P_DEBUG_MODE        IN VARCHAR2 := 'CONT'
 )
 IS

  T_MOD_NAME           VARCHAR2(60)  := 'EXT_DATA_PKG.P_EXT_DATA';
  T_STEP_NAME          VARCHAR2(30)  := '1';

    T_inserted_row_count         NUMBER := 0;
    T_inserted_fail_count        NUMBER :=0;
    T_read_count                 NUMBER := 0;
    T_fatal_err                    EXCEPTION;
    T_check_count                PLS_INTEGER := 0;
    T_SQL_ERROR_CODE       CT_EXT_ERRORS.SQL_ERROR_CODE%TYPE;
    T_SQL_ERROR_DESC       CT_EXT_ERRORS.SQL_ERROR_DESC%TYPE;
    T_KEY_VALUE            CT_EXT_ERRORS.KEY_VALUE%TYPE;
    T_CT_ERROR_DESC        CT_EXT_ERRORS.CT_ERROR_DESC%TYPE;
    T_START_DATE           DATE := SYSDATE;
    T_EXT_STATUS           CT_EXT_LOGS.EXT_STATUS%TYPE;
    T_CURRENT_EXT_DATE_VAR VARCHAR2(8);
    T_REC_SEQ              VARCHAR2(30);

    T_FIRST        NUMBER := 0;
    T_LAST         NUMBER := 0;
    I              PLS_INTEGER := 0;
    P_STUDY        VARCHAR2(30);

BEGIN
---------------------------
T_STEP_NAME := '1';

    T_FIRST := NVL(P_CT_TAB.FIRST, 0);
    T_LAST  := NVL(P_CT_TAB.LAST, 0);
    T_CURRENT_EXT_DATE_VAR := TO_CHAR(P_CURRENT_EXT_DATE, 'RRRRMMDD');
    T_EXT_STATUS := 'IN PROGRESS';
    P_EXT_STATUS := 'IN PROGRESS';
---------------------------
T_STEP_NAME := '2';
  IF T_LAST > 0 THEN
   FOR I IN T_FIRST..T_LAST LOOP
      BEGIN
        T_REC_SEQ := T_CURRENT_EXT_DATE_VAR||LPAD(I, 8, '0');
            P_STUDY := P_CT_TAB(I).PROTOCOL;
                P_INS_CT_EXT_DATA(
                             P_EXT_SOURCE                        ---- EXT_SOURCE
                            ,T_REC_SEQ                           -- REC_SEQ
                            ,P_CT_TAB(I).FILE_ID                   -- FILE_ID
                            ,P_CT_TAB(I).VERSION                   -- VERSION
                            ,P_CT_TAB(I).EXTRACTED                 -- EXTRACTED
                            ,P_CT_TAB(I).RECEIVED_DCM_ID           -- RECEIVED_DCM_ID
                            ,P_CT_TAB(I).RECEIVED_DCM_ENTRY_TS     -- RECEIVED_DCM_ENTRY_TS
                            ,P_CT_TAB(I).DOCNUM                    -- DOCNUM
                            ,P_CT_TAB(I).DEL_FLAG                  -- DEL_FLAG
                            ,P_CT_TAB(I).PROTOCOL                  -- STUDY
                            ,P_CT_TAB(I).PT                        -- PT
                            ,P_CT_TAB(I).PATIENT                   -- PATIENT
                            ,P_CT_TAB(I).KEY1                      ---- KEY1
                            ,P_CT_TAB(I).KEY2                      ---- KEY2
                            ,P_CT_TAB(I).KEY3                      ---- KEY3
                            ,P_CT_TAB(I).KEY4                      ---- KEY4
                            ,P_CT_TAB(I).KEY5                      ---- KEY5
                            ,P_CT_TAB(I).LINE_TEXT                 ---- LINE_TEXT
                            ,P_DEBUG_MODE       );               ---- DEBUG_MODE

             ---- Increase the counter by 1
              T_inserted_row_count := T_inserted_row_count + 1;
              T_check_count := T_check_count + 1;
      EXCEPTION
          WHEN OTHERS THEN
            ---- Increase the counter by 1
         T_inserted_fail_count := NVL(T_inserted_fail_count, 0) + 1;
            T_SQL_ERROR_CODE    := SUBSTR(SQLCODE, 1, 30);
            T_SQL_ERROR_DESC    := SUBSTR(SQLERRM, 1, 240);
            T_KEY_VALUE   := 'FILE + PT + PATIENT + KEYS = '||P_FILE_ID||'+'||
                               P_CT_TAB(I).PT||'+'||P_CT_TAB(I).PATIENT||'+'||
                               P_CT_TAB(I).KEY1||'+'||P_CT_TAB(I).KEY2||'+'||P_CT_TAB(I).KEY3||'+'||
                               P_CT_TAB(I).KEY4||'+'||P_CT_TAB(I).KEY5;
            T_CT_ERROR_DESC := 'Insert CT_DATA failed @'||T_MOD_NAME||'--'||T_STEP_NAME||'--'||
                               P_FILE_ID||'--'||P_PROC_NAME;
            -- Error handling procedure
            --  dbms_output.put_line(T_CT_ERROR_DESC);
            EXT_UTIL_PKG.P_CT_EXT_ERRORS
                    (P_STUDY, P_FILE_ID, T_MOD_NAME, T_STEP_NAME
                    ,T_KEY_VALUE, T_SQL_ERROR_CODE, T_SQL_ERROR_DESC
                    ,T_CT_ERROR_DESC, P_DEBUG_MODE);
      END;
        ---- Commit at each Check point
        IF t_check_count = G_check_point THEN
           t_check_count := 0;

           EXT_UTIL_PKG.P_CT_EXT_LOGS
             (P_STUDY, P_FILE_ID, P_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, G_START_DATE, SYSDATE
             ,T_read_count, T_inserted_row_count, NULL, T_inserted_fail_count, P_DEBUG_MODE);
           COMMIT;
        END IF;
    END LOOP;
  END IF;
----------------------------
T_STEP_NAME := '3';

    IF T_inserted_fail_count <> 0 THEN
        T_EXT_STATUS :=  'COMPLETED WITH ERROR';
        P_EXT_STATUS :=  'COMPLETED WITH ERROR';
    ELSE
        T_EXT_STATUS :=  'SUCCESS';
        P_EXT_STATUS :=  'SUCCESS';
    END IF;

    EXT_UTIL_PKG.P_CT_EXT_LOGS
             (P_STUDY, P_FILE_ID, P_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, G_START_DATE, SYSDATE
             ,T_read_count, T_inserted_row_count, NULL, T_inserted_fail_count, P_DEBUG_MODE);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        T_EXT_STATUS := 'FAIL';
        P_EXT_STATUS := 'FAIL';
        T_SQL_ERROR_CODE    := SQLCODE;
        T_SQL_ERROR_DESC    := SQLERRM;
        T_KEY_VALUE         := NULL;
        T_CT_ERROR_DESC := 'Insert CT_DATA failed @'||T_MOD_NAME||'--'||T_STEP_NAME||'--'||
                           P_FILE_ID||'--'||P_PROC_NAME;
        -- Error handling procedure
        -- dbms_output.put_line(T_CT_ERROR_DESC);
        EXT_UTIL_PKG.P_CT_EXT_LOGS
             (P_STUDY, P_FILE_ID, P_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, G_START_DATE, NULL
             ,T_read_count, T_inserted_row_count, NULL, T_inserted_fail_count, P_DEBUG_MODE);

        EXT_UTIL_PKG.P_CT_EXT_ERRORS
                    (P_STUDY, P_FILE_ID, T_MOD_NAME, T_STEP_NAME
                    ,T_KEY_VALUE, T_SQL_ERROR_CODE, T_SQL_ERROR_DESC
                    ,T_CT_ERROR_DESC, P_DEBUG_MODE);
END;

PROCEDURE P_EXT_TEMP
 (P_EXT_SOURCE        IN VARCHAR2
 ,P_CT_TAB            IN CT_TAB
 ,P_FILE_ID           IN VARCHAR2 := 'CA'
 ,P_VERSION           IN VARCHAR2 := 'T300'
 ,P_PROC_NAME         IN VARCHAR2 := 'NORMAL'
 ,P_CURRENT_EXT_DATE  IN DATE     := SYSDATE
 ,P_EXT_STATUS        IN OUT VARCHAR2
 ,P_DEBUG_MODE        IN VARCHAR2 := 'CONT'
 )
 IS

  T_MOD_NAME           VARCHAR2(60)  := 'EXT_DATA_PKG.P_EXT_TEMP';
  T_STEP_NAME          VARCHAR2(30)  := '1';

    T_inserted_row_count         NUMBER := 0;
    T_inserted_fail_count        NUMBER :=0;
    T_read_count                 NUMBER := 0;
    T_fatal_err                    EXCEPTION;
    T_check_count                PLS_INTEGER := 0;
    T_SQL_ERROR_CODE       CT_EXT_ERRORS.SQL_ERROR_CODE%TYPE;
    T_SQL_ERROR_DESC       CT_EXT_ERRORS.SQL_ERROR_DESC%TYPE;
    T_KEY_VALUE            CT_EXT_ERRORS.KEY_VALUE%TYPE;
    T_CT_ERROR_DESC        CT_EXT_ERRORS.CT_ERROR_DESC%TYPE;
    T_START_DATE           DATE := SYSDATE;
    T_EXT_STATUS           CT_EXT_LOGS.EXT_STATUS%TYPE;
    T_CURRENT_EXT_DATE_VAR VARCHAR2(8);
    T_REC_SEQ              VARCHAR2(30);

    T_FIRST        NUMBER := 0;
    T_LAST         NUMBER := 0;
    I              PLS_INTEGER := 0;
    P_STUDY        VARCHAR2(30);

BEGIN
---------------------------
T_STEP_NAME := '1';

    T_FIRST := NVL(P_CT_TAB.FIRST, 0);
    T_LAST  := NVL(P_CT_TAB.LAST, 0);
    T_CURRENT_EXT_DATE_VAR := TO_CHAR(P_CURRENT_EXT_DATE, 'RRRRMMDD');
    T_EXT_STATUS := 'IN PROGRESS';
    P_EXT_STATUS := 'IN PROGRESS';
---------------------------
T_STEP_NAME := '2';
  IF T_LAST > 0 THEN
   FOR I IN T_FIRST..T_LAST LOOP
      BEGIN
        T_REC_SEQ := T_CURRENT_EXT_DATE_VAR||LPAD(I, 8, '0');
            P_STUDY := P_CT_TAB(I).PROTOCOL;
                P_INS_CT_EXT_TEMP(
                             P_EXT_SOURCE
                            ,T_REC_SEQ                           -- REC_SEQ
                            ,P_CT_TAB(I).FILE_ID                   -- FILE_ID
                            ,P_CT_TAB(I).VERSION                   -- VERSION
                            ,P_CT_TAB(I).EXTRACTED                 -- EXTRACTED
                            ,P_CT_TAB(I).RECEIVED_DCM_ID           -- RECEIVED_DCM_ID
                            ,P_CT_TAB(I).RECEIVED_DCM_ENTRY_TS     -- RECEIVED_DCM_ENTRY_TS
                            ,P_CT_TAB(I).DOCNUM                    -- DOCNUM
                            ,P_CT_TAB(I).DEL_FLAG                  -- DEL_FLAG
                            ,P_CT_TAB(I).PROTOCOL                  -- STUDY
                            ,P_CT_TAB(I).PT                        -- PT
                            ,P_CT_TAB(I).PATIENT                   -- PATIENT
                            ,P_CT_TAB(I).KEY1                      ---- KEY1
                            ,P_CT_TAB(I).KEY2                      ---- KEY2
                            ,P_CT_TAB(I).KEY3                      ---- KEY3
                            ,P_CT_TAB(I).KEY4                      ---- KEY4
                            ,P_CT_TAB(I).KEY5                      ---- KEY5
                            ,P_CT_TAB(I).LINE_TEXT                 ---- LINE_TEXT
                            ,P_DEBUG_MODE       );               ---- DEBUG_MODE

             ---- Increase the counter by 1
              T_inserted_row_count := T_inserted_row_count + 1;
              T_check_count := T_check_count + 1;
      EXCEPTION
          WHEN OTHERS THEN
            ---- Increase the counter by 1
         T_inserted_fail_count := NVL(T_inserted_fail_count, 0) + 1;
            T_SQL_ERROR_CODE    := SUBSTR(SQLCODE, 1, 30);
            T_SQL_ERROR_DESC    := SUBSTR(SQLERRM, 1, 240);
            T_KEY_VALUE   := 'FILE + PT + PATIENT + KEYS = '||P_FILE_ID||'+'||
                               P_CT_TAB(I).PT||'+'||P_CT_TAB(I).PATIENT||'+'||
                               P_CT_TAB(I).KEY1||'+'||P_CT_TAB(I).KEY2||'+'||P_CT_TAB(I).KEY3||'+'||
                               P_CT_TAB(I).KEY4||'+'||P_CT_TAB(I).KEY5;
            T_CT_ERROR_DESC := 'Insert CT_DATA failed @'||T_MOD_NAME||'--'||T_STEP_NAME||'--'||
                               P_FILE_ID||'--'||P_PROC_NAME;
            -- Error handling procedure
            --  dbms_output.put_line(T_CT_ERROR_DESC);
            EXT_UTIL_PKG.P_CT_EXT_ERRORS
                    (P_STUDY, P_FILE_ID, T_MOD_NAME, T_STEP_NAME
                    ,T_KEY_VALUE, T_SQL_ERROR_CODE, T_SQL_ERROR_DESC
                    ,T_CT_ERROR_DESC, P_DEBUG_MODE);
      END;
        ---- Commit at each Check point
        IF t_check_count = G_check_point THEN
           t_check_count := 0;

           EXT_UTIL_PKG.P_CT_EXT_LOGS
             (P_STUDY, P_FILE_ID, P_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, G_START_DATE, SYSDATE
             ,T_read_count, T_inserted_row_count, NULL, T_inserted_fail_count, P_DEBUG_MODE);
           COMMIT;
        END IF;
    END LOOP;
  END IF;
----------------------------
T_STEP_NAME := '3';

    IF T_inserted_fail_count <> 0 THEN
        T_EXT_STATUS :=  'COMPLETED WITH ERROR';
        P_EXT_STATUS :=  'COMPLETED WITH ERROR';
    ELSE
        T_EXT_STATUS :=  'SUCCESS';
        P_EXT_STATUS :=  'SUCCESS';
    END IF;

    EXT_UTIL_PKG.P_CT_EXT_LOGS
             (P_STUDY, P_FILE_ID, P_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, G_START_DATE, SYSDATE
             ,T_read_count, T_inserted_row_count, NULL, T_inserted_fail_count, P_DEBUG_MODE);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        T_EXT_STATUS := 'FAIL';
        P_EXT_STATUS := 'FAIL';
        T_SQL_ERROR_CODE    := SQLCODE;
        T_SQL_ERROR_DESC    := SQLERRM;
        T_KEY_VALUE         := NULL;
        T_CT_ERROR_DESC := 'Insert CT_DATA failed @'||T_MOD_NAME||'--'||T_STEP_NAME||'--'||
                           P_FILE_ID||'--'||P_PROC_NAME;
        -- Error handling procedure
        -- dbms_output.put_line(T_CT_ERROR_DESC);
        EXT_UTIL_PKG.P_CT_EXT_LOGS
             (P_STUDY, P_FILE_ID, P_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, G_START_DATE, NULL
             ,T_read_count, T_inserted_row_count, NULL, T_inserted_fail_count, P_DEBUG_MODE);

        EXT_UTIL_PKG.P_CT_EXT_ERRORS
                    (P_STUDY, P_FILE_ID, T_MOD_NAME, T_STEP_NAME
                    ,T_KEY_VALUE, T_SQL_ERROR_CODE, T_SQL_ERROR_DESC
                    ,T_CT_ERROR_DESC, P_DEBUG_MODE);
END;

PROCEDURE P_EXTRACT
 (P_STUDY                         IN VARCHAR2
 ,P_REPORT_TO                     IN VARCHAR2
 ,P_ALL_DCM_FLAG                     IN VARCHAR2
 ,P_OTH_LAB_FLAG                     IN VARCHAR2
 ,P_OTH_LAB_UL_FLAG                  IN VARCHAR2
 ,P_SUBMISSION_FLAG                  IN VARCHAR2
 ,P_DEBUG_MODE                       IN VARCHAR2 := 'CONT'
 )
 IS
  T_MOD_NAME           VARCHAR2(60)  := 'EXT_DATA_PKG.P_EXTRACT';
  T_STEP_NAME          VARCHAR2(30)   := '1';

    T_REPORT_TO   VARCHAR2(30);
    T_REPORT_AS   VARCHAR2(30);
    T_VERSION   VARCHAR2(30);
    T_TEMP    VARCHAR2(1);
    T_START_DATE    DATE := SYSDATE;

    T_REC_SEQ   VARCHAR2(30) := NULL;
    I    NUMBER := 0;
    T_STATUS    VARCHAR2(200);
BEGIN

    BEGIN
      SELECT '1' INTO T_TEMP
        FROM USER_JOBS
       WHERE WHAT LIKE 'EXT_DATA_PKG.P_EXTRACT%'
         AND NVL(FAILURES, 0) <> 0
         AND ROWNUM = 1;

      RETURN;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
      WHEN OTHERS THEN
        RAISE;
    END;

--step 1-------------------
    T_STEP_NAME := '1';

  BEGIN
    SELECT REPORT_TO, VERSION, REPORT_AS INTO T_REPORT_TO, T_VERSION, T_REPORT_AS
      FROM CT_EXT_STUDY_RPT_CTL
     WHERE OC_STUDY = P_STUDY
       AND REPORT_TO = P_REPORT_TO
       AND ROWNUM = 1;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
  END;
--step 1.1-------------------
    T_STEP_NAME := '1.1';
    BEGIN
      EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, 'ALL', 'PROC LAB ALL TAB', SYSDATE, 'PROCESSING', T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);

      EXT_MISC_PKG.P_PROC_STUDY_TAB(P_STUDY, 'LBALLAB', 'LBALLAB');

      EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, 'ALL', 'PROC LAB ALL TAB', SYSDATE, 'SUCCESS', T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);

    EXCEPTION
      WHEN OTHERS THEN
        EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, 'ALL', 'PROC LAB ALL TAB', SYSDATE, 'FAIL', T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);
        --RAISE;  -- PRC : 02/09/05:  This error should NOT stop the entire process.
    END;
--step 2-------------------
    T_STEP_NAME := '2';

    IF UPPER(P_ALL_DCM_FLAG) = 'Y' THEN
      P_ALL_DCM_FILE(P_STUDY, T_REPORT_TO, T_VERSION, NULL, P_DEBUG_MODE);
    END IF;

--step 4-------------------
    T_STEP_NAME := '4';

    IF UPPER(P_OTH_LAB_FLAG) = 'Y' THEN
      P_ALL_OTH_FILE(P_STUDY, T_REPORT_TO, T_VERSION, NULL, 'N', P_DEBUG_MODE);
    END IF;

--step 6-------------------
    T_STEP_NAME := '6';

    IF UPPER(P_OTH_LAB_UL_FLAG) = 'Y' THEN
      P_ALL_OTH_FILE(P_STUDY, T_REPORT_TO, T_VERSION, NULL, 'Y', P_DEBUG_MODE);
    END IF;

--step 7----  combine PH text---------------

    UPDATE CT_EXT_DATA
       SET SUBMISSION_FLAG = 99
     WHERE PROTOCOL = TRIM(P_STUDY)
       AND FILE_ID = 'PH'
       AND DEL_FLAG <> 'D';

    FOR T_PH  IN (SELECT PROTOCOL,PATIENT,PT,DEL_FLAG,NOTE_DT,FILE_ID,TYP_CD,VERSION,EXTRACTED,
                         EXT_UTIL_PKG.F_PH_TEXT_2(PROTOCOL,PATIENT,DEL_FLAG,NOTE_DT,FILE_ID,TYP_CD)  LINE_TEXT
                        FROM (SELECT PROTOCOL,PATIENT,PT,DEL_FLAG,KEY1 NOTE_DT,KEY2 FILE_ID,
                                     KEY3 TYP_CD, VERSION, EXTRACTED
                                FROM CT_EXT_DATA
                               WHERE FILE_ID = 'PH'
                                 AND protocol = TRIM(P_STUDY)
                                 AND SUBMISSION_FLAG = 99
                              GROUP BY PROTOCOL,PATIENT,PT,DEL_FLAG,KEY1,KEY2, KEY3, VERSION, EXTRACTED)  ) LOOP

                I := I + 1;

                T_REC_SEQ := TO_CHAR(T_PH.EXTRACTED, 'RRRRMMDD')||LPAD(I, 8, '0');

                P_INS_CT_EXT_DATA(
                             'N'                            ---- EXT_SOURCE
                            ,T_REC_SEQ                      -- REC_SEQ
                            ,'PH'                           -- FILE_ID
                            ,T_PH.VERSION                   -- VERSION
                            ,T_PH.EXTRACTED                 -- EXTRACTED
                            ,NULL                           -- RECEIVED_DCM_ID
                            ,NULL                           -- RECEIVED_DCM_ENTRY_TS
                            ,NULL                           -- DOCNUM
                            ,T_PH.DEL_FLAG                  -- DEL_FLAG
                            ,T_PH.PROTOCOL                  -- STUDY
                            ,T_PH.PT                        -- PT
                            ,T_PH.PATIENT                   -- PATIENT
                            ,T_PH.NOTE_DT                      ---- KEY1
                            ,T_PH.FILE_ID                   ---- KEY2
                            ,T_PH.TYP_CD                    ---- KEY3
                            ,NULL                      ---- KEY4
                            ,NULL                      ---- KEY5
                            ,T_PH.LINE_TEXT                 ---- LINE_TEXT
                            ,P_DEBUG_MODE       );               ---- DEBUG_MODE

    END LOOP;

    DELETE FROM CT_EXT_DATA
     WHERE PROTOCOL = TRIM(P_STUDY)
       AND FILE_ID = 'PH'
       AND SUBMISSION_FLAG = 99;

--step 8-------------------
    T_STEP_NAME := '8';

    IF UPPER(P_SUBMISSION_FLAG) = 'Y' THEN
      P_SUBMISSION(P_STUDY, T_REPORT_AS, P_DEBUG_MODE);
    END IF;

--Step 8.5-------------------- PRC Added this section by moving the call to P_STUDY_NAME to here
                            -- From inside P_SUBMISSION, so that P_STUDY_NAME is guarunteed to execute
                            -- because a failure from within P_SUBMISSION would cause P_STUDY_NAME to
                            -- be stepped over.
    T_STEP_NAME := '8.5';
    IF UPPER(P_SUBMISSION_FLAG) = 'Y' THEN
      P_STUDY_NAME(P_STUDY, T_REPORT_AS, P_DEBUG_MODE); -- Here from P_SUBMISSION
    END IF;

--step 9-------------------------------
  BEGIN
    SELECT 1 INTO T_TEMP
      FROM CT_EXT_LOGS
     WHERE EXT_STATUS <> 'SUCCESS'
       AND STUDY = P_STUDY
       AND ROWNUM = 1;

      EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, 'ALL', 'ALL', SYSDATE, 'FAIL', T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, 'ALL', 'ALL', SYSDATE, 'SUCCESS', T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);
  END;
-------------

EXCEPTION
  WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20000,'Error occured in '||T_MOD_NAME||
                '--'||T_STEP_NAME||'--'||SQLCODE||'--'||SQLERRM);
END;


PROCEDURE P_ALL_DCM_FILE
 (P_STUDY             IN VARCHAR2
 ,P_REPORT_TO         IN VARCHAR2
 ,P_VERSION           IN VARCHAR2
 ,P_FILE_ID           IN VARCHAR2
 ,P_DEBUG_MODE        IN VARCHAR2 := 'CONT'
 )
 IS

  T_MOD_NAME           VARCHAR2(60)  := 'EXT_DATA_PKG.P_ALL_DCM_FILE';
  T_STEP_NAME          VARCHAR2(30)  := '1';
  T_PROC_NAME          VARCHAR2(30);
    T_SQL_ERROR_CODE       CT_EXT_ERRORS.SQL_ERROR_CODE%TYPE;
    T_SQL_ERROR_DESC       CT_EXT_ERRORS.SQL_ERROR_DESC%TYPE;
    T_KEY_VALUE            CT_EXT_ERRORS.KEY_VALUE%TYPE;
    T_CT_ERROR_DESC        CT_EXT_ERRORS.CT_ERROR_DESC%TYPE;

    T_LAST_EXT_DATE        DATE;
    T_CURRENT_EXT_DATE     DATE;
    T_EXT_OWNER            VARCHAR2(30);
    T_EXT_SOURCE           VARCHAR2(30);
BEGIN
    T_EXT_SOURCE := 'N';
-----------------------
T_STEP_NAME := '1';
  BEGIN

    SELECT EXT_OBJECT_OWNER INTO T_EXT_OWNER
      FROM CT_EXT_STUDY_CTL
     WHERE OC_STUDY = P_STUDY;

    FOR THIS_FILE IN (SELECT * FROM CT_EXT_FILE_CTL
                       WHERE OC_STUDY = P_STUDY
                         AND REPORT_TO = P_REPORT_TO
                         AND VERSION = P_VERSION
                         AND FILE_ID = NVL(P_FILE_ID, FILE_ID)
                         AND EXT_IND = 'Y'
                       ORDER BY FILE_ID)               LOOP

        T_LAST_EXT_DATE        := EXT_UTIL_PKG.F_LAST_EXT_DATE(P_STUDY, THIS_FILE.FILE_ID);
        T_CURRENT_EXT_DATE     := EXT_UTIL_PKG.F_CURRENT_EXT_DATE(P_STUDY, THIS_FILE.FILE_ID);

        IF THIS_FILE.FILE_ID = 'TX' THEN
           P_TX_CRS(P_STUDY, T_EXT_OWNER, THIS_FILE.FILE_ID, THIS_FILE.REPORT_TO
                       ,THIS_FILE.VERSION, T_CURRENT_EXT_DATE, P_DEBUG_MODE);
           P_FILE_CRS(P_STUDY, T_EXT_OWNER, THIS_FILE.FILE_ID, 'C_COM_DEL', THIS_FILE.REPORT_TO
                       ,THIS_FILE.VERSION, T_CURRENT_EXT_DATE, T_EXT_SOURCE, P_DEBUG_MODE);
           P_FILE_CRS(P_STUDY, T_EXT_OWNER, THIS_FILE.FILE_ID, 'C_COM', THIS_FILE.REPORT_TO
                       ,THIS_FILE.VERSION, T_CURRENT_EXT_DATE, T_EXT_SOURCE, P_DEBUG_MODE);
        ELSE

           P_FILE_CRS(P_STUDY, T_EXT_OWNER, THIS_FILE.FILE_ID, NULL, THIS_FILE.REPORT_TO
                       ,THIS_FILE.VERSION, T_CURRENT_EXT_DATE, T_EXT_SOURCE, P_DEBUG_MODE);

        END IF;

    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
  END;

EXCEPTION
    WHEN OTHERS THEN
        T_SQL_ERROR_CODE    := SQLCODE;
        T_SQL_ERROR_DESC    := SQLERRM;
        T_KEY_VALUE         := NULL;
        T_CT_ERROR_DESC := 'Insert CT_DATA failed @'||T_MOD_NAME||'--'||T_STEP_NAME;
        -- Error handling procedure
        EXT_UTIL_PKG.P_CT_EXT_ERRORS
                    (P_STUDY, 'ALL', T_MOD_NAME, T_STEP_NAME
                    ,T_KEY_VALUE, T_SQL_ERROR_CODE, T_SQL_ERROR_DESC
                    ,T_CT_ERROR_DESC, P_DEBUG_MODE);
END;

PROCEDURE P_ALL_OTH_FILE
 (P_STUDY             IN VARCHAR2
 ,P_REPORT_TO         IN VARCHAR2
 ,P_VERSION           IN VARCHAR2
 ,P_FILE_ID           IN VARCHAR2
 ,P_UL_FLAG           IN VARCHAR2
 ,P_DEBUG_MODE        IN VARCHAR2 := 'CONT'
 )
 IS

  T_MOD_NAME           VARCHAR2(60)  := 'EXT_DATA_PKG.P_ALL_OTH_FILE';
  T_STEP_NAME          VARCHAR2(30)  := '1';
  T_PROC_NAME          VARCHAR2(30);
    T_SQL_ERROR_CODE       CT_EXT_ERRORS.SQL_ERROR_CODE%TYPE;
    T_SQL_ERROR_DESC       CT_EXT_ERRORS.SQL_ERROR_DESC%TYPE;
    T_KEY_VALUE            CT_EXT_ERRORS.KEY_VALUE%TYPE;
    T_CT_ERROR_DESC        CT_EXT_ERRORS.CT_ERROR_DESC%TYPE;

    T_LAST_EXT_DATE        DATE;
    T_CURRENT_EXT_DATE     DATE;
    T_EXT_OWNER            VARCHAR2(30);
    T_EXT_SOURCE           VARCHAR2(30);
BEGIN
    T_EXT_SOURCE := 'O';
-----------------------
T_STEP_NAME := '2';
  BEGIN

    SELECT EXT_OBJECT_OWNER INTO T_EXT_OWNER
      FROM CT_EXT_STUDY_CTL
     WHERE OC_STUDY = P_STUDY;

    FOR THIS_FILE IN (SELECT * FROM CT_EXT_FILE_CTL
                       WHERE OC_STUDY = P_STUDY
                         AND REPORT_TO = P_REPORT_TO
                         AND VERSION = P_VERSION
                         AND FILE_ID = NVL(P_FILE_ID, FILE_ID)
                         AND EXT_IND = 'Y'
                         AND ((P_UL_FLAG = 'Y' AND FILE_ID = 'UL') OR
                              (P_UL_FLAG <> 'Y' AND FILE_ID <> 'UL'))
                       ORDER BY FILE_ID)               LOOP

        T_LAST_EXT_DATE        := EXT_UTIL_PKG.F_LAST_EXT_DATE(P_STUDY, THIS_FILE.FILE_ID);
        T_CURRENT_EXT_DATE     := EXT_UTIL_PKG.F_CURRENT_EXT_DATE(P_STUDY, THIS_FILE.FILE_ID);

        P_OTH_FILE_CRS(P_STUDY, T_EXT_OWNER, THIS_FILE.FILE_ID, THIS_FILE.REPORT_TO
                       ,THIS_FILE.VERSION, T_CURRENT_EXT_DATE, T_EXT_SOURCE, P_DEBUG_MODE);

    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
  END;

EXCEPTION
    WHEN OTHERS THEN
        T_SQL_ERROR_CODE    := SQLCODE;
        T_SQL_ERROR_DESC    := SQLERRM;
        T_KEY_VALUE         := NULL;
        T_CT_ERROR_DESC := 'Insert CT_DATA failed @'||T_MOD_NAME||'--'||T_STEP_NAME;
        -- Error handling procedure
        EXT_UTIL_PKG.P_CT_EXT_ERRORS
                    (P_STUDY, 'ALL', T_MOD_NAME, T_STEP_NAME
                    ,T_KEY_VALUE, T_SQL_ERROR_CODE, T_SQL_ERROR_DESC
                    ,T_CT_ERROR_DESC, P_DEBUG_MODE);
END;

PROCEDURE P_OTH_FILE_CRS
 (P_STUDY             IN VARCHAR2
 ,P_EXT_OWNER         IN VARCHAR2
 ,P_FILE_ID           IN VARCHAR2
 ,P_REPORT_TO         IN VARCHAR2
 ,P_VERSION           IN VARCHAR2
 ,P_CURRENT_EXT_DATE  IN DATE
 ,P_EXT_SOURCE        IN VARCHAR2
 ,P_DEBUG_MODE        IN VARCHAR2 := 'CONT'
 )
 IS

  T_MOD_NAME           VARCHAR2(60)  := 'EXT_DATA_PKG.P_OTH_FILE_CRS';
  T_STEP_NAME          VARCHAR2(30)  := '1';
  T_PROC_NAME          VARCHAR2(30) := ' ';
    T_SQL_ERROR_CODE       CT_EXT_ERRORS.SQL_ERROR_CODE%TYPE;
    T_SQL_ERROR_DESC       CT_EXT_ERRORS.SQL_ERROR_DESC%TYPE;
    T_KEY_VALUE            CT_EXT_ERRORS.KEY_VALUE%TYPE;
    T_CT_ERROR_DESC        CT_EXT_ERRORS.CT_ERROR_DESC%TYPE;

    T_CT_TAB               EXT_DATA_PKG.CT_TAB;
    T_CT_TAB_TX               EXT_DATA_PKG.CT_TAB;
    T_EMPTY_TAB            EXT_DATA_PKG.CT_TAB;
    I                      PLS_INTEGER := 0;

    T_CRS                  LONG;
    T_FILE_ID              VARCHAR2(30) := ' ';
    T_VERSION              VARCHAR2(30);
    T_CURRENT_EXT_DATE_VAR VARCHAR2(8);
    T_EXT_SOURCE           VARCHAR2(30);
    T_EXT_STATUS           VARCHAR2(30);
    T_START_DATE           DATE := SYSDATE;
    T_TAB_EXT_STATUS       VARCHAR2(30);
    T_CRS_TYPE             VARCHAR2(30);
  C_OTH_DEL       CT_CURTYPE;
  C_OTH           CT_CURTYPE;

BEGIN
-----------------------
T_STEP_NAME := '1';          ----normal records STEP 1
BEGIN
  SELECT TEXT, EXT_SOURCE, CRS_TYPE INTO T_CRS, T_EXT_SOURCE, T_CRS_TYPE
    FROM CT_EXT_CRS_CTL
   WHERE OC_STUDY = P_STUDY
     AND REPORT_TO = P_REPORT_TO
     AND VERSION = P_VERSION
     AND FILE_ID = P_FILE_ID
     AND EXT_SOURCE = NVL(P_EXT_SOURCE, EXT_SOURCE)
     AND CRS_TYPE NOT LIKE '%DEL';

  T_CRS := REPLACE(T_CRS, 'PP_EXT_OWNER', P_EXT_OWNER);

  BEGIN
    G_START_DATE := SYSDATE;
    T_EXT_STATUS := 'PROCESSING';
    T_PROC_NAME  := T_CRS_TYPE;

    EXECUTE IMMEDIATE 'TRUNCATE TABLE CT_EXT_TEMP';

    EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, P_FILE_ID, T_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);

    IF P_FILE_ID = 'PH' THEN
      OPEN C_OTH FOR T_CRS USING P_VERSION, P_CURRENT_EXT_DATE, P_FILE_ID
                             ,P_VERSION, P_CURRENT_EXT_DATE, P_FILE_ID, P_EXT_OWNER, P_STUDY, P_STUDY;
    ELSE
      OPEN C_OTH FOR T_CRS USING P_FILE_ID, P_VERSION, P_CURRENT_EXT_DATE
                             ,P_FILE_ID, P_VERSION, P_CURRENT_EXT_DATE, P_EXT_OWNER, P_STUDY, P_STUDY;
    END IF;

    I := 0;  T_CT_TAB := T_EMPTY_TAB;
    LOOP
      I := I + 1;
      FETCH C_OTH INTO T_CT_TAB(I);
      EXIT WHEN C_OTH%NOTFOUND;
    END LOOP;

    CLOSE C_OTH;

    IF I > 1 THEN
      P_EXT_TEMP(T_EXT_SOURCE, T_CT_TAB, P_FILE_ID, P_VERSION, T_PROC_NAME
                ,P_CURRENT_EXT_DATE, T_EXT_STATUS, P_DEBUG_MODE);
    ---------------------
      FOR T_REC IN (SELECT * FROM CT_EXT_TEMP) LOOP
--
-- 09/01/2004 - commented out the following check for duplicated record (if the same record exists
-- in the achieve, ignore it). The same check will take place in p_submission procedure
--
--                IF F_LAB_OTH_UPD(T_REC.FILE_ID, T_REC.PROTOCOL, T_REC.PT, T_REC.PATIENT,
--                                 T_REC.KEY1, T_REC.KEY2, T_REC.KEY3, T_REC.LINE_TEXT) <> 'N'   THEN
                  P_INS_CT_EXT_DATA(
                             P_EXT_SOURCE                     ---- EXT_SOURCE
                            ,T_REC.REC_SEQ                             -- REC_SEQ
                            ,T_REC.FILE_ID                    -- FILE_ID
                            ,T_REC.VERSION                     -- VERSION
                            ,T_REC.EXTRACTED                   -- EXTRACTED
                            ,T_REC.RECEIVED_DCM_ID             -- RECEIVED_DCM_ID
                            ,T_REC.RECEIVED_DCM_ENTRY_TS       -- RECEIVED_DCM_ENTRY_TS
                            ,T_REC.DOCNUM                      -- DOCNUM
                            ,T_REC.DEL_FLAG                    -- DEL_FLAG
                            ,T_REC.PROTOCOL                    -- STUDY
                            ,T_REC.PT                          -- PT
                            ,T_REC.PATIENT                     -- PATIENT
                            ,T_REC.KEY1                        ---- KEY1
                            ,T_REC.KEY2                        ---- KEY2
                            ,T_REC.KEY3                        ---- KEY3
                            ,T_REC.KEY4                        ---- KEY4
                            ,T_REC.KEY5                        ---- KEY5
                            ,T_REC.LINE_TEXT               ---- LINE_TEXT
                            ,P_DEBUG_MODE       );            ---- DEBUG_MODE
--                END IF;
      END LOOP;

    --------------------------
    END IF;

    T_EXT_STATUS := 'SUCCESS';
    EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, P_FILE_ID, T_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);

  EXCEPTION
    WHEN OTHERS THEN
      IF C_OTH%ISOPEN THEN
          CLOSE C_OTH;
      END IF;
      RAISE;
  END;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
      NULL;
  WHEN OTHERS THEN
--DBMS_OUTPUT.PUT_LINE(T_STEP_NAME||'-'||SQLERRM);
      RAISE;
END;
----------------------
T_STEP_NAME := '2';          ----DEL_FLAG records----
BEGIN

  SELECT TEXT, EXT_SOURCE, CRS_TYPE INTO T_CRS, T_EXT_SOURCE, T_CRS_TYPE
    FROM CT_EXT_CRS_CTL
   WHERE OC_STUDY = P_STUDY
     AND REPORT_TO = P_REPORT_TO
     AND VERSION = P_VERSION
     AND FILE_ID = P_FILE_ID
     AND EXT_SOURCE = NVL(P_EXT_SOURCE, EXT_SOURCE)
     AND CRS_TYPE LIKE '%DEL';

  T_CRS := REPLACE(T_CRS, 'PP_EXT_OWNER', P_EXT_OWNER);

  BEGIN
    G_START_DATE := SYSDATE;
    T_EXT_STATUS := 'PROCESSING';
    T_PROC_NAME  := T_CRS_TYPE;
    EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, P_FILE_ID, T_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);

    IF P_FILE_ID = 'PH' THEN
      OPEN C_OTH_DEL FOR T_CRS USING P_VERSION, P_CURRENT_EXT_DATE, P_FILE_ID
                                 ,P_VERSION, P_FILE_ID, P_FILE_ID, P_STUDY, P_STUDY;
    ELSE
      OPEN C_OTH_DEL FOR T_CRS USING P_FILE_ID, P_VERSION, P_CURRENT_EXT_DATE
                                 ,P_FILE_ID, P_VERSION, P_FILE_ID, P_STUDY;
    END IF;

    I := 0;  T_CT_TAB := T_EMPTY_TAB;
    LOOP
      I := I + 1;
      FETCH C_OTH_DEL INTO T_CT_TAB(I);
      EXIT WHEN C_OTH_DEL%NOTFOUND;
    END LOOP;
    CLOSE C_OTH_DEL;
    IF I > 1 THEN
      P_EXT_DATA(T_EXT_SOURCE, T_CT_TAB, P_FILE_ID, P_VERSION, T_PROC_NAME
                ,P_CURRENT_EXT_DATE, T_EXT_STATUS, P_DEBUG_MODE);
    ELSE
      T_EXT_STATUS := 'SUCCESS';
      EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, P_FILE_ID, T_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      IF C_OTH_DEL%ISOPEN THEN
          CLOSE C_OTH_DEL;
      END IF;
      RAISE;
  END;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
      NULL;
  WHEN OTHERS THEN
--DBMS_OUTPUT.PUT_LINE(T_STEP_NAME||'-'||SQLERRM);
      RAISE;
END;
-----------------------
EXCEPTION
    WHEN OTHERS THEN
        T_EXT_STATUS := 'FAIL';
        T_SQL_ERROR_CODE    := SQLCODE;
        T_SQL_ERROR_DESC    := SQLERRM;
        T_KEY_VALUE         := NULL;
        T_CT_ERROR_DESC := 'Insert CT_DATA failed @'||T_MOD_NAME||'--'||T_STEP_NAME||'--'||T_FILE_ID;
        -- Error handling procedure
        EXT_UTIL_PKG.P_CT_EXT_LOGS
             (P_STUDY, P_FILE_ID, T_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);
        EXT_UTIL_PKG.P_CT_EXT_ERRORS
                    (P_STUDY, P_FILE_ID, T_MOD_NAME, T_STEP_NAME
                    ,T_KEY_VALUE, T_SQL_ERROR_CODE, T_SQL_ERROR_DESC
                    ,T_CT_ERROR_DESC, P_DEBUG_MODE);
END;


PROCEDURE P_ONE_CRS
 (P_CRS               IN LONG
 ,P_CRS_TYPE          IN VARCHAR2
 ,P_STUDY             IN VARCHAR2
 ,P_FILE_ID           IN VARCHAR2
 ,P_VERSION           IN VARCHAR2
 ,P_CURRENT_EXT_DATE  IN DATE
 ,P_EXT_OWNER         IN VARCHAR2
 ,P_EXT_SOURCE        IN VARCHAR2
 ,P_EXT_STATUS        IN OUT VARCHAR2
 ,P_DEBUG_MODE        IN VARCHAR2 := 'CONT'
 )
 IS

  T_MOD_NAME           VARCHAR2(60)  := 'EXT_DATA_PKG.P_ONE_CRS';
  T_STEP_NAME          VARCHAR2(30)  := '1';
  T_PROC_NAME          VARCHAR2(30);
    T_SQL_ERROR_CODE       CT_EXT_ERRORS.SQL_ERROR_CODE%TYPE;
    T_SQL_ERROR_DESC       CT_EXT_ERRORS.SQL_ERROR_DESC%TYPE;
    T_KEY_VALUE            CT_EXT_ERRORS.KEY_VALUE%TYPE;
    T_CT_ERROR_DESC        CT_EXT_ERRORS.CT_ERROR_DESC%TYPE;
    T_START_DATE           DATE := SYSDATE;
    T_EXT_STATUS           CT_EXT_LOGS.EXT_STATUS%TYPE;
    T_TAB_EXT_STATUS       VARCHAR2(30);
    T_CURRENT_EXT_DATE_VAR VARCHAR2(8);
    T_CT_TAB               EXT_DATA_PKG.CT_TAB;
    T_EMPTY_TAB            EXT_DATA_PKG.CT_TAB;
    I                      PLS_INTEGER := 0;

  T_CT_CUR      CT_CURTYPE;

BEGIN
-----------------------
T_STEP_NAME := '1';          ----process a cursor----
  BEGIN
    G_START_DATE := SYSDATE;
    T_EXT_STATUS := 'PROCESSING';
    T_PROC_NAME  := P_CRS_TYPE;
    EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, P_FILE_ID, T_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);
    IF P_CRS_TYPE = 'NORMAL' THEN
      IF P_FILE_ID IN ('BS','CI','DS','DT','EC','EN','FO','FP','LS','MH','PH','PR','PS','PT','TF') THEN
        OPEN T_CT_CUR FOR P_CRS USING P_FILE_ID, P_VERSION, P_CURRENT_EXT_DATE,
                                      P_FILE_ID, P_VERSION, P_CURRENT_EXT_DATE,
                                      P_STUDY, P_FILE_ID, P_STUDY, P_FILE_ID, P_STUDY;
      ELSE
        OPEN T_CT_CUR FOR P_CRS USING P_FILE_ID, P_VERSION, P_CURRENT_EXT_DATE,
                                      P_FILE_ID, P_VERSION, P_CURRENT_EXT_DATE,
                                      P_EXT_OWNER, P_STUDY, P_FILE_ID, P_STUDY, P_FILE_ID, P_STUDY;
      END IF;
    ELSIF P_CRS_TYPE = 'NORMAL_DEL' THEN
        OPEN T_CT_CUR FOR P_CRS USING P_FILE_ID, P_VERSION, P_CURRENT_EXT_DATE,
                                      P_FILE_ID, P_VERSION, P_FILE_ID, P_STUDY;

    ELSIF P_CRS_TYPE = 'COM' THEN
      IF P_FILE_ID IN ('PH') THEN
        OPEN T_CT_CUR FOR P_CRS USING P_VERSION, P_CURRENT_EXT_DATE,
                                      P_FILE_ID, P_VERSION, P_CURRENT_EXT_DATE,
                                      P_EXT_OWNER, P_STUDY, P_FILE_ID, P_STUDY, P_FILE_ID, P_STUDY;
      ELSE
        OPEN T_CT_CUR FOR P_CRS USING P_VERSION, P_CURRENT_EXT_DATE,
                                      P_FILE_ID, P_VERSION, P_CURRENT_EXT_DATE,
                                      P_FILE_ID, P_EXT_OWNER, P_STUDY, P_FILE_ID, P_STUDY, P_FILE_ID, P_STUDY;
      END IF;
    ELSIF P_CRS_TYPE = 'COM_DEL' THEN
        OPEN T_CT_CUR FOR P_CRS USING P_VERSION, P_CURRENT_EXT_DATE,
                                      P_FILE_ID, P_VERSION, P_FILE_ID, P_FILE_ID, P_STUDY;
    ELSE
      NULL;
    END IF;

    I := 0;  T_CT_TAB := T_EMPTY_TAB;
    LOOP
      I := I + 1;
      FETCH T_CT_CUR INTO T_CT_TAB(I);
      EXIT WHEN T_CT_CUR%NOTFOUND;
    END LOOP;
    CLOSE T_CT_CUR;
    IF I > 1 THEN
      P_EXT_DATA(P_EXT_SOURCE, T_CT_TAB, P_FILE_ID, P_VERSION, T_PROC_NAME
                ,P_CURRENT_EXT_DATE, P_EXT_STATUS, P_DEBUG_MODE);
    ELSE
      T_EXT_STATUS := 'SUCCESS';
      EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, P_FILE_ID, T_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      IF T_CT_CUR%ISOPEN THEN
          CLOSE T_CT_CUR;
      END IF;
      RAISE;
  END;
-----------------------
  P_EXT_STATUS := 'SUCCESS';
EXCEPTION
    WHEN OTHERS THEN
        T_EXT_STATUS := 'FAIL';
        P_EXT_STATUS := 'FAIL';
        T_SQL_ERROR_CODE    := SQLCODE;
        T_SQL_ERROR_DESC    := SQLERRM;
        T_KEY_VALUE         := NULL;
        T_CT_ERROR_DESC := 'Insert CT_DATA failed @'||T_MOD_NAME||'--'||T_STEP_NAME||'--'||P_FILE_ID;
        -- Error handling procedure
        EXT_UTIL_PKG.P_CT_EXT_LOGS
             (P_STUDY, P_FILE_ID, T_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);
        EXT_UTIL_PKG.P_CT_EXT_ERRORS
                    (P_STUDY, P_FILE_ID, T_MOD_NAME, T_STEP_NAME
                    ,T_KEY_VALUE, T_SQL_ERROR_CODE, T_SQL_ERROR_DESC
                    ,T_CT_ERROR_DESC, P_DEBUG_MODE);
END;

PROCEDURE P_FILE_CRS
 (P_STUDY             IN VARCHAR2
 ,P_EXT_OWNER         IN VARCHAR2
 ,P_FILE_ID           IN VARCHAR2
 ,P_CRS_NAME          IN VARCHAR2
 ,P_REPORT_TO         IN VARCHAR2
 ,P_VERSION           IN VARCHAR2
 ,P_CURRENT_EXT_DATE  IN DATE
 ,P_EXT_SOURCE        IN VARCHAR2
 ,P_DEBUG_MODE        IN VARCHAR2 := 'CONT'
 )
 IS

  T_MOD_NAME           VARCHAR2(60)  := 'EXT_DATA_PKG.P_FILE_CRS';
  T_STEP_NAME          VARCHAR2(30)  := '1';
  T_PROC_NAME          VARCHAR2(30);
    T_SQL_ERROR_CODE       CT_EXT_ERRORS.SQL_ERROR_CODE%TYPE;
    T_SQL_ERROR_DESC       CT_EXT_ERRORS.SQL_ERROR_DESC%TYPE;
    T_KEY_VALUE            CT_EXT_ERRORS.KEY_VALUE%TYPE;
    T_CT_ERROR_DESC        CT_EXT_ERRORS.CT_ERROR_DESC%TYPE;

    T_CT_TAB               EXT_DATA_PKG.CT_TAB;
    T_EMPTY_TAB            EXT_DATA_PKG.CT_TAB;
    I                      PLS_INTEGER := 0;

    T_CRS                  LONG;
    T_CRS_TYPE             VARCHAR2(30);
    T_FILE_ID              VARCHAR2(30);

    T_CURRENT_EXT_DATE_VAR VARCHAR2(8);
    T_EXT_SOURCE           VARCHAR2(30);
    T_EXT_STATUS           VARCHAR2(30);
    T_START_DATE           DATE := SYSDATE;
    T_TAB_EXT_STATUS       VARCHAR2(30);

  T_CT_CUR      CT_CURTYPE;

BEGIN

-----------------------
T_STEP_NAME := '1';

    FOR THIS_CRS IN (SELECT * FROM CT_EXT_CRS_CTL
                   WHERE OC_STUDY = P_STUDY
                     AND REPORT_TO = P_REPORT_TO
                     AND VERSION = P_VERSION
                     AND FILE_ID = P_FILE_ID
                     AND CRS_NAME = NVL(P_CRS_NAME, CRS_NAME)
                     AND EXT_SOURCE = NVL(P_EXT_SOURCE, EXT_SOURCE)
                ORDER BY EXT_SEQ     )     LOOP
      T_CURRENT_EXT_DATE_VAR := TO_CHAR(P_CURRENT_EXT_DATE, 'RRRRMMDD');
      T_CRS_TYPE  := THIS_CRS.CRS_TYPE;
      T_PROC_NAME  := THIS_CRS.CRS_TYPE;
      T_EXT_SOURCE := THIS_CRS.EXT_SOURCE;
      T_EXT_STATUS := 'PROCESSING';

      T_CRS := THIS_CRS.TEXT;
      T_CRS := REPLACE(THIS_CRS.TEXT, 'PP_EXT_OWNER', P_EXT_OWNER);

      P_ONE_CRS(T_CRS, T_CRS_TYPE, P_STUDY, P_FILE_ID, P_VERSION, P_CURRENT_EXT_DATE
               ,P_EXT_OWNER, T_EXT_SOURCE, T_EXT_STATUS, P_DEBUG_MODE);

    END LOOP;

-----------------------

EXCEPTION
    WHEN OTHERS THEN
        T_EXT_STATUS := 'FAIL';
        T_SQL_ERROR_CODE    := SQLCODE;
        T_SQL_ERROR_DESC    := SQLERRM;
        T_KEY_VALUE         := NULL;
        T_CT_ERROR_DESC := 'Insert CT_DATA failed @'||T_MOD_NAME||'--'||T_STEP_NAME||'--'||T_FILE_ID;
        -- Error handling procedure
        EXT_UTIL_PKG.P_CT_EXT_LOGS
             (P_STUDY, P_FILE_ID, T_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);
        EXT_UTIL_PKG.P_CT_EXT_ERRORS
                    (P_STUDY, P_FILE_ID, T_MOD_NAME, T_STEP_NAME
                    ,T_KEY_VALUE, T_SQL_ERROR_CODE, T_SQL_ERROR_DESC
                    ,T_CT_ERROR_DESC, P_DEBUG_MODE);
END;

PROCEDURE P_INS_CRS_AE
 (P_CT_TAB                      IN OUT EXT_DATA_PKG.CT_TAB
 ,P_COUNT                       IN OUT NUMBER
 ,P_EXT_OWNER                   IN VARCHAR2
 ,P_DEBUG_MODE                  IN VARCHAR2 := 'CONT'
 )
 IS
  T_MOD_NAME           VARCHAR2(60)  := 'EXT_DATA_PKG.P_INS_CRS_AE';
  T_STEP_NAME          VARCHAR2(30)   := '1';
  T_COURSE_NUM         VARCHAR2(8);
  T_START_DT           VARCHAR2(8);
  T_LINE_TEXT          VARCHAR2(2400);
  T_LAST_COURSE_START_DT   VARCHAR2(30) := NULL;
  I                    NUMBER := 0;

  T_CT_CUR1      CT_CURTYPE;
  T_CT_CUR2      CT_CURTYPE;
  T_GC_LAST_COURSE_START_DT         LONG;
  T_GC_COURSE_DT_NUM                LONG;
BEGIN
  SELECT TEXT INTO T_GC_LAST_COURSE_START_DT
    FROM CT_EXT_CRS_CTL
   WHERE CRS_NAME = 'GC_LAST_COURSE_START_DT'
     AND FILE_ID = 'TX';

  T_GC_LAST_COURSE_START_DT := REPLACE(T_GC_LAST_COURSE_START_DT, 'PP_EXT_OWNER', P_EXT_OWNER);

  BEGIN
    OPEN T_CT_CUR1 FOR T_GC_LAST_COURSE_START_DT USING P_CT_TAB(P_COUNT).PROTOCOL, P_CT_TAB(P_COUNT).PT,
                                 TRIM(P_CT_TAB(P_COUNT).KEY3) ;
    FETCH T_CT_CUR1 INTO T_LAST_COURSE_START_DT;
    CLOSE T_CT_CUR1;
    IF T_LAST_COURSE_START_DT IS NULL THEN
      RETURN;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      IF T_CT_CUR1%ISOPEN THEN
        CLOSE T_CT_CUR1;
      END IF;
      RAISE;
  END;

  SELECT TEXT INTO T_GC_COURSE_DT_NUM
    FROM CT_EXT_CRS_CTL
   WHERE CRS_NAME = 'GC_COURSE_DT_NUM'
     AND FILE_ID = 'TX';

  T_GC_COURSE_DT_NUM := REPLACE(T_GC_COURSE_DT_NUM, 'PP_EXT_OWNER', P_EXT_OWNER);

  OPEN T_CT_CUR2 FOR T_GC_COURSE_DT_NUM USING P_CT_TAB(P_COUNT).PROTOCOL, P_CT_TAB(P_COUNT).PT,
                        TRIM(P_CT_TAB(P_COUNT).KEY5), T_LAST_COURSE_START_DT,
                        TRIM(P_CT_TAB(P_COUNT).KEY5), T_LAST_COURSE_START_DT, T_LAST_COURSE_START_DT,
                        TRIM(P_CT_TAB(P_COUNT).KEY4) ;
  LOOP
    FETCH T_CT_CUR2 INTO T_COURSE_NUM, T_START_DT;
    EXIT WHEN T_CT_CUR2%NOTFOUND;
       IF I = 0 THEN
         I := P_COUNT;
       ELSE
         I := I + 1;
       END IF;
           P_CT_TAB(I).FILE_ID     := P_CT_TAB(P_COUNT).FILE_ID;
           P_CT_TAB(I).VERSION     := P_CT_TAB(P_COUNT).VERSION;
           P_CT_TAB(I).EXTRACTED   := P_CT_TAB(P_COUNT).EXTRACTED;
           P_CT_TAB(I).RECEIVED_DCM_ID       := P_CT_TAB(P_COUNT).RECEIVED_DCM_ID;
           P_CT_TAB(I).RECEIVED_DCM_ENTRY_TS := P_CT_TAB(P_COUNT).RECEIVED_DCM_ENTRY_TS;
           P_CT_TAB(I).DOCNUM      := P_CT_TAB(P_COUNT).DOCNUM;
           P_CT_TAB(I).DEL_FLAG    := P_CT_TAB(P_COUNT).DEL_FLAG;
           P_CT_TAB(I).PROTOCOL    := P_CT_TAB(P_COUNT).PROTOCOL;
           P_CT_TAB(I).PT          := P_CT_TAB(P_COUNT).PT;
           P_CT_TAB(I).PATIENT     := P_CT_TAB(P_COUNT).PATIENT;
           P_CT_TAB(I).KEY1        := T_START_DT;
           P_CT_TAB(I).KEY2        := P_CT_TAB(P_COUNT).KEY2;
           P_CT_TAB(I).KEY3        := P_CT_TAB(P_COUNT).KEY3;
--           P_CT_TAB(I).KEY4        := P_CT_TAB(P_COUNT).KEY4;
           P_CT_TAB(I).KEY4        := NULL;
           P_CT_TAB(I).KEY5        := NULL; -- P_CT_TAB(P_COUNT).KEY5;
           P_CT_TAB(I).LINE_TEXT   := SUBSTR(P_CT_TAB(P_COUNT).LINE_TEXT, 1, 91)||T_COURSE_NUM||
                                      SUBSTR(P_CT_TAB(P_COUNT).LINE_TEXT, 95, 12)||T_START_DT||
                                      SUBSTR(P_CT_TAB(P_COUNT).LINE_TEXT, 115);
  END LOOP;
  CLOSE T_CT_CUR2;

  P_COUNT := I;

EXCEPTION
  WHEN OTHERS THEN
      IF T_CT_CUR2%ISOPEN THEN
          CLOSE T_CT_CUR2;
      END IF;
      RAISE_APPLICATION_ERROR(-20000,'Error occured in '||T_MOD_NAME||
                '--'||T_STEP_NAME||'--'||SQLCODE||'--'||SQLERRM);
END;

PROCEDURE P_TX_CRS
 (P_STUDY             IN VARCHAR2
 ,P_EXT_OWNER         IN VARCHAR2
 ,P_FILE_ID           IN VARCHAR2
 ,P_REPORT_TO         IN VARCHAR2
 ,P_VERSION           IN VARCHAR2
 ,P_CURRENT_EXT_DATE  IN DATE
 ,P_DEBUG_MODE        IN VARCHAR2 := 'CONT'
 )
 IS

  T_MOD_NAME           VARCHAR2(60)  := 'EXT_DATA_PKG.P_TX_CRS';
  T_STEP_NAME          VARCHAR2(30)  := '1';
  T_PROC_NAME          VARCHAR2(30);
    T_SQL_ERROR_CODE       CT_EXT_ERRORS.SQL_ERROR_CODE%TYPE;
    T_SQL_ERROR_DESC       CT_EXT_ERRORS.SQL_ERROR_DESC%TYPE;
    T_KEY_VALUE            CT_EXT_ERRORS.KEY_VALUE%TYPE;
    T_CT_ERROR_DESC        CT_EXT_ERRORS.CT_ERROR_DESC%TYPE;

    T_CT_TAB               EXT_DATA_PKG.CT_TAB;
    T_CT_TAB_TX               EXT_DATA_PKG.CT_TAB;
    T_EMPTY_TAB            EXT_DATA_PKG.CT_TAB;
    I                      PLS_INTEGER := 0;

    T_CRS                  LONG;
    T_FILE_ID              VARCHAR2(30);
    T_VERSION              VARCHAR2(30);
    T_CURRENT_EXT_DATE_VAR VARCHAR2(8);
    T_EXT_SOURCE           VARCHAR2(30);
    T_EXT_STATUS           VARCHAR2(30);
    T_START_DATE           DATE := SYSDATE;
    T_TAB_EXT_STATUS       VARCHAR2(30);

  C_TX_TEMP      CT_CURTYPE;
  C_TX_DEL       CT_CURTYPE;
  C_TX           CT_CURTYPE;

BEGIN
-----------------------
T_STEP_NAME := '2.1';          ----DEL_FLAG, step 1(normal records)
BEGIN
  SELECT TEXT, EXT_SOURCE INTO T_CRS, T_EXT_SOURCE
    FROM CT_EXT_CRS_CTL
   WHERE OC_STUDY = P_STUDY
     AND REPORT_TO = P_REPORT_TO
     AND VERSION = P_VERSION
     AND CRS_NAME = 'C_TX_TEMP';

  T_CRS := REPLACE(T_CRS, 'PP_EXT_OWNER', P_EXT_OWNER);

  BEGIN
    G_START_DATE := SYSDATE;
    T_EXT_STATUS := 'PROCESSING';
    T_PROC_NAME  := 'TEMP';

    EXECUTE IMMEDIATE 'TRUNCATE TABLE CT_EXT_TEMP';

    EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, P_FILE_ID, T_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);

    OPEN C_TX_TEMP FOR T_CRS USING P_FILE_ID, P_VERSION, P_CURRENT_EXT_DATE
                             ,P_FILE_ID, P_VERSION, P_CURRENT_EXT_DATE, P_STUDY;
    I := 0;  T_CT_TAB := T_EMPTY_TAB;
    LOOP
      I := I + 1;
      FETCH C_TX_TEMP INTO T_CT_TAB(I);
      EXIT WHEN C_TX_TEMP%NOTFOUND;

      P_INS_CRS_AE(T_CT_TAB, I, P_EXT_OWNER, P_DEBUG_MODE);

    END LOOP;

    CLOSE C_TX_TEMP;

    IF I > 1 THEN
      P_EXT_TEMP(T_EXT_SOURCE, T_CT_TAB, P_FILE_ID, P_VERSION, T_PROC_NAME
                ,P_CURRENT_EXT_DATE, T_EXT_STATUS, P_DEBUG_MODE);
    ELSE
      T_EXT_STATUS := 'SUCCESS';
      EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, P_FILE_ID, T_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      IF C_TX_TEMP%ISOPEN THEN
          CLOSE C_TX_TEMP;
      END IF;
      RAISE;
  END;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
      NULL;
  WHEN OTHERS THEN
      RAISE;
END;

---------------------
T_STEP_NAME := '2.2';          ----DEL_FLAG records----
BEGIN
  SELECT TEXT INTO T_CRS
    FROM CT_EXT_CRS_CTL
   WHERE OC_STUDY = P_STUDY
     AND REPORT_TO = P_REPORT_TO
     AND VERSION = P_VERSION
     AND CRS_NAME = 'C_TX_DEL';

  T_CRS := REPLACE(T_CRS, 'PP_EXT_OWNER', P_EXT_OWNER);

  BEGIN
    G_START_DATE := SYSDATE;
    T_EXT_STATUS := 'PROCESSING';
    T_PROC_NAME  := 'DEL_FLAG';
    EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, P_FILE_ID, T_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);

    OPEN C_TX_DEL FOR T_CRS USING P_FILE_ID, P_VERSION, P_CURRENT_EXT_DATE
                                 ,P_FILE_ID, P_VERSION, P_FILE_ID, P_STUDY, P_STUDY;
    I := 0;  T_CT_TAB := T_EMPTY_TAB;
    LOOP
      I := I + 1;
      FETCH C_TX_DEL INTO T_CT_TAB(I);
      EXIT WHEN C_TX_DEL%NOTFOUND;
    END LOOP;
    CLOSE C_TX_DEL;
    IF I > 1 THEN
      P_EXT_DATA(T_EXT_SOURCE, T_CT_TAB, P_FILE_ID, P_VERSION, T_PROC_NAME
                ,P_CURRENT_EXT_DATE, T_EXT_STATUS, P_DEBUG_MODE);
    ELSE
      T_EXT_STATUS := 'SUCCESS';
      EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, P_FILE_ID, T_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      IF C_TX_DEL%ISOPEN THEN
          CLOSE C_TX_DEL;
      END IF;
      RAISE;
  END;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
      NULL;
  WHEN OTHERS THEN
      RAISE;
END;
-----------------------
-----------------------
T_STEP_NAME := '3';          ----normal records
BEGIN
  SELECT TEXT, EXT_SOURCE INTO T_CRS, T_EXT_SOURCE
    FROM CT_EXT_CRS_CTL
   WHERE OC_STUDY = P_STUDY
     AND REPORT_TO = P_REPORT_TO
     AND VERSION = P_VERSION
     AND CRS_NAME = 'C_TX';

  T_CRS := REPLACE(T_CRS, 'PP_EXT_OWNER', P_EXT_OWNER);
T_STEP_NAME := '3.1';          ----normal records
  BEGIN
    G_START_DATE := SYSDATE;
    T_EXT_STATUS := 'PROCESSING';
    T_PROC_NAME  := 'NORMAL';

    EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, P_FILE_ID, T_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);
T_STEP_NAME := '3.1.1';          ----normal records
    OPEN C_TX FOR T_CRS USING P_FILE_ID, P_VERSION, P_CURRENT_EXT_DATE
                             ,P_FILE_ID, P_VERSION, P_CURRENT_EXT_DATE
                             ,P_STUDY, P_FILE_ID, P_STUDY, P_FILE_ID, P_STUDY;
    I := 0;  T_CT_TAB := T_EMPTY_TAB;
T_STEP_NAME := '3.2';          ----normal records
    LOOP
      I := I + 1;
T_STEP_NAME := '3.3.'||I;          ----normal records
      FETCH C_TX INTO T_CT_TAB(I);
      EXIT WHEN C_TX%NOTFOUND;

      P_INS_CRS_AE(T_CT_TAB, I, P_EXT_OWNER, P_DEBUG_MODE);

    END LOOP;
T_STEP_NAME := '3.4';          ----normal records

    CLOSE C_TX;
  -----------
  -----------
    I := 0;
    IF NVL(T_CT_TAB.LAST, 0) <> 0 THEN
      FOR I_TX IN T_CT_TAB.FIRST..T_CT_TAB.LAST LOOP
        IF F_CT_DATA_TX_EXIST(T_CT_TAB(I_TX).FILE_ID, T_CT_TAB(I_TX).PROTOCOL,
                              T_CT_TAB(I_TX).PT, T_CT_TAB(I_TX).PATIENT,
                              T_CT_TAB(I_TX).KEY1,T_CT_TAB(I_TX).KEY2,T_CT_TAB(I_TX).KEY3,
                              T_CT_TAB(I_TX).LINE_TEXT) = 'N'
        THEN
           I := I + 1;
           T_CT_TAB_TX(I).FILE_ID     := T_CT_TAB(I_TX).FILE_ID;
           T_CT_TAB_TX(I).VERSION     := T_CT_TAB(I_TX).VERSION;
           T_CT_TAB_TX(I).EXTRACTED   := T_CT_TAB(I_TX).EXTRACTED;
           T_CT_TAB_TX(I).RECEIVED_DCM_ID       := T_CT_TAB(I_TX).RECEIVED_DCM_ID;
           T_CT_TAB_TX(I).RECEIVED_DCM_ENTRY_TS := T_CT_TAB(I_TX).RECEIVED_DCM_ENTRY_TS;
           T_CT_TAB_TX(I).DOCNUM      := T_CT_TAB(I_TX).DOCNUM;
           T_CT_TAB_TX(I).DEL_FLAG    := T_CT_TAB(I_TX).DEL_FLAG;
           T_CT_TAB_TX(I).PROTOCOL    := T_CT_TAB(I_TX).PROTOCOL;
           T_CT_TAB_TX(I).PT          := T_CT_TAB(I_TX).PT;
           T_CT_TAB_TX(I).PATIENT     := T_CT_TAB(I_TX).PATIENT;
           T_CT_TAB_TX(I).KEY1        := T_CT_TAB(I_TX).KEY1;
           T_CT_TAB_TX(I).KEY2        := T_CT_TAB(I_TX).KEY2;
           T_CT_TAB_TX(I).KEY3        := T_CT_TAB(I_TX).KEY3;
           T_CT_TAB_TX(I).KEY4        := T_CT_TAB(I_TX).KEY4;
           T_CT_TAB_TX(I).KEY5        := T_CT_TAB(I_TX).KEY5;
           T_CT_TAB_TX(I).LINE_TEXT   := T_CT_TAB(I_TX).LINE_TEXT;
        END IF;
      END LOOP;
    END IF;
  -----------
  -----------
    IF I > 0 THEN
      P_EXT_DATA(T_EXT_SOURCE, T_CT_TAB_TX, P_FILE_ID, P_VERSION, T_PROC_NAME
                ,P_CURRENT_EXT_DATE, T_EXT_STATUS, P_DEBUG_MODE);
    ELSE
      T_EXT_STATUS := 'SUCCESS';
      EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, P_FILE_ID, T_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);
T_STEP_NAME := '3.9';
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      IF C_TX%ISOPEN THEN
          CLOSE C_TX;
      END IF;
      RAISE;
  END;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
      NULL;
  WHEN OTHERS THEN
      RAISE;
END;
-----------------------
EXCEPTION
    WHEN OTHERS THEN
        T_EXT_STATUS := 'FAIL';
        T_SQL_ERROR_CODE    := SQLCODE;
        T_SQL_ERROR_DESC    := SQLERRM;
        T_KEY_VALUE         := NULL;
        T_CT_ERROR_DESC := 'Insert CT_DATA failed @'||T_MOD_NAME||'--'||T_STEP_NAME||'--'||T_FILE_ID;
        -- Error handling procedure
        EXT_UTIL_PKG.P_CT_EXT_LOGS
             (P_STUDY, P_FILE_ID, T_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);
        EXT_UTIL_PKG.P_CT_EXT_ERRORS
                    (P_STUDY, P_FILE_ID, T_MOD_NAME, T_STEP_NAME
                    ,T_KEY_VALUE, T_SQL_ERROR_CODE, T_SQL_ERROR_DESC
                    ,T_CT_ERROR_DESC, P_DEBUG_MODE);
END;

PROCEDURE P_STUDY_NAME
 (P_STUDY       IN VARCHAR2
 ,P_REPORT_AS   IN VARCHAR2
 ,P_DEBUG_MODE  IN VARCHAR2 := 'CONT'
 )
 IS
  T_EXT_STUDY    VARCHAR2(12) := NULL;
  T_START_POS    NUMBER := 56;
BEGIN

    IF P_REPORT_AS IS NULL THEN
        T_EXT_STUDY := RPAD(' ', 12, ' ');
    ELSE
        T_EXT_STUDY := RPAD(P_REPORT_AS, 12, ' ');
    END IF;

    UPDATE CT_EXT_DATA NOLOGGING
       SET LINE_TEXT = SUBSTR(LINE_TEXT, 1, T_START_POS - 1)||T_EXT_STUDY||SUBSTR(LINE_TEXT,T_START_POS + 12)
     WHERE PROTOCOL = P_STUDY;

    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;

FUNCTION F_STUDY_RPT_AS
 (P_STUDY      IN VARCHAR2
 ,P_REPORT_TO  IN VARCHAR2
 )
 RETURN VARCHAR2
 IS
  T_EXT_STUDY       VARCHAR2(30) := ' ';
BEGIN
  SELECT REPORT_AS INTO T_EXT_STUDY
    FROM CT_EXT_STUDY_RPT_CTL
   WHERE OC_STUDY = TRIM(P_STUDY)
     AND REPORT_TO = P_REPORT_TO
     AND ROWNUM = 1;

  RETURN (T_EXT_STUDY);

EXCEPTION
  WHEN NO_DATA_FOUND  THEN
    RAISE_APPLICATION_ERROR(-20000, 'No data found in CT_EXT_STUDY_RPT_CTL');
  WHEN OTHERS THEN
    RAISE;
END;

FUNCTION F_EXT_OWNER
 (P_STUDY      IN VARCHAR2
 )
 RETURN VARCHAR2
 IS
  T_EXT_OWNER       VARCHAR2(30) := NULL;
BEGIN
  SELECT EXT_OBJECT_OWNER INTO T_EXT_OWNER
    FROM CT_EXT_STUDY_CTL
   WHERE OC_STUDY = TRIM(P_STUDY)
     AND ROWNUM = 1;

  RETURN (T_EXT_OWNER);

EXCEPTION
  WHEN NO_DATA_FOUND  THEN
    RAISE_APPLICATION_ERROR(-20000, 'No data found in CT_STUDY_REPORTING');
  WHEN OTHERS THEN
    RAISE;
END;

PROCEDURE P_SUBMISSION
 (P_STUDY        IN VARCHAR2
 ,P_REPORT_AS    IN VARCHAR2
 ,P_DEBUG_MODE   IN VARCHAR2 := 'CONT'
 )
 IS

  T_MOD_NAME           VARCHAR2(60)  := 'EXT_DATA_PKG.P_SUBMISSION';
  T_STEP_NAME          VARCHAR2(30)  := '1';
  T_PROC_NAME          VARCHAR2(30);
  T_FILE_ID            VARCHAR2(30) :='ALL';
  T_VERSION            VARCHAR2(4);
  T_INST_ID            VARCHAR2(8);
    T_SQL_ERROR_CODE       CT_EXT_ERRORS.SQL_ERROR_CODE%TYPE;
    T_SQL_ERROR_DESC       CT_EXT_ERRORS.SQL_ERROR_DESC%TYPE;
    T_KEY_VALUE            CT_EXT_ERRORS.KEY_VALUE%TYPE;
    T_CT_ERROR_DESC        CT_EXT_ERRORS.CT_ERROR_DESC%TYPE;
    T_START_DATE           DATE := SYSDATE;
    T_EXT_STATUS           CT_EXT_LOGS.EXT_STATUS%TYPE;
    T_TAB_EXT_STATUS       VARCHAR2(30);
    T_LAST_EXT_DATE        DATE;
    T_CURRENT_EXT_DATE     DATE;
    T_CURRENT_EXT_DATE_VAR VARCHAR2(8);
    T_CT_TAB               EXT_DATA_PKG.CT_TAB;
    T_EMPTY_TAB            EXT_DATA_PKG.CT_TAB;
    I                      PLS_INTEGER := 0;
    T_EXT_OWNER            VARCHAR2(30);
    T_SQL_STR              VARCHAR2(2000);
    v_dup_count            NUMBER;
    hold_temp              NUMBER;       -- prc 01/24/05 : MissingUpdate Fix
    hold_max_change        VARCHAR2(30); -- prc 01/13/05 : MissingUpdate Fix
    hold_max_created       VARCHAR2(30); -- prc 01/13/05 : DeleteDate Fix
BEGIN
-----------------------
T_STEP_NAME := '0';
    T_CURRENT_EXT_DATE     := EXT_UTIL_PKG.F_CURRENT_EXT_DATE(P_STUDY, T_FILE_ID);
    T_EXT_OWNER := F_EXT_OWNER(P_STUDY);
-----------------------
T_STEP_NAME := '2';          ----delete null lab records
    P_DELETE_ALL_2(P_STUDY, P_DEBUG_MODE);
-----------------------
T_STEP_NAME := '2';          ----normal records
    T_EXT_STATUS := 'PROCESSING';
    T_PROC_NAME  := 'UPDATE SUB';
    EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, T_FILE_ID, T_PROC_NAME, T_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);

    T_SQL_STR :=
     'UPDATE CT_EXT_DATA A '||
     '    SET A.SUBMISSION_FLAG = 0 '||
     '  WHERE ( NOT EXISTS (SELECT 1  '||
     '                      FROM '||T_EXT_OWNER||'.'||'CTSC_ENROLLMENT B '||
     '                     WHERE B.STUDY = A.PROTOCOL '||
     '                       AND B.PT = A.PT '||
     '                       AND B.REG_DT_FUL IS NOT NULL) '||
     '          OR NOT EXISTS (SELECT 1  '||
     '                      FROM '||T_EXT_OWNER||'.'||'CTSC_ELIG_CHECK B '||
     '                     WHERE B.STUDY = A.PROTOCOL '||
     '                       AND B.PT = A.PT) '||
     '          OR NOT EXISTS (SELECT 1  '||
     '                      FROM '||T_EXT_OWNER||'.'||'CTSC_PTID B '||
     '                     WHERE B.STUDY = A.PROTOCOL '||
     '                       AND B.PT = A.PT '||
     '                       AND B.PT_ID IS NOT NULL) ) '||
     '      AND A.EXTRACTED = :T_CURRENT_EXT_DATE '||
     '      AND A.PROTOCOL = :P_STUDY ';

    EXECUTE IMMEDIATE T_SQL_STR USING T_CURRENT_EXT_DATE, P_STUDY;

    COMMIT;

T_STEP_NAME := '3';  ---- check dups

-------------------
T_STEP_NAME := '3.0.1';          ----process -2
    P_SPECIAL_2(P_STUDY, P_DEBUG_MODE);
-------------------
T_STEP_NAME := '3.0.2';          ----process "*"
    P_SPECIAL_BLANK(P_STUDY, P_DEBUG_MODE);
----------------------
/* NEW SECTION */

    /*This first sql identifies how many "duplicate" extract records there are in the candidate extract file by study */
    BEGIN  -- Added Begin/Exception/End Logic to circomvent "no data found"

       SELECT MAX(cnt)
      INTO v_dup_count FROM (
      SELECT COUNT(*) cnt
         FROM CT_EXT_DATA
        WHERE protocol=P_STUDY
        GROUP BY protocol,file_id,extracted,patient,key1,key2,key3,key4,key5,SUBSTR(LINE_TEXT, 68)
       HAVING COUNT(*)>1);

    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          v_dup_count := 0;
    END;

T_STEP_NAME := '3.1';  ---- found count of dups

    /* If the above returns a count > 0, proceed. */

   /* set to 0 to skip this section */
          v_dup_count := 0;

    IF v_dup_Count > 0 THEN

       /* This statement updates the duplicate record with the min(rec_seq) with a calculated min/max of    */
       /* created date and modified date.                                                                   */
       /* It also flags the updated records with a SUBMISSION_FLAG of -1                                    */
       /* One improvement that could be made is get the Entered_By [substr(line_text,16,8)] from the record */
       /* with the max(modification timestamp), instead of the current max.                                 */

       UPDATE CT_EXT_DATA ct
       SET (rec_seq,file_id,protocol,line_text,SUBMISSION_FLAG) =
            (SELECT rec_seq,file_id,protocol,new_line,-1
               FROM (SELECT c.*, SUBSTR(c.line_text,1,15) || d.stamps || SUBSTR(c.line_text,56) new_line, min_seq
                       FROM CT_EXT_DATA c,
                            (SELECT protocol,file_id,extracted,patient,key1,key2,key3,key4,key5,
                                    MAX(SUBSTR(line_text,16,8))||MIN(SUBSTR(line_text,24,8))||MAX(SUBSTR(line_text,32,24)) stamps,
                                    SUBSTR(LINE_TEXT, 68) line_rest,
                                    MIN(rec_seq) min_seq
                               FROM CT_EXT_DATA
                              GROUP BY protocol,file_id,extracted,patient,key1,key2,key3,key4,key5,SUBSTR(LINE_TEXT,68)
                             HAVING COUNT(*)>1
                            ) d
                      WHERE c.protocol=d.protocol
                        AND c.file_id=d.file_id
                        AND c.patient=d.patient
                        AND c.key1||' '=d.key1||' '
                        AND c.key2||' '=d.key2||' '
                        AND c.key3||' '=d.key3||' '
                        AND c.key4||' '=d.key4||' '
                        AND c.key5||' '=d.key5||' '
                    ) x
              WHERE x.rec_seq=ct.rec_seq
                AND x.file_id=ct.file_id
                AND x.protocol=ct.protocol
            )
       WHERE EXISTS
             (SELECT rec_seq,file_id,protocol,min_seq
                FROM (SELECT c.*, min_seq
                        FROM CT_EXT_DATA c,
                             (SELECT protocol,file_id,extracted,patient,key1,key2,key3,key4,key5,
                                     MIN(rec_seq) min_seq
                                FROM CT_EXT_DATA
                               GROUP BY protocol,file_id,extracted,patient,key1,key2,key3,key4,key5,SUBSTR(LINE_TEXT,68)
                              HAVING COUNT(*)>1
                             ) d
                       WHERE c.protocol=d.protocol
                         AND c.file_id=d.file_id
                         AND c.patient=d.patient
                         AND c.key1||' '=d.key1||' '
                         AND c.key2||' '=d.key2||' '
                         AND c.key3||' '=d.key3||' '
                         AND c.key4||' '=d.key4||' '
                         AND c.key5||' '=d.key5||' '
                     ) x
               WHERE x.rec_seq=ct.rec_seq
                 AND x.file_id=ct.file_id
                 AND x.protocol=ct.protocol
                 AND x.min_seq=x.rec_seq
             )
         AND CT.PROTOCOL = P_STUDY;

--------------------
T_STEP_NAME := '4';          ---- delete dups

       /* This statement deletes all the records with the duplicate keys, except for the modified ones from */
       /* above, indicated by the SUBMISSION_FLAG=-1                                                        */

       DELETE FROM CT_EXT_DATA ct
        WHERE EXISTS
              (SELECT *
                 FROM (SELECT c.rec_seq,c.protocol,c.file_id
                         FROM CT_EXT_DATA c,
                              (SELECT protocol,file_id,extracted,patient,key1,key2,key3,key4,key5
                                 FROM CT_EXT_DATA
                                GROUP BY protocol,file_id,extracted,patient,key1,key2,key3,key4,key5,SUBSTR(LINE_TEXT, 68)
                               HAVING COUNT(*)>1
                              ) d
                        WHERE c.protocol=d.protocol
                          AND c.file_id=d.file_id
                          AND c.patient=d.patient
                          AND c.key1||' '=d.key1||' '
                          AND c.key2||' '=d.key2||' '
                          AND c.key3||' '=d.key3||' '
                          AND c.key4||' '=d.key4||' '
                          AND c.key5||' '=d.key5||' '
                          AND c.submission_flag=1
                      ) x
                WHERE x.rec_seq=ct.rec_seq
                  AND x.file_id=ct.file_id
                  AND x.protocol=ct.protocol
              )
         AND CT.PROTOCOL = P_STUDY;

       /* This statement changes the -1 back to 1 */

T_STEP_NAME := '5';          ---- update submission flag

       UPDATE CT_EXT_DATA SET submission_flag=1 WHERE submission_flag=-1
         AND PROTOCOL = P_STUDY;
    END IF;

    /* This command should replace the existind delete statement in EXT_DATA_PKG.P_SUBMISSION   */
    /* that includes the touch time "SUBSTR(B.LINE_TEXT, 24, 32)" in the where clause.          */
    /* This statement should occur after the above, since we are generating new (fixed) records */
    /* from records that may have already been submitted. If the order is switched,             */
    /* the previously submitted duplicate records will be gone by the time they are processed.  */

T_STEP_NAME := '6';          ---- delete candidate records that match archive

    /* changed on 04/28/2004, removed ext_source from the where clause.  */

--    DELETE FROM CT_EXT_DATA A
--     WHERE EXISTS (
--              SELECT 1
--                FROM CT_DATA_LAST_EXT B
--               WHERE B.FILE_ID    = A.FILE_ID
--                 AND B.PROTOCOL   = A.PROTOCOL
--                 AND B.PT         = A.PT
--                 AND B.PATIENT    = A.PATIENT
--                 AND '*'||B.KEY1 = '*'||A.KEY1
--                 AND '*'||B.KEY2 = '*'||A.KEY2
--                 AND '*'||B.KEY3 = '*'||A.KEY3
--                 AND '*'||B.KEY4 = '*'||A.KEY4
--                 AND '*'||B.KEY5 = '*'||A.KEY5
--                 AND SUBSTR(B.LINE_TEXT, 68) =
--                     SUBSTR(A.LINE_TEXT, 68)
--                 AND B.EXT_SOURCE = 'N'
--                 AND B.DEL_FLAG = A.DEL_FLAG )
--       AND A.EXT_SOURCE      = 'N'
--       AND A.SUBMISSION_FLAG = 1
--       AND A.PROTOCOL = P_STUDY;

/*  PRC 1/13/05  : Delete Fix Begin
    Removed the following DELETE because it would delete part 1 of a 2 part transaction, which would
    then cause havoc during the remove -2 section.

DELETE FROM CT_EXT_DATA A
     WHERE EXISTS (
              SELECT 1
                FROM CT_DATA_LAST_EXT B
               WHERE B.FILE_ID    = A.FILE_ID
                 AND B.PROTOCOL   = A.PROTOCOL
                 AND B.PT         = A.PT
                 AND B.PATIENT    = A.PATIENT
                 AND '*'||B.KEY1 = '*'||A.KEY1
                 AND '*'||B.KEY2 = '*'||A.KEY2
                 AND '*'||B.KEY3 = '*'||A.KEY3
                 AND '*'||B.KEY4 = '*'||A.KEY4
                 AND '*'||B.KEY5 = '*'||A.KEY5
                 AND SUBSTR(B.LINE_TEXT, 68) =
                     SUBSTR(A.LINE_TEXT, 68)
                 AND B.DEL_FLAG = A.DEL_FLAG )
       AND A.SUBMISSION_FLAG = 1
       AND A.PROTOCOL = P_STUDY;
*/

BEGIN
   -- For all NON-DELETE record keys perform the following
   FOR chck IN (SELECT COUNT(*) rec_count, FILE_ID, PROTOCOL, PT, PATIENT, KEY1, KEY2, KEY3, KEY4, KEY5,MIN(SUBSTR(a.line_text,32,14)) min_change
                   FROM CT_EXT_DATA A
                  WHERE A.SUBMISSION_FLAG = 1
                    AND a.del_flag <> 'D'
                    AND A.PROTOCOL = P_STUDY
                  GROUP BY FILE_ID, PROTOCOL, PT, PATIENT, KEY1, KEY2, KEY3, KEY4, KEY5) LOOP

      BEGIN
         -- Use the key to look at the LAST extract data to see if the DATA matches
         SELECT COUNT(*)
           INTO hold_temp
           FROM (
           SELECT A.PROTOCOL, A.FILE_ID, A.PT, A.PATIENT,
                  '*'||A.KEY1, '*'||A.KEY2, '*'||A.KEY3, '*'||A.KEY4, '*'||A.KEY5,
                   SUBSTR(A.LINE_TEXT, 68)
             FROM CT_EXT_DATA a
            WHERE A.SUBMISSION_FLAG = 1
              AND a.del_flag <> 'D'
              AND chck.PROTOCOL   = A.PROTOCOL
              AND chck.FILE_ID    = A.FILE_ID
              AND chck.PT         = A.PT
              AND chck.PATIENT    = A.PATIENT
              AND '*'||chck.KEY1 = '*'||A.KEY1
              AND '*'||chck.KEY2 = '*'||A.KEY2
              AND '*'||chck.KEY3 = '*'||A.KEY3
              AND '*'||chck.KEY4 = '*'||A.KEY4
              AND '*'||chck.KEY5 = '*'||A.KEY5
           MINUS
-- CGA MINUS all matching key records in the archive for the extract date that contains the max change
-- 1. get all ct_data records where extract = max(extract) of max(change)
-- 2. excluding ct_data records wher change stamp < max(change) of previous extract
           SELECT B.PROTOCOL, B.FILE_ID, B.PT, B.PATIENT,
                  '*'||B.KEY1, '*'||B.KEY2, '*'||B.KEY3, '*'||B.KEY4, '*'||B.KEY5,
                  SUBSTR(B.LINE_TEXT, 68)
          FROM ct_posted_data_vw b
          where B.SUBMISSION_FLAG = 1
             AND chck.PROTOCOL   = B.PROTOCOL
             AND chck.FILE_ID    = B.FILE_ID
             AND chck.PT         = B.PT
             AND chck.PATIENT    = B.PATIENT
             AND '*'||chck.KEY1 = '*'||B.KEY1
             AND '*'||chck.KEY2 = '*'||B.KEY2
             AND '*'||chck.KEY3 = '*'||B.KEY3
             AND '*'||chck.KEY4 = '*'||B.KEY4
             AND '*'||chck.KEY5 = '*'||B.KEY5);

         IF hold_temp  > 0 THEN
            -- Data doesn't match exactly for at least 1 part of the key, so et the max change date
            -- for the key in the CURRENT extract
            SELECT MAX(SUBSTR(a.line_text,32,14))
              INTO hold_max_change
-- CGA this is wrong - need to get the max update from archive (CT_DATA) not candidate (CT_EXT_DATA)
--              from ct_ext_data a
              FROM CT_DATA a
-- CGA
             WHERE chck.PROTOCOL   = A.PROTOCOL
               AND chck.FILE_ID    = A.FILE_ID
               AND chck.PT         = A.PT
               AND chck.PATIENT    = A.PATIENT
               AND '*'||chck.KEY1 = '*'||A.KEY1
               AND '*'||chck.KEY2 = '*'||A.KEY2
               AND '*'||chck.KEY3 = '*'||A.KEY3
               AND '*'||chck.KEY4 = '*'||A.KEY4
               AND '*'||chck.KEY5 = '*'||A.KEY5
               AND A.SUBMISSION_FLAG = 1;
-- CGA need to max change timestamp, even if it came from a delete - so comment out last where
--               AND a.del_flag <> 'D';
-- CGA

         If hold_max_change>chck.min_change Then
            --CGA we don't want to use the archive change stamp unless > min(candidate)

            -- Use the Max Change Date of the key to update the Change date of every part of the key
            UPDATE CT_EXT_DATA a
               SET line_text = SUBSTR(line_text,1,31)||
                               hold_max_change||
                               SUBSTR(line_text,46)
             WHERE chck.PROTOCOL   = A.PROTOCOL
               AND chck.FILE_ID    = A.FILE_ID
               AND chck.PT         = A.PT
               AND chck.PATIENT    = A.PATIENT
               AND '*'||chck.KEY1 = '*'||A.KEY1
               AND '*'||chck.KEY2 = '*'||A.KEY2
               AND '*'||chck.KEY3 = '*'||A.KEY3
               AND '*'||chck.KEY4 = '*'||A.KEY4
               AND '*'||chck.KEY5 = '*'||A.KEY5
               AND A.SUBMISSION_FLAG = 1
               AND a.del_flag <> 'D';
            End If;
         ELSE
            -- We found the same amount of records in Last Extract, so remove them
            DELETE FROM CT_EXT_DATA a
             WHERE chck.PROTOCOL   = A.PROTOCOL
               AND chck.FILE_ID    = A.FILE_ID
               AND chck.PT         = A.PT
               AND chck.PATIENT    = A.PATIENT
               AND '*'||chck.KEY1 = '*'||A.KEY1
               AND '*'||chck.KEY2 = '*'||A.KEY2
               AND '*'||chck.KEY3 = '*'||A.KEY3
               AND '*'||chck.KEY4 = '*'||A.KEY4
               AND '*'||chck.KEY5 = '*'||A.KEY5
               AND A.SUBMISSION_FLAG = 1
               AND a.del_flag <> 'D';
         END IF;

      END;
   END LOOP;
END;
/*  PRC 1/13/05  : MissingUpdate Fix End */


T_STEP_NAME := '7';          ---- Add delete date = last extract date

      /* This update command will add the delete date to the delete records.       */
      /* The date of last extract for each file type will be used as the delete date */
      /* The same date (and time) will be used for the Change Date and Time        */
      /* also adds the EXTRACTED date to the line                               */

-- 08/10/2004 change the 'change date/time' and 'delete date' from last_extract_date to sysdate
-- 01/18/2005 Change Sysdate to the following: [DeleteDate Fix]
--            Extraction Date      = extracted
--            Record Creation Date = Creaton Date of KEY [check archive data]
--            Changed
--            Chg_Time             = Max(Change Date of Key) [check archive data]
--            Del_Date             = Sysdate (delete date)
--            Del_User             = 'CDW'

/*
--    UPDATE ct_ext_data SET line_text = SUBSTR(line_text,1,7)
--                                             ||TO_CHAR(extracted,'rrrrmmdd')
--                                             ||SUBSTR(line_text,16,16)
--                                             ||TO_CHAR(EXT_UTIL_PKG.F_LAST_EXT_DATE(P_STUDY,FILE_ID),'rrrrmmddhhmiss')
--                                             ||SUBSTR(line_text,46,2)
--                                             ||TO_CHAR(EXT_UTIL_PKG.F_LAST_EXT_DATE(P_STUDY,FILE_ID),'rrrrmmdd')
--                                             ||SUBSTR(line_text,56)
--    WHERE del_flag='D'
--             AND PROTOCOL = P_STUDY;

      UPDATE ct_ext_data SET line_text = SUBSTR(line_text,1,7)
                                             ||TO_CHAR(extracted,'rrrrmmdd')
                                             ||SUBSTR(line_text,16,16)
                                             ||TO_CHAR(SYSDATE,'rrrrmmddhhmiss')
                                             ||SUBSTR(line_text,46,2)
                                             ||TO_CHAR(SYSDATE,'rrrrmmdd')
                                             ||SUBSTR(line_text,56)
      WHERE del_flag = 'D'
             AND PROTOCOL = P_STUDY;
*/
   FOR chck IN (SELECT DISTINCT FILE_ID, PROTOCOL, PT, PATIENT, KEY1, KEY2, KEY3, KEY4, KEY5
                   FROM CT_EXT_DATA A
                  WHERE A.SUBMISSION_FLAG = 1
                    AND a.del_flag = 'D'
                    AND A.PROTOCOL = P_STUDY) LOOP

      BEGIN
            SELECT MAX(SUBSTR(a.line_text,32,14)), MAX(SUBSTR(a.line_text,24,8))
              INTO hold_max_change, hold_max_created
              FROM ct_posted_data_vw a
             WHERE chck.PROTOCOL   = A.PROTOCOL
               AND chck.FILE_ID    = A.FILE_ID
               AND chck.PT         = A.PT
               AND chck.PATIENT    = A.PATIENT
               AND '*'||chck.KEY1 = '*'||A.KEY1
               AND '*'||chck.KEY2 = '*'||A.KEY2
               AND '*'||chck.KEY3 = '*'||A.KEY3
               AND '*'||chck.KEY4 = '*'||A.KEY4
               AND '*'||chck.KEY5 = '*'||A.KEY5
               AND A.SUBMISSION_FLAG = 1;

         UPDATE CT_EXT_DATA a
            SET line_text = SUBSTR(line_text,1,7) ||
                            TO_CHAR(extracted,'rrrrmmdd') ||
                            'CDW     ' || -- SUBSTR(line_text,16,8) ||
                            NVL(hold_max_created,to_char(sysdate,'rrrrmmdd')) ||
                            NVL(hold_max_change,to_char(sysdate,'rrrrmmddhh24miss'))  ||
                            SUBSTR(line_text,46,2) ||
                            TO_CHAR(SYSDATE,'rrrrmmdd') ||
                            SUBSTR(line_text,56)
          WHERE chck.PROTOCOL   = A.PROTOCOL
            AND chck.FILE_ID    = A.FILE_ID
            AND chck.PT         = A.PT
            AND chck.PATIENT    = A.PATIENT
            AND '*'||chck.KEY1 = '*'||A.KEY1
            AND '*'||chck.KEY2 = '*'||A.KEY2
            AND '*'||chck.KEY3 = '*'||A.KEY3
            AND '*'||chck.KEY4 = '*'||A.KEY4
            AND '*'||chck.KEY5 = '*'||A.KEY5
            AND A.SUBMISSION_FLAG = 1
            AND a.del_flag = 'D';

      END;
   END LOOP;

   DELETE FROM CT_EXT_DATA a
    WHERE EXISTS
             (SELECT 1 FROM ct_posted_data_vw arch
               WHERE arch.PROTOCOL   = A.PROTOCOL
               AND arch.FILE_ID    = A.FILE_ID
               AND arch.PT         = A.PT
               AND arch.PATIENT    = A.PATIENT
               AND '*'||arch.KEY1 = '*'||A.KEY1
               AND '*'||arch.KEY2 = '*'||A.KEY2
               AND '*'||arch.KEY3 = '*'||A.KEY3
               AND '*'||arch.KEY4 = '*'||A.KEY4
               AND '*'||arch.KEY5 = '*'||A.KEY5
               AND arch.del_flag = a.del_flag
               AND SUBSTR(arch.line_text, 32,14) = SUBSTR(a.line_text, 32,14))
      AND A.SUBMISSION_FLAG = 1
      AND A.PROTOCOL = P_STUDY
     AND a.del_flag = 'D';



/*  PRC 1/18/05  : DeleteDate Fix End */

/* NEW SECTION */

/*  Removed this delete, see above...

    DELETE FROM CT_EXT_DATA A
     WHERE EXISTS (
              SELECT 1
                FROM CT_DATA_LAST_EXT B
               WHERE B.FILE_ID    = A.FILE_ID
                 AND B.PROTOCOL   = A.PROTOCOL
                 AND B.PT         = A.PT
                 AND B.PATIENT    = A.PATIENT
                 AND '*'||B.KEY1 = '*'||A.KEY1
                 AND '*'||B.KEY2 = '*'||A.KEY2
                 AND '*'||B.KEY3 = '*'||A.KEY3
                 AND '*'||B.KEY4 = '*'||A.KEY4
                 AND '*'||B.KEY5 = '*'||A.KEY5
                 AND SUBSTR(B.LINE_TEXT, 24, 32)||SUBSTR(B.LINE_TEXT, 68) =
                     SUBSTR(A.LINE_TEXT, 24, 32)||SUBSTR(A.LINE_TEXT, 68)
                 AND B.EXT_SOURCE = 'N'
                 AND B.DEL_FLAG  <> 'D')
       AND A.EXT_SOURCE      = 'N'
       AND A.SUBMISSION_FLAG = 1
       AND A.DEL_FLAG       <> 'D'
       AND A.PROTOCOL = P_STUDY;
*/

    COMMIT;
-----------------------

    -- P_STUDY_NAME(P_STUDY, P_REPORT_AS, P_DEBUG_MODE); Moved to the procedure that calls this one.

-----------------------
T_STEP_NAME := '9';
    T_EXT_STATUS := 'SUCCESS';
    EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, T_FILE_ID, T_PROC_NAME, T_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);

EXCEPTION
    WHEN OTHERS THEN
        T_EXT_STATUS := 'FAIL';
        T_SQL_ERROR_CODE    := SQLCODE;
        T_SQL_ERROR_DESC    := SQLERRM;
        T_KEY_VALUE         := NULL;
        T_CT_ERROR_DESC := 'Update CT_DATA failed @'||T_MOD_NAME||'--'||T_STEP_NAME||'--'||T_FILE_ID;
        -- Error handling procedure
        EXT_UTIL_PKG.P_CT_EXT_LOGS
             (P_STUDY, T_FILE_ID, T_PROC_NAME, T_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);
        EXT_UTIL_PKG.P_CT_EXT_ERRORS
                    (P_STUDY, T_FILE_ID, T_MOD_NAME, T_STEP_NAME
                    ,T_KEY_VALUE, T_SQL_ERROR_CODE, T_SQL_ERROR_DESC
                    ,T_CT_ERROR_DESC, P_DEBUG_MODE);
END;

PROCEDURE old_P_DELETE_ALL_2
 (P_STUDY            IN VARCHAR2
 ,P_VERSION          IN VARCHAR2
 ,P_FILE_ID          IN VARCHAR2
 ,P_CURRENT_EXT_DATE IN DATE
 ,P_DEBUG_MODE       IN VARCHAR2 := 'CONT'
 )
 IS

  T_MOD_NAME           VARCHAR2(60)  := 'EXT_DATA_PKG.P_DELETE_ALL_2';
  T_STEP_NAME          VARCHAR2(30)  := '1';
  T_PROC_NAME          VARCHAR2(30);

BEGIN

    DELETE FROM CT_EXT_DATA
     WHERE PROTOCOL = P_STUDY
       AND EXTRACTED = P_CURRENT_EXT_DATE
       AND VERSION LIKE 'T%'
       AND ( (FILE_ID IN ('BC', 'EX', 'HM', 'IP', 'OU', 'PL', 'RC', 'RF', 'SC',
                       'SE', 'SR', 'UE', 'US')
              AND TRIM(REPLACE(SUBSTR(LINE_TEXT, 131), '-2', '')) IS NULL)
          OR (FILE_ID IN ('BM', 'LL', 'LX', 'UL')
              AND TRIM(REPLACE(SUBSTR(LINE_TEXT, 119), '-2', '')) IS NULL) )
       AND DEL_FLAG <> 'D'
       AND FILE_ID = P_FILE_ID;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;

PROCEDURE P_DELETE_ALL_2
 (P_STUDY        IN VARCHAR2
 ,P_DEBUG_MODE   IN VARCHAR2 := 'CONT'
 )
 IS

  T_MOD_NAME           VARCHAR2(60)  := 'EXT_DATA_PKG.P_DELETE_ALL_2';
  T_STEP_NAME          VARCHAR2(30)  := '1';
  T_PROC_NAME          VARCHAR2(30);
  T_FILE_ID            VARCHAR2(30) :='ALL';
  T_VERSION            VARCHAR2(4);
  T_INST_ID            VARCHAR2(8);
    T_SQL_ERROR_CODE       CT_EXT_ERRORS.SQL_ERROR_CODE%TYPE;
    T_SQL_ERROR_DESC       CT_EXT_ERRORS.SQL_ERROR_DESC%TYPE;
    T_KEY_VALUE            CT_EXT_ERRORS.KEY_VALUE%TYPE;
    T_CT_ERROR_DESC        CT_EXT_ERRORS.CT_ERROR_DESC%TYPE;
    T_START_DATE           DATE := SYSDATE;
    T_EXT_STATUS           CT_EXT_LOGS.EXT_STATUS%TYPE;
    T_TAB_EXT_STATUS       VARCHAR2(30);
    T_LAST_EXT_DATE        DATE;
    T_CURRENT_EXT_DATE     DATE;
    T_CURRENT_EXT_DATE_VAR VARCHAR2(8);
    T_EXT_OWNER            VARCHAR2(30);
  T_TEMP_NUM    NUMBER;

BEGIN
-----------------------
T_STEP_NAME := '1';
    T_CURRENT_EXT_DATE     := EXT_UTIL_PKG.F_CURRENT_EXT_DATE(P_STUDY, T_FILE_ID);
    T_EXT_OWNER := F_EXT_OWNER(P_STUDY);
-----------------------
T_STEP_NAME := '2';          ----delete null lab records
    T_EXT_STATUS := 'PROCESSING';
    T_PROC_NAME  := 'DELETE NULL LAB';
    EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, T_FILE_ID, T_PROC_NAME, T_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);

    FOR T_REC IN (
            SELECT A.ROWID A_ROWID, A.*
              FROM CT_EXT_DATA A
             WHERE A.PROTOCOL = P_STUDY
               AND A.EXTRACTED = T_CURRENT_EXT_DATE
               AND A.VERSION LIKE 'T%'
               AND ( (A.FILE_ID IN ('BC', 'EX', 'HM', 'IP', 'OU', 'PL', 'RC', 'RF', 'SC',
                       'SE', 'SR', 'UE', 'US')
                      AND TRIM(REPLACE(SUBSTR(A.LINE_TEXT, 131), '-2', '')) IS NULL)
                  OR (A.FILE_ID IN ('BM', 'LL', 'LX', 'UL')
                      AND TRIM(REPLACE(SUBSTR(A.LINE_TEXT, 119), '-2', '')) IS NULL) )
               AND A.DEL_FLAG <> 'D') LOOP

        BEGIN --- check if the record exist in the archieve

              SELECT 1 INTO T_TEMP_NUM
                FROM CTSP_ALL_FILE B
               WHERE B.FILE_ID    = T_REC.FILE_ID
                 AND B.STUDY      = T_REC.PROTOCOL
                 AND B.PT         = T_REC.PT
                 AND B.PATIENT    = T_REC.PATIENT
                 AND '*'||B.KEY1 = '*'||T_REC.KEY1
                 AND '*'||B.KEY2 = '*'||T_REC.KEY2
                 AND '*'||B.KEY3 = '*'||T_REC.KEY3
                 AND '*'||B.KEY4 = '*'||T_REC.KEY4
                 AND '*'||B.KEY5 = '*'||T_REC.KEY5
                 AND B.DEL_FLAG <> 'D'
                 AND ROWNUM = 1;


           BEGIN
              SELECT 1 INTO T_TEMP_NUM
                FROM CT_EXT_DATA B
               WHERE B.FILE_ID    = T_REC.FILE_ID
                 AND B.PROTOCOL   = T_REC.PROTOCOL
                 AND B.PT         = T_REC.PT
                 AND B.PATIENT    = T_REC.PATIENT
                 AND '*'||B.KEY1 = '*'||T_REC.KEY1
                 AND '*'||B.KEY2 = '*'||T_REC.KEY2
                 AND '*'||B.KEY3 = '*'||T_REC.KEY3
                 AND '*'||B.KEY4 = '*'||T_REC.KEY4
                 AND '*'||B.KEY5 = '*'||T_REC.KEY5
                 AND B.DEL_FLAG <> 'D'
                 AND ( (B.FILE_ID IN ('BC', 'EX', 'HM', 'IP', 'OU', 'PL', 'RC', 'RF', 'SC',
                       'SE', 'SR', 'UE', 'US')
                      AND TRIM(REPLACE(SUBSTR(B.LINE_TEXT, 131), '-2', '')) IS NOT NULL)
                  OR (B.FILE_ID IN ('BM', 'LL', 'LX', 'UL')
                      AND TRIM(REPLACE(SUBSTR(B.LINE_TEXT, 119), '-2', '')) IS NOT NULL) )
                 AND ROWNUM = 1;

                DELETE FROM CT_EXT_DATA WHERE ROWID = T_REC.A_ROWID;

            EXCEPTION
              WHEN NO_DATA_FOUND THEN
               ---- if existing, generate a DELETE and then delete the records with the same keys
                 BEGIN
                   UPDATE CT_EXT_DATA
                      SET DEL_FLAG = 'D',
                          LINE_TEXT =          SUBSTR(T_REC.line_text,1,7)
                                             ||TO_CHAR(T_REC.extracted,'rrrrmmdd')
                                             ||SUBSTR(T_REC.line_text,16,16)
                                             ||TO_CHAR(SYSDATE,'rrrrmmddhhmiss')
                                             ||SUBSTR(T_REC.line_text,46,1)||'D'
                                             ||TO_CHAR(SYSDATE,'rrrrmmdd')
                                             ||SUBSTR(T_REC.line_text,56)

                     WHERE ROWID = T_REC.A_ROWID;
                 EXCEPTION
                   WHEN OTHERS THEN NULL;
                 END;

            END;

        EXCEPTION
          WHEN NO_DATA_FOUND THEN
           --- delete all records from candidate with the same keys

            BEGIN
              DELETE FROM CT_EXT_DATA WHERE ROWID = T_REC.A_ROWID;
            EXCEPTION
              WHEN OTHERS THEN NULL;
            END;
       -----------
        END;

    END LOOP;

    COMMIT;

-----------------------
T_STEP_NAME := '8';
    T_EXT_STATUS := 'SUCCESS';
    EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, T_FILE_ID, T_PROC_NAME, T_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        T_EXT_STATUS := 'FAIL';
        T_SQL_ERROR_CODE    := SQLCODE;
        T_SQL_ERROR_DESC    := SQLERRM;
        T_KEY_VALUE         := NULL;
        T_CT_ERROR_DESC := 'Update CT_DATA failed @'||T_MOD_NAME||'--'||T_STEP_NAME||'--'||T_FILE_ID;
        -- Error handling procedure
        EXT_UTIL_PKG.P_CT_EXT_LOGS
             (P_STUDY, T_FILE_ID, T_PROC_NAME, T_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);
        EXT_UTIL_PKG.P_CT_EXT_ERRORS
                    (P_STUDY, T_FILE_ID, T_MOD_NAME, T_STEP_NAME
                    ,T_KEY_VALUE, T_SQL_ERROR_CODE, T_SQL_ERROR_DESC
                    ,T_CT_ERROR_DESC, P_DEBUG_MODE);
END;

PROCEDURE P_SPECIAL_2
 (P_STUDY        IN VARCHAR2
 ,P_DEBUG_MODE   IN VARCHAR2 := 'CONT'
 )
 IS

  T_MOD_NAME           VARCHAR2(60)  := 'EXT_DATA_PKG.P_SPECIAL_2';
  T_STEP_NAME          VARCHAR2(30)  := '1';
  T_PROC_NAME          VARCHAR2(30);
  T_FILE_ID            VARCHAR2(30) :='ALL';
  T_REPORT_TO          VARCHAR2(30) := 'THERADEX';
  T_VERSION            VARCHAR2(4);
  T_INST_ID            VARCHAR2(8);
    T_SQL_ERROR_CODE       CT_EXT_ERRORS.SQL_ERROR_CODE%TYPE;
    T_SQL_ERROR_DESC       CT_EXT_ERRORS.SQL_ERROR_DESC%TYPE;
    T_KEY_VALUE            CT_EXT_ERRORS.KEY_VALUE%TYPE;
    T_CT_ERROR_DESC        CT_EXT_ERRORS.CT_ERROR_DESC%TYPE;
    T_START_DATE           DATE := SYSDATE;
    T_EXT_STATUS           CT_EXT_LOGS.EXT_STATUS%TYPE;
    T_TAB_EXT_STATUS       VARCHAR2(30);
    T_LAST_EXT_DATE        DATE;
    T_CURRENT_EXT_DATE     DATE;
    T_CURRENT_EXT_DATE_VAR VARCHAR2(8);
    T_EXT_OWNER            VARCHAR2(30);

  TYPE TAB_ROWID_TYPE IS TABLE OF ROWID
      INDEX BY BINARY_INTEGER;
  TYPE TAB_LINE_TEXT_TYPE IS TABLE OF VARCHAR2(2600)
      INDEX BY BINARY_INTEGER;
  T_TAB_ROWID             TAB_ROWID_TYPE;
  T_TAB_LINE_TEXT         TAB_LINE_TEXT_TYPE;
  T_EMPTY_TAB_ROWID             TAB_ROWID_TYPE;
  T_EMPTY_TAB_LINE_TEXT         TAB_LINE_TEXT_TYPE;
  T_COUNT NUMBER := 0;
  T_POS_TEMP     PLS_INTEGER := 0;
  T_LENGTH       PLS_INTEGER := 0;
  T_POS          PLS_INTEGER := 0;
  T_TEMP_2       VARCHAR2(2000);
  T_REMOVE_2     VARCHAR2(1);
  T_UPDATE_FLAG  VARCHAR2(1);
  T_UPDATE_COUNT PLS_INTEGER := 0;
  T_FIELD_START   NUMBER;
  T_FIELD_LENGTH  NUMBER;
  T_FIELD_POS_STR VARCHAR2(60);
  T_FIELD_VALUE   VARCHAR2(2000);
BEGIN
-----------------------
T_STEP_NAME := '1';
    T_CURRENT_EXT_DATE     := EXT_UTIL_PKG.F_CURRENT_EXT_DATE(P_STUDY, T_FILE_ID);
    T_EXT_OWNER := F_EXT_OWNER(P_STUDY);
-----------------------
T_STEP_NAME := '2';          ----normal records
    T_EXT_STATUS := 'PROCESSING';
    T_PROC_NAME  := 'PROC -2';
    EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, T_FILE_ID, T_PROC_NAME, T_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);

    FOR T_KEY IN (SELECT PROTOCOL, FILE_ID, VERSION, PT, PATIENT, KEY1, KEY2, KEY3, KEY4, KEY5, COUNT(*) A_COUNT
                    FROM CT_EXT_DATA
                   WHERE PROTOCOL = P_STUDY
                     AND EXTRACTED = T_CURRENT_EXT_DATE
                     AND VERSION LIKE 'T%'
                     AND DEL_FLAG <> 'D'
                     AND SUBMISSION_FLAG = 1
                   HAVING COUNT(*) > 1
                   GROUP BY PROTOCOL, FILE_ID, VERSION, PT, PATIENT, KEY1, KEY2, KEY3, KEY4, KEY5) LOOP

          T_TAB_ROWID := T_EMPTY_TAB_ROWID;
          T_TAB_LINE_TEXT := T_EMPTY_TAB_LINE_TEXT;
          T_COUNT := 0;

          FOR T_REC IN (SELECT ROWID A_ROWID, LINE_TEXT
                          FROM CT_EXT_DATA
                         WHERE PROTOCOL = T_KEY.PROTOCOL
                           AND FILE_ID = T_KEY.FILE_ID
                           AND VERSION = T_KEY.VERSION
                           AND PT = T_KEY.PT
                           AND PATIENT = T_KEY.PATIENT
                           AND '*'||KEY1 = '*'||T_KEY.KEY1
                           AND '*'||KEY2 = '*'||T_KEY.KEY2
                           AND '*'||KEY3 = '*'||T_KEY.KEY3
                           AND '*'||KEY4 = '*'||T_KEY.KEY4
                           AND '*'||KEY5 = '*'||T_KEY.KEY5  ) LOOP
            T_COUNT := T_COUNT + 1;
            T_TAB_ROWID(T_COUNT) := T_REC.A_ROWID;
            T_TAB_LINE_TEXT(T_COUNT) := T_REC.LINE_TEXT;

          END LOOP;


          T_COUNT := T_KEY.A_COUNT;
          T_UPDATE_FLAG := 'N';

          FOR II IN 1..T_COUNT LOOP  -- check for each row start

            T_LENGTH := LENGTH(T_TAB_LINE_TEXT(II));
            T_POS_TEMP := INSTR(T_TAB_LINE_TEXT(II), '-2');
            T_POS := T_POS_TEMP;

            WHILE (T_POS_TEMP <> 0) LOOP
                T_REMOVE_2 := 'N';

                T_FIELD_POS_STR := F_FIELD_POS(T_REPORT_TO, T_KEY.VERSION, T_KEY.FILE_ID, T_POS);
                T_FIELD_START := TO_NUMBER(TRIM(SUBSTR(T_FIELD_POS_STR, 1, 8)));
                T_FIELD_LENGTH := TO_NUMBER(TRIM(SUBSTR(T_FIELD_POS_STR, 9)));
                T_FIELD_VALUE := SUBSTR(T_TAB_LINE_TEXT(II), T_FIELD_START, T_FIELD_LENGTH);

                IF TRIM(T_FIELD_VALUE) = '-2' THEN
                  FOR JJ IN 1..T_COUNT LOOP    -- check for each column start

                    IF II <> JJ THEN
                      T_TEMP_2 := SUBSTR(T_TAB_LINE_TEXT(JJ), T_FIELD_START, T_FIELD_LENGTH);

                      IF (T_TEMP_2 <> T_FIELD_VALUE) THEN
                        T_REMOVE_2 := 'Y';
                      END IF;

                    END IF;
                    EXIT WHEN (T_REMOVE_2 = 'Y');

                  END LOOP;  -- check for each column end

                  IF T_REMOVE_2 = 'Y' THEN
                    IF T_POS + 1 = T_LENGTH THEN
                      T_TAB_LINE_TEXT(II) := SUBSTR(T_TAB_LINE_TEXT(II), 1, T_POS - 1)||'  ';
                    ELSE
                      T_TAB_LINE_TEXT(II) := SUBSTR(T_TAB_LINE_TEXT(II), 1, T_POS - 1)||'  '||
                                         SUBSTR(T_TAB_LINE_TEXT(II), T_POS + 2);
                    END IF;
                    T_UPDATE_FLAG := 'Y';
                  END IF;

                END IF;

                EXIT WHEN ((T_POS + 2) >= T_LENGTH);

                T_POS_TEMP := INSTR(SUBSTR(T_TAB_LINE_TEXT(II), T_POS + 2), '-2');
                T_POS := T_POS + T_POS_TEMP + 1;

            END LOOP;

            IF T_UPDATE_FLAG = 'Y' THEN       -- update line_text
              UPDATE CT_EXT_DATA
                 SET LINE_TEXT = T_TAB_LINE_TEXT(II)
               WHERE ROWID = T_TAB_ROWID(II);
              T_UPDATE_COUNT := T_UPDATE_COUNT + 1;
            END IF;

          END LOOP;    -- check for each row end

    END LOOP;

    COMMIT;
-----------------------
T_STEP_NAME := '8';
    T_EXT_STATUS := 'SUCCESS';
    EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, T_FILE_ID, T_PROC_NAME, T_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, T_UPDATE_COUNT, NULL, P_DEBUG_MODE);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        T_EXT_STATUS := 'FAIL';
        T_SQL_ERROR_CODE    := SQLCODE;
        T_SQL_ERROR_DESC    := SQLERRM;
        T_KEY_VALUE         := NULL;
        T_CT_ERROR_DESC := 'Update CT_DATA failed @'||T_MOD_NAME||'--'||T_STEP_NAME||'--'||T_FILE_ID;
        -- Error handling procedure
        EXT_UTIL_PKG.P_CT_EXT_LOGS
             (P_STUDY, T_FILE_ID, T_PROC_NAME, T_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);
        EXT_UTIL_PKG.P_CT_EXT_ERRORS
                    (P_STUDY, T_FILE_ID, T_MOD_NAME, T_STEP_NAME
                    ,T_KEY_VALUE, T_SQL_ERROR_CODE, T_SQL_ERROR_DESC
                    ,T_CT_ERROR_DESC, P_DEBUG_MODE);
END;

PROCEDURE P_SPECIAL_BLANK
 (P_STUDY        IN VARCHAR2
 ,P_DEBUG_MODE   IN VARCHAR2 := 'CONT'
 )
 IS

  T_MOD_NAME           VARCHAR2(60)  := 'EXT_DATA_PKG.P_SPECIAL_BLANK';
  T_STEP_NAME          VARCHAR2(30)  := '1';
  T_PROC_NAME          VARCHAR2(30);
  T_FILE_ID            VARCHAR2(30) :='ALL';
  T_REPORT_TO          VARCHAR2(30) := 'THERADEX';
  T_VERSION            VARCHAR2(4);
  T_INST_ID            VARCHAR2(8);
    T_SQL_ERROR_CODE       CT_EXT_ERRORS.SQL_ERROR_CODE%TYPE;
    T_SQL_ERROR_DESC       CT_EXT_ERRORS.SQL_ERROR_DESC%TYPE;
    T_KEY_VALUE            CT_EXT_ERRORS.KEY_VALUE%TYPE;
    T_CT_ERROR_DESC        CT_EXT_ERRORS.CT_ERROR_DESC%TYPE;
    T_START_DATE           DATE := SYSDATE;
    T_EXT_STATUS           CT_EXT_LOGS.EXT_STATUS%TYPE;
    T_TAB_EXT_STATUS       VARCHAR2(30);
    T_LAST_EXT_DATE        DATE;
    T_CURRENT_EXT_DATE     DATE;
    T_CURRENT_EXT_DATE_VAR VARCHAR2(8);
    T_EXT_OWNER            VARCHAR2(30);

  TYPE TAB_ROWID_TYPE IS TABLE OF ROWID
      INDEX BY BINARY_INTEGER;
  TYPE TAB_LINE_TEXT_TYPE IS TABLE OF VARCHAR2(2600)
      INDEX BY BINARY_INTEGER;
  T_TAB_ROWID             TAB_ROWID_TYPE;
  T_TAB_LINE_TEXT         TAB_LINE_TEXT_TYPE;
  T_EMPTY_TAB_ROWID             TAB_ROWID_TYPE;
  T_EMPTY_TAB_LINE_TEXT         TAB_LINE_TEXT_TYPE;
  T_COUNT NUMBER := 0;
  T_POS_TEMP     PLS_INTEGER := 0;
  T_LENGTH       PLS_INTEGER := 0;
  T_POS          PLS_INTEGER := 0;
  T_TEMP_2       VARCHAR2(2000);
  T_REMOVE_2     VARCHAR2(1);
  T_UPDATE_FLAG  VARCHAR2(1);
  T_UPDATE_COUNT PLS_INTEGER := 0;
  T_FIELD_START   NUMBER;
  T_FIELD_LENGTH  NUMBER;
  T_FIELD_POS_STR VARCHAR2(60);
  T_FIELD_VALUE   VARCHAR2(2000);
BEGIN
-----------------------
T_STEP_NAME := '1';
    T_CURRENT_EXT_DATE     := EXT_UTIL_PKG.F_CURRENT_EXT_DATE(P_STUDY, T_FILE_ID);
    T_EXT_OWNER := F_EXT_OWNER(P_STUDY);
-----------------------
T_STEP_NAME := '2';          ----normal records
    T_EXT_STATUS := 'PROCESSING';
    T_PROC_NAME  := 'PROC BLANK';
    EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, T_FILE_ID, T_PROC_NAME, T_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);

    FOR T_KEY IN (SELECT PROTOCOL, FILE_ID, VERSION, PT, PATIENT, KEY1, KEY2, KEY3, KEY4, KEY5, COUNT(*) A_COUNT
                    FROM CT_EXT_DATA
                   WHERE PROTOCOL = P_STUDY
                     AND EXTRACTED = T_CURRENT_EXT_DATE
                     AND VERSION LIKE 'T%'
                     AND DEL_FLAG <> 'D'
                     AND SUBMISSION_FLAG = 1
                   HAVING COUNT(*) > 1
                   GROUP BY PROTOCOL, FILE_ID, VERSION, PT, PATIENT, KEY1, KEY2, KEY3, KEY4, KEY5) LOOP

          T_TAB_ROWID := T_EMPTY_TAB_ROWID;
          T_TAB_LINE_TEXT := T_EMPTY_TAB_LINE_TEXT;
          T_COUNT := 0;

          FOR T_REC IN (SELECT ROWID A_ROWID, LINE_TEXT
                          FROM CT_EXT_DATA
                         WHERE PROTOCOL = T_KEY.PROTOCOL
                           AND FILE_ID = T_KEY.FILE_ID
                           AND VERSION = T_KEY.VERSION
                           AND PT = T_KEY.PT
                           AND PATIENT = T_KEY.PATIENT
                           AND '*'||KEY1 = '*'||T_KEY.KEY1
                           AND '*'||KEY2 = '*'||T_KEY.KEY2
                           AND '*'||KEY3 = '*'||T_KEY.KEY3
                           AND '*'||KEY4 = '*'||T_KEY.KEY4
                           AND '*'||KEY5 = '*'||T_KEY.KEY5  ) LOOP
            T_COUNT := T_COUNT + 1;
            T_TAB_ROWID(T_COUNT) := T_REC.A_ROWID;
            T_TAB_LINE_TEXT(T_COUNT) := T_REC.LINE_TEXT;

          END LOOP;

          T_COUNT := T_KEY.A_COUNT;
          T_UPDATE_FLAG := 'N';

          FOR II IN 1..T_COUNT LOOP  -- check for each row start

            T_LENGTH := LENGTH(T_TAB_LINE_TEXT(II));
            T_POS_TEMP := INSTR(T_TAB_LINE_TEXT(II), '*');
            T_POS := T_POS_TEMP;

            WHILE (T_POS_TEMP <> 0) LOOP
                T_REMOVE_2 := 'N';

                T_FIELD_POS_STR := F_FIELD_POS(T_REPORT_TO, T_KEY.VERSION, T_KEY.FILE_ID, T_POS);
                T_FIELD_START := TO_NUMBER(TRIM(SUBSTR(T_FIELD_POS_STR, 1, 8)));
                T_FIELD_LENGTH := TO_NUMBER(TRIM(SUBSTR(T_FIELD_POS_STR, 9)));
                T_FIELD_VALUE := SUBSTR(T_TAB_LINE_TEXT(II), T_FIELD_START, T_FIELD_LENGTH);

                IF TRIM(T_FIELD_VALUE) = '*' THEN
                  FOR JJ IN 1..T_COUNT LOOP    -- check for each column start

                    IF II <> JJ THEN
                      T_TEMP_2 := SUBSTR(T_TAB_LINE_TEXT(JJ), T_FIELD_START, T_FIELD_LENGTH);

                      IF (T_TEMP_2 <> T_FIELD_VALUE) THEN
                        T_REMOVE_2 := 'Y';
                      END IF;

                    END IF;
                    EXIT WHEN (T_REMOVE_2 = 'Y');

                  END LOOP;  -- check for each column end

                  IF T_REMOVE_2 = 'Y' THEN
                    IF T_POS + 1 = T_LENGTH THEN
                      T_TAB_LINE_TEXT(II) := SUBSTR(T_TAB_LINE_TEXT(II), 1, T_POS - 1)||'*';
                    ELSE
                      T_TAB_LINE_TEXT(II) := SUBSTR(T_TAB_LINE_TEXT(II), 1, T_POS - 1)||'*'||
                                         SUBSTR(T_TAB_LINE_TEXT(II), T_POS + 1);
                    END IF;
                    T_UPDATE_FLAG := 'Y';
                  END IF;

                END IF;

                EXIT WHEN ((T_POS + 1) >= T_LENGTH);

                T_POS_TEMP := INSTR(SUBSTR(T_TAB_LINE_TEXT(II), T_POS + 1), '*');
                T_POS := T_POS + T_POS_TEMP;

            END LOOP;

            IF T_UPDATE_FLAG = 'Y' THEN       -- update line_text
              UPDATE CT_EXT_DATA
                 SET LINE_TEXT = T_TAB_LINE_TEXT(II)
               WHERE ROWID = T_TAB_ROWID(II);
              T_UPDATE_COUNT := T_UPDATE_COUNT + 1;
            END IF;

          END LOOP;    -- check for each row end

    END LOOP;

    COMMIT;
-----------------------
T_STEP_NAME := '8';
    T_EXT_STATUS := 'SUCCESS';
    EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, T_FILE_ID, T_PROC_NAME, T_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, T_UPDATE_COUNT, NULL, P_DEBUG_MODE);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        T_EXT_STATUS := 'FAIL';
        T_SQL_ERROR_CODE    := SQLCODE;
        T_SQL_ERROR_DESC    := SQLERRM;
        T_KEY_VALUE         := NULL;
        T_CT_ERROR_DESC := 'Update CT_DATA failed @'||T_MOD_NAME||'--'||T_STEP_NAME||'--'||T_FILE_ID;
        -- Error handling procedure
        EXT_UTIL_PKG.P_CT_EXT_LOGS
             (P_STUDY, T_FILE_ID, T_PROC_NAME, T_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);
        EXT_UTIL_PKG.P_CT_EXT_ERRORS
                    (P_STUDY, T_FILE_ID, T_MOD_NAME, T_STEP_NAME
                    ,T_KEY_VALUE, T_SQL_ERROR_CODE, T_SQL_ERROR_DESC
                    ,T_CT_ERROR_DESC, P_DEBUG_MODE);
END;

FUNCTION F_CT_DATA_TX_EXIST
 (P_FILE_ID     IN VARCHAR2
 ,P_PROTOCOL    IN VARCHAR2
 ,P_PT          IN VARCHAR2
 ,P_PATIENT     IN VARCHAR2
 ,P_KEY1        IN VARCHAR2
 ,P_KEY2        IN VARCHAR2
 ,P_KEY3        IN VARCHAR2
 ,P_LINE_TEXT   IN VARCHAR2)
 RETURN VARCHAR2
 IS
  T_REC     GC_CT_DATA_TX_EXIST%ROWTYPE;
  T_FLAG    VARCHAR2(1) := 'N';
BEGIN
    OPEN GC_CT_DATA_TX_EXIST(P_FILE_ID, P_PROTOCOL, P_PT, P_PATIENT,
                             P_KEY1, P_KEY2, P_KEY3);
    LOOP
      FETCH GC_CT_DATA_TX_EXIST INTO T_REC;
      EXIT WHEN GC_CT_DATA_TX_EXIST%NOTFOUND;
        IF T_REC.DEL_FLAG = 'D' THEN
          T_FLAG := 'N';
          EXIT;
        ELSE
          IF '  '||SUBSTR(P_LINE_TEXT, 24, 32)||SUBSTR(P_LINE_TEXT, 68) =
             '  '||SUBSTR(T_REC.LINE_TEXT, 24, 32)||SUBSTR(T_REC.LINE_TEXT, 68)
          THEN
             T_FLAG := 'Y';
             EXIT;
          END IF;
        END IF;
    END LOOP;
    CLOSE GC_CT_DATA_TX_EXIST;
    RETURN (T_FLAG);
EXCEPTION
  WHEN OTHERS THEN
    IF GC_CT_DATA_TX_EXIST%ISOPEN THEN
      CLOSE GC_CT_DATA_TX_EXIST;
    END IF;
    RAISE;
END;

FUNCTION F_LAB_OTH_UPD
 (P_FILE_ID     IN VARCHAR2
 ,P_PROTOCOL    IN VARCHAR2
 ,P_PT          IN VARCHAR2
 ,P_PATIENT     IN VARCHAR2
 ,P_KEY1        IN VARCHAR2
 ,P_KEY2        IN VARCHAR2
 ,P_KEY3        IN VARCHAR2
 ,P_LINE_TEXT   IN VARCHAR2
 )
 RETURN VARCHAR2
 IS
  T_REC     C_CT_DATA_LAB_OTH%ROWTYPE;
  T_FLAG    VARCHAR2(1) := 'Y';
BEGIN
  OPEN C_CT_DATA_LAB_OTH(P_FILE_ID, P_PROTOCOL, P_PT, P_PATIENT, P_KEY1, P_KEY2, P_KEY3);
  LOOP
    FETCH C_CT_DATA_LAB_OTH INTO T_REC;
    EXIT WHEN C_CT_DATA_LAB_OTH%NOTFOUND;
      IF T_REC.DEL_FLAG = 'D' THEN
        T_FLAG := 'Y';
        EXIT;
      ELSE
        IF '  '||SUBSTR(P_LINE_TEXT, 24, 32)||SUBSTR(P_LINE_TEXT, 68) =
           '  '||SUBSTR(T_REC.LINE_TEXT, 24, 32)||SUBSTR(T_REC.LINE_TEXT, 68)
        THEN
           T_FLAG := 'N';
           EXIT;
        END IF;
      END IF;
  END LOOP;

  CLOSE C_CT_DATA_LAB_OTH;
  RETURN (T_FLAG);
EXCEPTION
  WHEN OTHERS THEN
    IF C_CT_DATA_LAB_OTH%ISOPEN THEN
      CLOSE C_CT_DATA_LAB_OTH;
    END IF;
    RAISE;    -- Failure
END;

------------
PROCEDURE P_EXTRACT_CDUS
 (P_STUDY                         IN VARCHAR2
 ,P_REPORT_TO                     IN VARCHAR2
 ,P_DEBUG_MODE                       IN VARCHAR2 := 'CONT'
 )
 IS
  T_MOD_NAME           VARCHAR2(60)  := 'EXT_DATA_PKG.P_EXTRACT_CDUS';
  T_STEP_NAME          VARCHAR2(30)   := '1';

    T_REPORT_TO   VARCHAR2(30);
    T_REPORT_AS   VARCHAR2(30);
    T_VERSION   VARCHAR2(30);
    T_START_DATE     DATE := SYSDATE;
  T_TEMP               VARCHAR2(1);
BEGIN

    BEGIN
      SELECT '1' INTO T_TEMP
        FROM USER_JOBS
       WHERE WHAT LIKE 'EXT_DATA_PKG.P_EXTRACT%'
         AND NVL(FAILURES, 0) <> 0
         AND ROWNUM = 1;

      RETURN;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
      WHEN OTHERS THEN
        RAISE;
    END;

--step 1-------------------
    T_STEP_NAME := '1';

  BEGIN
    SELECT REPORT_TO, VERSION, REPORT_AS INTO T_REPORT_TO, T_VERSION, T_REPORT_AS
      FROM CT_EXT_STUDY_RPT_CTL
     WHERE OC_STUDY = P_STUDY
       AND REPORT_TO = P_REPORT_TO
       AND ROWNUM = 1;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
  END;

--step 2-------------------
    T_STEP_NAME := '2';

    P_ALL_FILE_CDUS(P_STUDY, T_REPORT_TO, T_VERSION, NULL, P_DEBUG_MODE);
------------
  BEGIN
    SELECT 1 INTO T_TEMP
      FROM CT_EXT_LOGS
     WHERE STUDY = P_STUDY
       AND EXT_STATUS <> 'SUCCESS'
       AND ROWNUM = 1;
      EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, 'ALL', 'ALL', SYSDATE, 'FAIL', T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, 'ALL', 'ALL', SYSDATE, 'SUCCESS', T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);
  END;
-------------
EXCEPTION
  WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20000,'Error occured in '||T_MOD_NAME||
                '--'||T_STEP_NAME||'--'||SQLCODE||'--'||SQLERRM);
END;

PROCEDURE P_ALL_FILE_CDUS
 (P_STUDY             IN VARCHAR2
 ,P_REPORT_TO         IN VARCHAR2
 ,P_VERSION           IN VARCHAR2
 ,P_FILE_ID           IN VARCHAR2
 ,P_DEBUG_MODE        IN VARCHAR2 := 'CONT'
 )
 IS

  T_MOD_NAME           VARCHAR2(60)  := 'EXT_DATA_PKG.P_ALL_CDUS_FILE';
  T_STEP_NAME          VARCHAR2(30)  := '1';
  T_PROC_NAME          VARCHAR2(30);
    T_SQL_ERROR_CODE       CT_EXT_ERRORS.SQL_ERROR_CODE%TYPE;
    T_SQL_ERROR_DESC       CT_EXT_ERRORS.SQL_ERROR_DESC%TYPE;
    T_KEY_VALUE            CT_EXT_ERRORS.KEY_VALUE%TYPE;
    T_CT_ERROR_DESC        CT_EXT_ERRORS.CT_ERROR_DESC%TYPE;

    T_LAST_EXT_DATE        DATE;
    T_CURRENT_EXT_DATE     DATE;
    T_EXT_OWNER            VARCHAR2(30);
    T_EXT_SOURCE           VARCHAR2(30);
    T_CURRENT_EXT_DATE_VAR VARCHAR2(8);
    T_EXT_STATUS           VARCHAR2(30);
    T_START_DATE           DATE := SYSDATE;
    T_TAB_EXT_STATUS       VARCHAR2(30);

    T_CT_TAB               EXT_DATA_PKG.CT_TAB;
    T_EMPTY_TAB            EXT_DATA_PKG.CT_TAB;
    I                      PLS_INTEGER := 0;

    T_CRS                  LONG;
    T_CRS_TYPE             VARCHAR2(30);
    T_FILE_ID              VARCHAR2(30);

  T_CT_CUR      CT_CURTYPE;

BEGIN
    T_EXT_SOURCE := 'N';
-----------------------
T_STEP_NAME := '1';
  BEGIN

    SELECT EXT_OBJECT_OWNER INTO T_EXT_OWNER
      FROM CT_EXT_STUDY_CTL
     WHERE OC_STUDY = P_STUDY;

    FOR THIS_FILE IN (
         SELECT A.* FROM CT_EXT_FILE_CTL A,         -- PRC 06/12/2003: Changed select clause so that the file id's
                         CT_EXT_CRS_CTL B           --     are written to the file in the expected order.
          WHERE A.OC_STUDY  = B.OC_STUDY
            AND A.REPORT_TO = B.REPORT_TO
            AND A.VERSION   = B.VERSION
            AND A.FILE_ID   = B.FILE_ID
            AND A.OC_STUDY  = P_STUDY
            AND A.REPORT_TO = P_REPORT_TO
            AND A.VERSION   = P_VERSION
            AND A.FILE_ID   = NVL(P_FILE_ID, A.FILE_ID)
            AND A.EXT_IND   = 'Y'
          ORDER BY B.EXT_SEQ)               LOOP

        T_LAST_EXT_DATE        := EXT_UTIL_PKG.F_LAST_EXT_DATE(P_STUDY, THIS_FILE.FILE_ID);
        T_CURRENT_EXT_DATE     := EXT_UTIL_PKG.F_CURRENT_EXT_DATE(P_STUDY, THIS_FILE.FILE_ID);
---------
    FOR THIS_CRS IN (SELECT * FROM CT_EXT_CRS_CTL
                   WHERE OC_STUDY = P_STUDY
                     AND REPORT_TO = P_REPORT_TO
                     AND VERSION = P_VERSION
                     AND FILE_ID = THIS_FILE.FILE_ID  )     LOOP
      T_CURRENT_EXT_DATE_VAR := TO_CHAR(T_CURRENT_EXT_DATE, 'RRRRMMDD');
      T_CRS_TYPE  := THIS_CRS.CRS_TYPE;
      T_PROC_NAME  := THIS_CRS.CRS_TYPE;
      T_EXT_SOURCE := THIS_CRS.EXT_SOURCE;
      T_EXT_STATUS := 'PROCESSING';

      T_CRS := THIS_CRS.TEXT;
      T_CRS := REPLACE(THIS_CRS.TEXT, 'PP_EXT_OWNER', T_EXT_OWNER);

      P_ONE_CRS_CDUS(T_CRS, THIS_CRS.CRS_TYPE, P_STUDY, THIS_FILE.FILE_ID, P_VERSION, T_CURRENT_EXT_DATE
               ,T_EXT_OWNER, THIS_CRS.EXT_SOURCE, T_EXT_STATUS, P_DEBUG_MODE);

    END LOOP;
---------

    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
  END;

EXCEPTION
    WHEN OTHERS THEN
        T_SQL_ERROR_CODE    := SQLCODE;
        T_SQL_ERROR_DESC    := SQLERRM;
        T_KEY_VALUE         := NULL;
        T_CT_ERROR_DESC := 'Insert CT_DATA failed @'||T_MOD_NAME||'--'||T_STEP_NAME;
        -- Error handling procedure
        EXT_UTIL_PKG.P_CT_EXT_ERRORS
                    (P_STUDY, 'ALL', T_MOD_NAME, T_STEP_NAME
                    ,T_KEY_VALUE, T_SQL_ERROR_CODE, T_SQL_ERROR_DESC
                    ,T_CT_ERROR_DESC, P_DEBUG_MODE);
END;

PROCEDURE P_ONE_CRS_CDUS
 (P_CRS               IN LONG
 ,P_CRS_TYPE          IN VARCHAR2
 ,P_STUDY             IN VARCHAR2
 ,P_FILE_ID           IN VARCHAR2
 ,P_VERSION           IN VARCHAR2
 ,P_CURRENT_EXT_DATE  IN DATE
 ,P_EXT_OWNER         IN VARCHAR2
 ,P_EXT_SOURCE        IN VARCHAR2
 ,P_EXT_STATUS        IN OUT VARCHAR2
 ,P_DEBUG_MODE        IN VARCHAR2 := 'CONT'
 )
 IS

  T_MOD_NAME           VARCHAR2(60)  := 'EXT_DATA_PKG.P_ONE_CRS_CDUS';
  T_STEP_NAME          VARCHAR2(30)  := '1';
  T_PROC_NAME          VARCHAR2(30);
    T_SQL_ERROR_CODE       CT_EXT_ERRORS.SQL_ERROR_CODE%TYPE;
    T_SQL_ERROR_DESC       CT_EXT_ERRORS.SQL_ERROR_DESC%TYPE;
    T_KEY_VALUE            CT_EXT_ERRORS.KEY_VALUE%TYPE;
    T_CT_ERROR_DESC        CT_EXT_ERRORS.CT_ERROR_DESC%TYPE;
    T_START_DATE           DATE := SYSDATE;
    T_EXT_STATUS           CT_EXT_LOGS.EXT_STATUS%TYPE;
    T_TAB_EXT_STATUS       VARCHAR2(30);
    T_CURRENT_EXT_DATE_VAR VARCHAR2(8);
    T_CT_TAB               EXT_DATA_PKG.CT_TAB;
    T_EMPTY_TAB            EXT_DATA_PKG.CT_TAB;
    I                      PLS_INTEGER := 0;

  T_CT_CUR      CT_CURTYPE;

BEGIN
-----------------------
T_STEP_NAME := '1';          ----process a cursor----
  BEGIN
    G_START_DATE := SYSDATE;
    T_EXT_STATUS := 'PROCESSING';
    T_PROC_NAME  := P_CRS_TYPE;
    EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, P_FILE_ID, T_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);

     OPEN T_CT_CUR FOR P_CRS USING P_FILE_ID, P_VERSION, P_CURRENT_EXT_DATE, P_FILE_ID;

    I := 0;  T_CT_TAB := T_EMPTY_TAB;
    LOOP
      I := I + 1;
      FETCH T_CT_CUR INTO T_CT_TAB(I);
      EXIT WHEN T_CT_CUR%NOTFOUND;
    END LOOP;
    CLOSE T_CT_CUR;

    IF I > 1 THEN
      P_EXT_DATA(P_EXT_SOURCE, T_CT_TAB, P_FILE_ID, P_VERSION, T_PROC_NAME
                ,P_CURRENT_EXT_DATE, P_EXT_STATUS, P_DEBUG_MODE);
    ELSE
      T_EXT_STATUS := 'SUCCESS';
      EXT_UTIL_PKG.P_CT_EXT_LOGS
            (P_STUDY, P_FILE_ID, T_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      IF T_CT_CUR%ISOPEN THEN
          CLOSE T_CT_CUR;
      END IF;
      RAISE;
  END;
-----------------------
  P_EXT_STATUS := 'SUCCESS';
EXCEPTION
    WHEN OTHERS THEN
        T_EXT_STATUS := 'FAIL';
        P_EXT_STATUS := 'FAIL';
        T_SQL_ERROR_CODE    := SQLCODE;
        T_SQL_ERROR_DESC    := SQLERRM;
        T_KEY_VALUE         := NULL;
        T_CT_ERROR_DESC := 'Insert CT_DATA failed @'||T_MOD_NAME||'--'||T_STEP_NAME||'--'||P_FILE_ID;
        -- Error handling procedure
        EXT_UTIL_PKG.P_CT_EXT_LOGS
             (P_STUDY, P_FILE_ID, T_PROC_NAME, P_CURRENT_EXT_DATE, T_EXT_STATUS, T_START_DATE, SYSDATE
            ,NULL, NULL, NULL, NULL, P_DEBUG_MODE);
        EXT_UTIL_PKG.P_CT_EXT_ERRORS
                    (P_STUDY, P_FILE_ID, T_MOD_NAME, T_STEP_NAME
                    ,T_KEY_VALUE, T_SQL_ERROR_CODE, T_SQL_ERROR_DESC
                    ,T_CT_ERROR_DESC, P_DEBUG_MODE);
END;

FUNCTION F_FIELD_POS
 (P_REPORT_TO    IN VARCHAR2
 ,P_VERSION      IN VARCHAR2
 ,P_FILE_ID      IN VARCHAR2
 ,P_POS          IN NUMBER
 )
 RETURN VARCHAR2
 IS
  T_VAR       VARCHAR2(60);
BEGIN
  OPEN C_FIELD_POS(P_REPORT_TO, P_VERSION, P_FILE_ID, P_POS);
  FETCH C_FIELD_POS INTO T_VAR;
  IF C_FIELD_POS%NOTFOUND THEN
    T_VAR := NULL;
  END IF;
  CLOSE C_FIELD_POS;

  RETURN (T_VAR);

EXCEPTION
  WHEN OTHERS THEN
    IF C_FIELD_POS%ISOPEN THEN
      CLOSE C_FIELD_POS;
    END IF;
    RAISE;    -- Failure
END;

------------
-- PL/SQL Block
BEGIN
  G_begin_date := SYSDATE;
END EXT_DATA_PKG;
/


Show Error