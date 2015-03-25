PROMPT Creating Package 'EXTRACT_PKG'
CREATE OR REPLACE PACKAGE EXTRACT_PKG

 IS

-- Sub-Program Unit Declarations
  TYPE CT_CURTYPE IS REF CURSOR;

PROCEDURE P_BATCH_EXTRACT
 (P_STUDY                  IN VARCHAR2
 ,P_REPORT_TO              IN VARCHAR2
 );

PROCEDURE P_UPD_TIMESTAMP
 (P_STUDY                  IN VARCHAR2
 ,P_REPORT_TO              IN VARCHAR2
 );

PROCEDURE P_TRANSFER
 (P_STUDY                  IN VARCHAR2
 ,P_REPORT_TO    IN VARCHAR2
 );

PROCEDURE P_REMOVE
 (P_STUDY                  IN VARCHAR2
 ,P_REPORT_TO              IN VARCHAR2
 );

PROCEDURE P_COMPILE_VW
 (P_STUDY                  IN VARCHAR2
 );

PROCEDURE P_UPD_EXTRACT_MODE
 (P_STUDY                  IN VARCHAR2
 ,P_REPORT_TO              IN VARCHAR2
 ,P_EXTRACT_MODE           IN VARCHAR2
 );

PROCEDURE P_UPD_DATE_GENERATED
 (P_STUDY                  IN VARCHAR2
 ,P_REPORT_TO              IN VARCHAR2
 ,P_VERSION                IN VARCHAR2
 ,P_EXTRACTED              IN DATE
 ,P_DATE_GENERATED         IN DATE
 );

FUNCTION F_LAST_GENERATED
 (P_STUDY                  IN VARCHAR2
 ,P_REPORT_TO              IN VARCHAR2
 ,P_VERSION                IN VARCHAR2
 ,P_EXTRACTED              IN DATE
 ) RETURN DATE;
PRAGMA RESTRICT_REFERENCES (F_LAST_GENERATED, WNDS, WNPS);

FUNCTION F_LAST_EXTRACTED
 (P_STUDY                  IN VARCHAR2
 ,P_REPORT_TO              IN VARCHAR2
 ,P_VERSION                IN VARCHAR2
 ) RETURN DATE;
PRAGMA RESTRICT_REFERENCES (F_LAST_EXTRACTED, WNDS, WNPS);

END;
/

SHOW ERROR

PROMPT Creating Package Body 'EXTRACT_PKG'
CREATE OR REPLACE PACKAGE BODY EXTRACT_PKG

 IS

PROCEDURE P_BATCH_EXTRACT
 (P_STUDY                  IN VARCHAR2
 ,P_REPORT_TO              IN VARCHAR2
 )
 IS
  T_JOB   BINARY_INTEGER;
  T_WHAT  VARCHAR2(240);
  P_EXCEPTION EXCEPTION  ;
BEGIN
  IF P_STUDY IS NULL OR P_REPORT_TO IS NULL THEN
    RETURN;
  END IF;

    BEGIN

      SELECT '1' INTO T_WHAT
        FROM USER_JOBS
       WHERE WHAT LIKE 'EXT_DATA_PKG.P_EXTRACT%'||P_STUDY||'%'||P_REPORT_TO||'%'
         AND ROWNUM = 1;
      RAISE P_EXCEPTION;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
	  WHEN P_EXCEPTION THEN
	     RAISE P_EXCEPTION;
      WHEN OTHERS THEN
	    RAISE;
    END;

	P_COMPILE_VW(P_STUDY);

    IF P_REPORT_TO ='THERADEX' THEN
      T_WHAT := 'EXT_DATA_PKG.P_EXTRACT('''||P_STUDY||''','''||P_REPORT_TO||''', ''Y'', ''Y'', ''Y'', ''Y'', ''CONT'');';
    ELSIF P_REPORT_TO LIKE 'CDUS%' THEN
      T_WHAT := 'EXT_DATA_PKG.P_EXTRACT_CDUS('''||P_STUDY||''','''||P_REPORT_TO||''', ''CONT'');';
    ELSE
      NULL;
    END IF;

	dbms_job.submit(T_JOB, T_WHAT);
    commit;
EXCEPTION
  WHEN P_EXCEPTION THEN
       RAISE_APPLICATION_ERROR(-20000, 'Another process is already extracting the data for this study ');
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000, 'Error occured. Please check with your administrator.');
END;

PROCEDURE P_UPD_TIMESTAMP
 (P_STUDY                  IN VARCHAR2
 ,P_REPORT_TO              IN VARCHAR2
 )
 IS
  T_EXTRACTED   DATE;
  T_STUDY_ACCESS_ACCT_NAME  VARCHAR2(30);
BEGIN

  BEGIN
    SELECT OC_OBJECT_OWNER INTO T_STUDY_ACCESS_ACCT_NAME
      FROM CT_EXT_STUDY_CTL
     WHERE OC_STUDY = P_STUDY
       AND ROWNUM = 1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN;
  END;

  BEGIN
    IF P_REPORT_TO ='THERADEX' THEN
      SELECT NVL(MAX(EXTRACTED), TO_DATE('20020101', 'RRRRMMDD')) INTO T_EXTRACTED
        FROM CT_DATA
       WHERE PROTOCOL = P_STUDY;
    ELSIF P_REPORT_TO ='CDUS' THEN
      SELECT NVL(MAX(EXTRACTED), TO_DATE('20020101', 'RRRRMMDD')) INTO T_EXTRACTED
        FROM CDUS_DATA
       WHERE PROTOCOL = P_STUDY;
    ELSE
      NULL;
    END IF;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      T_EXTRACTED := TO_DATE('1900', 'RRRR');
  END;

  UPDATE CT_EXT_FILE_CTL
     SET LAST_EXT_DATE = DECODE(UPD_LAST_EXT_DATE, 'Y', T_EXTRACTED, LAST_EXT_DATE)
        ,CURRENT_EXT_DATE =
               (SELECT END_FORM_PROCESS_TS
                  FROM STUDY_ACCESS_ACCOUNTS
                 WHERE STUDY_ACCESS_ACCT_NAME = T_STUDY_ACCESS_ACCT_NAME)
   WHERE OC_STUDY  = P_STUDY
     AND REPORT_TO = P_REPORT_TO;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;
END;

PROCEDURE P_TRANSFER
 (P_STUDY        IN VARCHAR2
 ,P_REPORT_TO    IN VARCHAR2
 )
 IS
BEGIN
  IF P_REPORT_TO = 'THERADEX' THEN

      INSERT INTO CT_DATA (
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
                  ,LINE_TEXT
                  ,SUBMISSION_FLAG
                  ,EXT_SOURCE    )
            SELECT
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
                  ,LINE_TEXT
                  ,SUBMISSION_FLAG
                  ,EXT_SOURCE
              FROM CT_EXT_DATA
             WHERE PROTOCOL = P_STUDY
               AND SUBMISSION_FLAG = 1;

     COMMIT;

  ELSIF P_REPORT_TO = 'CDUS' THEN

      INSERT INTO CDUS_DATA (
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
                  ,LINE_TEXT
                  ,SUBMISSION_FLAG
                  ,EXT_SOURCE    )
            SELECT
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
                  ,LINE_TEXT
                  ,SUBMISSION_FLAG
                  ,EXT_SOURCE
              FROM CT_EXT_DATA
             WHERE PROTOCOL = P_STUDY
               AND SUBMISSION_FLAG = 1;

     COMMIT;
  ELSE
    NULL;
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;
END;

PROCEDURE P_REMOVE
 (P_STUDY                  IN VARCHAR2
 ,P_REPORT_TO              IN VARCHAR2
 )
 IS
    T_CURRENT_EXT_DATE    DATE;
BEGIN

  select max(CURRENT_EXT_DATE) INTO T_CURRENT_EXT_DATE
    from ct_ext_FILE_CTL
   WHERE OC_STUDY = P_STUDY
     AND REPORT_TO = P_REPORT_TO;

  IF P_REPORT_TO = 'THERADEX' THEN
    delete from CT_DATA
    where extracted = T_CURRENT_EXT_DATE
      AND PROTOCOL = P_STUDY;
    COMMIT;
  ELSIF P_REPORT_TO = 'CDUS' THEN
    delete from CDUS_DATA
    where extracted = T_CURRENT_EXT_DATE
      AND PROTOCOL = P_STUDY;
    COMMIT;
  ELSE
    NULL;
  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;

PROCEDURE P_COMPILE_VW
 (P_STUDY                  IN VARCHAR2
 )
 IS
    T_EXT_OBJECT_OWNER   VARCHAR2(30);
    T_SQL_STR            VARCHAR2(2000);
    T_VIEW_NAME    VARCHAR2(30);
    T_EXIST   NUMBER := 0;
BEGIN

  FOR T_OWNER IN (SELECT *
                    FROM CT_EXT_STUDY_CTL
                   WHERE OC_STUDY = P_STUDY) LOOP
    FOR II IN 1..4 LOOP
        T_EXIST := 0;
    FOR T_VW IN (SELECT A.*
                   FROM CT_EXT_VW_CTL A
                  WHERE A.OC_STUDY = P_STUDY
                    AND EXISTS (SELECT 1
                                  FROM ALL_OBJECTS B
                                 WHERE B.OWNER = T_OWNER.EXT_OBJECT_OWNER
                                   AND B.OBJECT_NAME = A.VIEW_NAME
                                   AND B.OBJECT_TYPE = 'VIEW'
                                   AND B.STATUS = 'INVALID' )
                  ORDER BY A.CRT_SEQ )     LOOP
          T_EXIST := 1;
          BEGIN
        T_SQL_STR := 'ALTER VIEW '||T_OWNER.EXT_OBJECT_OWNER||'.'||T_VW.VIEW_NAME||' COMPILE';
        EXECUTE IMMEDIATE T_SQL_STR;
          EXCEPTION
            WHEN OTHERS THEN
              IF II < 4 THEN
                NULL;
              ELSE
                RAISE;
              END IF;
          END;
    END LOOP;
        EXIT WHEN T_EXIST = 0;
    END LOOP;
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000, 'Invalid view found. Please check with your administrator.');
END;

PROCEDURE P_UPD_EXTRACT_MODE
 (P_STUDY                  IN VARCHAR2
 ,P_REPORT_TO              IN VARCHAR2
 ,P_EXTRACT_MODE           IN VARCHAR2
 )
 IS
  T_EXTRACTED   DATE;
  T_STUDY_ACCESS_ACCT_NAME  VARCHAR2(30);
BEGIN

  UPDATE CT_EXT_FILE_CTL
     SET EXTRACT_MODE = P_EXTRACT_MODE
   WHERE OC_STUDY  = P_STUDY
     AND REPORT_TO = P_REPORT_TO;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;
END;

PROCEDURE P_UPD_DATE_GENERATED
 (P_STUDY                  IN VARCHAR2
 ,P_REPORT_TO              IN VARCHAR2
 ,P_VERSION                IN VARCHAR2
 ,P_EXTRACTED              IN DATE
 ,P_DATE_GENERATED         IN DATE
 )
 IS
  T_EXTRACTED   DATE;
  T_STUDY_ACCESS_ACCT_NAME  VARCHAR2(30);
BEGIN

  IF UPPER(P_REPORT_TO) = 'CDUS' THEN
    UPDATE CDUS_DATA
       SET DATE_GENERATED = P_DATE_GENERATED
     WHERE PROTOCOL  = P_STUDY
       AND VERSION = P_VERSION
       AND EXTRACTED = P_EXTRACTED;
  ELSIF UPPER(P_REPORT_TO) = 'THERDEX' THEN
    UPDATE CT_DATA
       SET DATE_GENERATED = P_DATE_GENERATED
     WHERE PROTOCOL  = P_STUDY
       AND VERSION = P_VERSION
       AND EXTRACTED = P_EXTRACTED;
  ELSE
    NULL;
  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;
END;

FUNCTION F_LAST_GENERATED
 (P_STUDY                  IN VARCHAR2
 ,P_REPORT_TO              IN VARCHAR2
 ,P_VERSION                IN VARCHAR2
 ,P_EXTRACTED              IN DATE
 ) RETURN DATE
 IS
  T_DATE             DATE;
  T_CUR              CT_CURTYPE;
  T_SQL_STR          VARCHAR2(240) := NULL;
BEGIN
  IF P_REPORT_TO = 'THERADEX' THEN
    T_SQL_STR :=
        'SELECT DATE_GENERATED '||
        '  FROM CT_DATA '||
        ' WHERE PROTOCOL = :P_STUDY '||
        '   AND VERSION = :P_VERSION '||
        '   AND EXTRACTED = :P_EXTRACTED '||
        '   AND DATE_GENERATED IS NOT NULL '||
        '   AND ROWNUM = 1 ';
  ELSIF P_REPORT_TO = 'CDUS' THEN
    T_SQL_STR :=
        'SELECT DATE_GENERATED '||
        '  FROM CDUS_DATA '||
        ' WHERE PROTOCOL = :P_STUDY '||
        '   AND VERSION = :P_VERSION '||
        '   AND EXTRACTED = :P_EXTRACTED '||
        '   AND DATE_GENERATED IS NOT NULL '||
        '   AND ROWNUM = 1 ';
  ELSE
    RETURN(NULL);
  END IF;

  OPEN T_CUR FOR T_SQL_STR USING P_STUDY, P_VERSION, P_EXTRACTED;
  FETCH T_CUR INTO T_DATE;
  IF T_CUR%NOTFOUND THEN
    T_DATE := NULL;    -- Not exist
  END IF;

  CLOSE T_CUR;
  RETURN (T_DATE);
exception
  WHEN OTHERS THEN
    IF T_CUR%ISOPEN THEN
      CLOSE T_CUR;
    END IF;
    RAISE;    -- Failure
End;

FUNCTION F_LAST_EXTRACTED
 (P_STUDY                  IN VARCHAR2
 ,P_REPORT_TO              IN VARCHAR2
 ,P_VERSION                IN VARCHAR2
 ) RETURN DATE
 IS
  T_DATE             DATE;
  T_CUR              CT_CURTYPE;
  T_SQL_STR          VARCHAR2(240) := NULL;
BEGIN
  IF P_REPORT_TO = 'THERADEX' THEN
    T_SQL_STR :=
        'SELECT MAX(EXTRACTED) '||
        '  FROM CT_DATA '||
        ' WHERE PROTOCOL = :P_STUDY '||
        '   AND VERSION = :P_VERSION ';
  ELSIF P_REPORT_TO = 'CDUS' THEN
    T_SQL_STR :=
        'SELECT MAX(EXTRACTED) '||
        '  FROM CDUS_DATA '||
        ' WHERE PROTOCOL = :P_STUDY '||
        '   AND VERSION = :P_VERSION ';
  ELSE
    RETURN(NULL);
  END IF;

  OPEN T_CUR FOR T_SQL_STR USING P_STUDY, P_VERSION;
  FETCH T_CUR INTO T_DATE;
  IF T_CUR%NOTFOUND THEN
    T_DATE := NULL;    -- Not exist
  END IF;

  CLOSE T_CUR;
  RETURN (T_DATE);
exception
  WHEN OTHERS THEN
    IF T_CUR%ISOPEN THEN
      CLOSE T_CUR;
    END IF;
    RAISE;    -- Failure
End;

BEGIN
  NULL;
END;
/
SHOW ERROR
