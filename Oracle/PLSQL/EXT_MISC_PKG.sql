PROMPT Creating Package 'EXT_MISC_PKG'
CREATE OR REPLACE PACKAGE CTEXT.EXT_MISC_PKG

 IS
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/*     Author: Patrick Conrad- Ekagra Software Technologies (Original Unknown)       */
/*       Date: 03/15/2004 (Original Unknown)                                         */
/*Description: (Original Description Missing)                                        */
/*             This process is used by the various Data Extract Packages for the     */
/*             extract of study specific data in order to report to external bodies. */
/*             The particular package contains various function and procedures for   */
/*             setting up studies and manipulating data.                             */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/*  Modification History                                                             */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/*  PRC 02/15/2004 : Added section of code to first check for, then insert OC_OBJ_CTL*/
/*                 : records, prior to calling for the creation of OC synonyms.      */
/*                 : Modification made in procedure "P_CRT_STUDY_OC_SYN".            */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

-- Sub-Program Unit Declarations
FUNCTION F_LPARM_STR
 (P_FILE_ID        IN VARCHAR2
 ,P_FIELD_NAME     IN VARCHAR2
 )
 RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES (F_LPARM_STR, WNDS, WNPS);

FUNCTION F_LPARM_STR_VW
 (P_FILE_ID        IN VARCHAR2
 ,P_FIELD_NAME     IN VARCHAR2
 )
 RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES (F_LPARM_STR_VW, WNDS, WNPS);

FUNCTION F_LPARM_STR_VW_FUL
 (P_FILE_ID        IN VARCHAR2
 ,P_FIELD_NAME     IN VARCHAR2
 )
 RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES (F_LPARM_STR_VW_FUL, WNDS, WNPS);

FUNCTION F_FIELD
 (P_FILE_ID      IN VARCHAR2
 ,P_POS          IN NUMBER
 ,P_EXT_LAB_SRC  IN VARCHAR2
 ,P_EXT_TYPE        IN VARCHAR2
 ,P_REPORT_TO    IN VARCHAR2
 ,P_STUDY_NAME   IN VARCHAR2
 )
 RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES (F_FIELD, WNDS, WNPS);

PROCEDURE EXT_CHECK_PROC
 (P_WHAT            IN VARCHAR2
 ,P_EXT_LAB_SRC     IN VARCHAR2
 ,P_CHECK_SRC       IN VARCHAR2
 ,P_EXT_DATE        IN DATE
 ,P_EXT_TYPE        IN VARCHAR2
 ,P_REPORT_TO    IN VARCHAR2
 ,P_STUDY_NAME   IN VARCHAR2);

PROCEDURE P_CRT_STUDY_VW
 (P_STUDY             IN VARCHAR2
 ,P_UPD_LAB_OTH_TEXT  IN VARCHAR2
 ,P_VERSION           IN VARCHAR2);

PROCEDURE P_PROC_STUDY_TAB
 (P_STUDY             IN VARCHAR2
 ,P_VIEW_NAME         IN VARCHAR2
 ,P_TABLE_NAME        IN VARCHAR2);

PROCEDURE P_GEN_LAB_OTH_VW_TEXT
 (P_STUDY     IN VARCHAR2
 ,P_VERSION   IN VARCHAR2);

PROCEDURE P_CRT_STUDY_OC_SYN
 (P_STUDY             IN VARCHAR2);

END;
/
SHOW ERROR


PROMPT Creating Package Body 'EXT_MISC_PKG'
CREATE OR REPLACE PACKAGE BODY CTEXT.EXT_MISC_PKG

 IS

-- PL/SQL Private Declaration
CURSOR GC_LPARM_STR(P_FILE_ID        IN VARCHAR2
                   ,P_FIELD_NAME     IN VARCHAR2) IS
    SELECT DISTINCT NVL(PANEL, 0) PANEL, OC_LAB_QUESTION
      FROM NCI_LABTEST_MAPPING
     WHERE FILE_ID = P_FILE_ID
       AND FIELD_NAME = P_FIELD_NAME
       AND TRIM(OC_LAB_QUESTION) IS NOT NULL
    ORDER BY 1;

CURSOR GC_CHECK_MAPPING(P_FILE_ID        IN VARCHAR2
                       ,P_FIELD_NAME     IN VARCHAR2) IS
   SELECT PANEL
      FROM (
            SELECT DISTINCT NVL(PANEL, 0) PANEL, OC_LAB_QUESTION
              FROM NCI_LABTEST_MAPPING
             WHERE FILE_ID = P_FILE_ID
               AND FIELD_NAME = P_FIELD_NAME
               AND TRIM(OC_LAB_QUESTION) IS NOT NULL)
    HAVING COUNT(*) > 1
    GROUP BY PANEL;

  CURSOR C_FIELD(P_FILE_ID IN VARCHAR2, P_POS IN NUMBER,
                 P_REPORT_TO IN VARCHAR2, P_STUDY_NAME IN VARCHAR2) IS
     SELECT *
       FROM (
         SELECT A.FILE_ID
               ,A.FIELD_NAME
               ,A.FIELD_SEQ
               ,A.START_POS
               ,A.FIELD_LENGTH
               ,A.VIEW_NAME
               ,A.FIELD_TYPE
               ,A.FIELD_PRECISION
               ,A.REPORT_TO
               ,A.VERSION
               ,B.EXT_VIEW_NAME
               ,B.EXT_COLUMN_NAME
               ,B.EXT_FIELD_FUNC
               ,B.OTH_VIEW_NAME
               ,B.OTH_COLUMN_NAME
               ,B.OTH_FIELD_FUNC
               ,B.EXT_COLUMN_NAME_FUL
               ,B.EXT_FIELD_FUNC_FUL
               ,B.OTH_COLUMN_NAME_FUL
               ,B.OTH_FIELD_FUNC_FUL
               ,B.STUDY_NAME
          FROM CT_DATA_VW_CTL A,
               CT_DATA_MAP_CTL B
         WHERE A.REPORT_TO = B.REPORT_TO
           AND A.FILE_ID = B.FILE_ID
           AND A.FIELD_NAME = B.FIELD_NAME
           AND A.VERSION = B.VERSION
           AND B.STUDY_NAME = P_STUDY_NAME)
      WHERE FILE_ID = P_FILE_ID
        AND P_POS BETWEEN START_POS AND (START_POS + FIELD_LENGTH -1)
        AND REPORT_TO = P_REPORT_TO
        AND ROWNUM = 1;

-- Program Data
G_FATAL_ERR EXCEPTION;

-- Sub-Program Units

FUNCTION F_LPARM_STR
 (P_FILE_ID        IN VARCHAR2
 ,P_FIELD_NAME     IN VARCHAR2
 )
 RETURN VARCHAR2
 IS
  T_COUNT     NUMBER := 0;
  T_LPARM_STR   VARCHAR2(2400) := NULL;
  T_LPARM       VARCHAR2(2400) := NULL;
  T_PANEL       NUMBER := 0;
  T_COLUMN_NAME VARCHAR2(60) := NULL;
  T_LENGTH      NUMBER := 0;
BEGIN

  BEGIN
    OPEN GC_CHECK_MAPPING(P_FILE_ID, P_FIELD_NAME);
    FETCH GC_CHECK_MAPPING INTO T_PANEL;
    IF GC_CHECK_MAPPING%NOTFOUND THEN
        CLOSE GC_CHECK_MAPPING;
    ELSE
        CLOSE GC_CHECK_MAPPING;
        RAISE G_FATAL_ERR;
    END IF;

  EXCEPTION
    WHEN G_FATAL_ERR THEN
        RAISE_APPLICATION_ERROR(-20000, 'More than one mappings to a panel');
  END;

  OPEN GC_LPARM_STR(P_FILE_ID, P_FIELD_NAME);
  LOOP
    FETCH GC_LPARM_STR INTO T_PANEL, T_LPARM;
    EXIT WHEN GC_LPARM_STR%NOTFOUND;
    T_COUNT := T_COUNT + 1;
    IF T_COUNT > 1 THEN
      T_LPARM := TRIM(T_LPARM);
      T_LPARM_STR := T_LPARM_STR||'
                       ,'||T_PANEL||', DECODE(LPARM_FUL,'''||T_LPARM||''',SUBSTR(LVALUE_FUL, 1, 20),NULL)';
    ELSE
      T_LPARM := TRIM(T_LPARM);
      T_LPARM_STR := T_PANEL||', DECODE(LPARM_FUL,'''||T_LPARM||''',SUBSTR(LVALUE_FUL, 1, 20),NULL)';
    END IF;
  END LOOP;
  CLOSE GC_LPARM_STR;
  T_COLUMN_NAME := P_FILE_ID||'_'||P_FIELD_NAME;
  IF T_LPARM_STR IS NULL THEN
    RETURN(RPAD('      ,max(decode(1, 2, '' '', '' ''))', 90, ' ')||T_COLUMN_NAME);
  ELSE
    IF T_COUNT > 1 THEN
      RETURN('      ,max(DECODE(PANEL,'||T_LPARM_STR||'
                       ,NULL))'||RPAD(' ', 60, ' ')||T_COLUMN_NAME);
    ELSE
      T_LENGTH := 95 - LENGTH('      ,max(DECODE(PANEL,'||T_LPARM_STR||',NULL))');
      RETURN('      ,max(DECODE(PANEL,'||T_LPARM_STR||',NULL))  '||LPAD(' ',T_LENGTH, ' ')||T_COLUMN_NAME);
    END IF;
  END IF;

exception
  WHEN OTHERS THEN
    IF GC_LPARM_STR%ISOPEN THEN
      CLOSE GC_LPARM_STR;
    END IF;
    IF GC_CHECK_MAPPING%ISOPEN THEN
      CLOSE GC_CHECK_MAPPING;
    END IF;
    RAISE;    -- Failure
End;

FUNCTION F_LPARM_STR_VW
 (P_FILE_ID        IN VARCHAR2
 ,P_FIELD_NAME     IN VARCHAR2
 )
 RETURN VARCHAR2
 IS
  T_COUNT     NUMBER := 0;
  T_LPARM_STR       VARCHAR2(2400) := NULL;
  T_RANGE_IND_STR   VARCHAR2(2400) := NULL;
  T_GRADE_STR       VARCHAR2(2400) := NULL;
  T_LPARM       VARCHAR2(2400) := NULL;
  T_PANEL       NUMBER := 0;
  T_COLUMN_NAME VARCHAR2(60) := NULL;
  T_LENGTH      NUMBER := 0;
BEGIN

  BEGIN
    OPEN GC_CHECK_MAPPING(P_FILE_ID, P_FIELD_NAME);
    FETCH GC_CHECK_MAPPING INTO T_PANEL;
    IF GC_CHECK_MAPPING%NOTFOUND THEN
        CLOSE GC_CHECK_MAPPING;
    ELSE
        CLOSE GC_CHECK_MAPPING;
        RAISE G_FATAL_ERR;
    END IF;

  EXCEPTION
    WHEN G_FATAL_ERR THEN
        RAISE_APPLICATION_ERROR(-20000, 'More than one mappings to a panel');
  END;

  OPEN GC_LPARM_STR(P_FILE_ID, P_FIELD_NAME);
  LOOP
    FETCH GC_LPARM_STR INTO T_PANEL, T_LPARM;
    EXIT WHEN GC_LPARM_STR%NOTFOUND;
    T_COUNT := T_COUNT + 1;
    IF T_COUNT > 1 THEN
      T_LPARM := TRIM(T_LPARM);
      T_LPARM_STR := T_LPARM_STR||'
                       ,'||T_PANEL||', DECODE(LPARM,'''||T_LPARM||''',LVALUE,NULL)';
      T_RANGE_IND_STR := T_RANGE_IND_STR||'
                       ,'||T_PANEL||', DECODE(LPARM,'''||T_LPARM||''',LAB_RANGE_IND,NULL)';
      T_GRADE_STR := T_GRADE_STR||'
                       ,'||T_PANEL||', DECODE(LPARM,'''||T_LPARM||''',CTC_GRADE,NULL)';
    ELSE
      T_LPARM := TRIM(T_LPARM);
      T_LPARM_STR := T_PANEL||', DECODE(LPARM,'''||T_LPARM||''',LVALUE,NULL)';
      T_RANGE_IND_STR := T_PANEL||', DECODE(LPARM,'''||T_LPARM||''',LAB_RANGE_IND,NULL)';
      T_GRADE_STR := T_PANEL||', DECODE(LPARM,'''||T_LPARM||''',CTC_GRADE,NULL)';
    END IF;
  END LOOP;
  CLOSE GC_LPARM_STR;
  T_COLUMN_NAME := P_FIELD_NAME;
  IF T_LPARM_STR IS NULL THEN
    RETURN(RPAD('      ,NULL', 90, ' ')||T_COLUMN_NAME||'
'||RPAD('      ,NULL', 90, ' ')||T_COLUMN_NAME||'_RANG_IND'||'
'||RPAD('      ,NULL', 90, ' ')||T_COLUMN_NAME||'_GRADE');
  ELSE
    IF T_COUNT > 1 THEN
      RETURN('      ,max(DECODE(PANEL,'||T_LPARM_STR||'
                       ,NULL))'||RPAD(' ', 60, ' ')||T_COLUMN_NAME||'
'||'      ,max(DECODE(PANEL,'||T_RANGE_IND_STR||'
                       ,NULL))'||RPAD(' ', 60, ' ')||T_COLUMN_NAME||'_RANG_IND'||'
'||'      ,max(DECODE(PANEL,'||T_GRADE_STR||'
                       ,NULL))'||RPAD(' ', 60, ' ')||T_COLUMN_NAME||'_GRADE');
    ELSE
      T_LENGTH := 100 - LENGTH('      ,max(DECODE(PANEL,'||T_LPARM_STR||',NULL))');
      RETURN('      ,max(DECODE(PANEL,'||T_LPARM_STR||',NULL))  '||LPAD(' ',T_LENGTH, ' ')||T_COLUMN_NAME||'
'||'      ,max(DECODE(PANEL,'||T_RANGE_IND_STR||',NULL))  '||LPAD(' ',T_LENGTH, ' ')||T_COLUMN_NAME||'_RANG_IND'||'
'||'      ,max(DECODE(PANEL,'||T_GRADE_STR||',NULL))  '||LPAD(' ',T_LENGTH, ' ')||T_COLUMN_NAME||'_GRADE');
    END IF;
  END IF;

exception
  WHEN OTHERS THEN
    IF GC_LPARM_STR%ISOPEN THEN
      CLOSE GC_LPARM_STR;
    END IF;
    IF GC_CHECK_MAPPING%ISOPEN THEN
      CLOSE GC_CHECK_MAPPING;
    END IF;
    RAISE;    -- Failure
End;

FUNCTION F_LPARM_STR_VW_FUL
 (P_FILE_ID        IN VARCHAR2
 ,P_FIELD_NAME     IN VARCHAR2
 )
 RETURN VARCHAR2
 IS
  T_COUNT     NUMBER := 0;
  T_LPARM_STR       VARCHAR2(2400) := NULL;
  T_RANGE_IND_STR   VARCHAR2(2400) := NULL;
  T_GRADE_STR       VARCHAR2(2400) := NULL;
  T_LPARM       VARCHAR2(2400) := NULL;
  T_PANEL       NUMBER := 0;
  T_COLUMN_NAME VARCHAR2(60) := NULL;
  T_LENGTH      NUMBER := 0;
BEGIN

  BEGIN
    OPEN GC_CHECK_MAPPING(P_FILE_ID, P_FIELD_NAME);
    FETCH GC_CHECK_MAPPING INTO T_PANEL;
    IF GC_CHECK_MAPPING%NOTFOUND THEN
        CLOSE GC_CHECK_MAPPING;
    ELSE
        CLOSE GC_CHECK_MAPPING;
        RAISE G_FATAL_ERR;
    END IF;

  EXCEPTION
    WHEN G_FATAL_ERR THEN
        RAISE_APPLICATION_ERROR(-20000, 'More than one mappings to a panel');
  END;

  OPEN GC_LPARM_STR(P_FILE_ID, P_FIELD_NAME);
  LOOP
    FETCH GC_LPARM_STR INTO T_PANEL, T_LPARM;
    EXIT WHEN GC_LPARM_STR%NOTFOUND;
    T_COUNT := T_COUNT + 1;
    IF T_COUNT > 1 THEN
      T_LPARM := TRIM(T_LPARM);
      T_LPARM_STR := T_LPARM_STR||'
                       ,'||T_PANEL||', DECODE(LPARM_FUL,'''||T_LPARM||''',SUBSTR(LVALUE_FUL, 1, 20),NULL)';
      T_RANGE_IND_STR := T_RANGE_IND_STR||'
                       ,'||T_PANEL||', DECODE(LPARM_FUL,'''||T_LPARM||''',LAB_RANGE_IND,NULL)';
      T_GRADE_STR := T_GRADE_STR||'
                       ,'||T_PANEL||', DECODE(LPARM_FUL,'''||T_LPARM||''',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL)';
    ELSE
      T_LPARM := TRIM(T_LPARM);
      T_LPARM_STR := T_PANEL||', DECODE(LPARM_FUL,'''||T_LPARM||''',SUBSTR(LVALUE_FUL, 1, 20),NULL)';
      T_RANGE_IND_STR := T_PANEL||', DECODE(LPARM_FUL,'''||T_LPARM||''',LAB_RANGE_IND,NULL)';
      T_GRADE_STR := T_PANEL||', DECODE(LPARM_FUL,'''||T_LPARM||''',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL)';
    END IF;
  END LOOP;
  CLOSE GC_LPARM_STR;
  T_COLUMN_NAME := P_FIELD_NAME;
  IF T_LPARM_STR IS NULL THEN
    RETURN(RPAD('      ,NULL', 90, ' ')||T_COLUMN_NAME||'_FUL'||'
'||RPAD('      ,NULL', 90, ' ')||T_COLUMN_NAME||'_RANG_IND'||'
'||RPAD('      ,NULL', 90, ' ')||T_COLUMN_NAME||'_GRADE_FUL');
  ELSE
    IF T_COUNT > 1 THEN
      RETURN('      ,max(DECODE(PANEL,'||T_LPARM_STR||'
                       ,NULL))'||RPAD(' ', 60, ' ')||T_COLUMN_NAME||'_FUL'||'
'||'      ,max(DECODE(PANEL,'||T_RANGE_IND_STR||'
                       ,NULL))'||RPAD(' ', 60, ' ')||T_COLUMN_NAME||'_RANG_IND'||'
'||'      ,max(DECODE(PANEL,'||T_GRADE_STR||'
                       ,NULL))'||RPAD(' ', 60, ' ')||T_COLUMN_NAME||'_GRADE_FUL');
    ELSE
      T_LENGTH := 100 - LENGTH('      ,max(DECODE(PANEL,'||T_LPARM_STR||',NULL))');
      RETURN('      ,max(DECODE(PANEL,'||T_LPARM_STR||',NULL))  '||LPAD(' ',T_LENGTH, ' ')||T_COLUMN_NAME||'_FUL'||'
'||'      ,max(DECODE(PANEL,'||T_RANGE_IND_STR||',NULL))  '||LPAD(' ',T_LENGTH, ' ')||T_COLUMN_NAME||'_RANG_IND'||'
'||'      ,max(DECODE(PANEL,'||T_GRADE_STR||',NULL))  '||LPAD(' ',T_LENGTH, ' ')||T_COLUMN_NAME||'_GRADE_FUL');
    END IF;
  END IF;

exception
  WHEN OTHERS THEN
    IF GC_LPARM_STR%ISOPEN THEN
      CLOSE GC_LPARM_STR;
    END IF;
    IF GC_CHECK_MAPPING%ISOPEN THEN
      CLOSE GC_CHECK_MAPPING;
    END IF;
    RAISE;    -- Failure
End;

FUNCTION F_FIELD
 (P_FILE_ID      IN VARCHAR2
 ,P_POS          IN NUMBER
 ,P_EXT_LAB_SRC  IN VARCHAR2
 ,P_EXT_TYPE        IN VARCHAR2
 ,P_REPORT_TO    IN VARCHAR2
 ,P_STUDY_NAME    IN VARCHAR2
 )
 RETURN VARCHAR2
 IS
  T_REC       C_FIELD%ROWTYPE;
BEGIN
  OPEN C_FIELD(P_FILE_ID, P_POS, P_REPORT_TO, P_STUDY_NAME);
  FETCH C_FIELD INTO T_REC;
  IF C_FIELD%NOTFOUND THEN
    CLOSE C_FIELD;
    RETURN (NULL);
  ELSE
    CLOSE C_FIELD;
    IF TRIM(T_REC.FIELD_NAME) IS NULL THEN
      RETURN (NULL);
    ELSE
      IF UPPER(P_EXT_LAB_SRC) = 'NORMAL' THEN
        IF UPPER(P_EXT_TYPE) = 'NORMAL' THEN
          RETURN (T_REC.FIELD_NAME||'+'||T_REC.EXT_VIEW_NAME||'='||T_REC.EXT_COLUMN_NAME||'@'||T_REC.EXT_FIELD_FUNC);
        ELSE
          RETURN (T_REC.FIELD_NAME||'+'||T_REC.EXT_VIEW_NAME||'='||T_REC.EXT_COLUMN_NAME_FUL||'@'||T_REC.EXT_FIELD_FUNC_FUL);
        END IF;
      ELSE
        IF UPPER(P_EXT_TYPE) = 'NORMAL' THEN
          RETURN (T_REC.FIELD_NAME||'+'||T_REC.OTH_VIEW_NAME||'='||T_REC.OTH_COLUMN_NAME||'@'||T_REC.OTH_FIELD_FUNC);
        ELSE
          RETURN (T_REC.FIELD_NAME||'+'||T_REC.OTH_VIEW_NAME||'='||T_REC.OTH_COLUMN_NAME_FUL||'@'||T_REC.OTH_FIELD_FUNC_FUL);
        END IF;
      END IF;
    END IF;
  END IF;
exception
  WHEN OTHERS THEN
    IF C_FIELD%ISOPEN THEN
      CLOSE C_FIELD;
    END IF;
    RAISE;    -- Failure
End;

PROCEDURE EXT_CHECK_PROC
 (P_WHAT            IN VARCHAR2
 ,P_EXT_LAB_SRC     IN VARCHAR2
 ,P_CHECK_SRC       IN VARCHAR2
 ,P_EXT_DATE        IN DATE
 ,P_EXT_TYPE        IN VARCHAR2
 ,P_REPORT_TO     IN VARCHAR2
 ,P_STUDY_NAME    IN VARCHAR2) AS
  T_LINE_TEXT VARCHAR2(4000);
  T_POS   NUMBER := 0;
  T_WHAT_LENGTH  NUMBER := NVL(LENGTH(RTRIM(P_WHAT)), 0);
  T_GLOBAL_POS   NUMBER := 0;
  T_FIELD        VARCHAR2(240);
  T_EXT_VIEW_NAME   VARCHAR2(240) := NULL;
  T_EXT_COLUMN_NAME VARCHAR2(240) := NULL;
  T_EXT_FIELD_FUNC  VARCHAR2(240) := NULL;
  T_FIELD_NAME VARCHAR2(240) := NULL;
  T_COL_FUNC   VARCHAR2(240) := NULL;
  T_COUNT1     NUMBER := 0;
  T_COUNT2     NUMBER := 0;
  T_COUNT3     NUMBER := 0;
  I            NUMBER := 0;

  TYPE CurTyp IS REF CURSOR;
  T_CUR        CurTyp;
  T_DATA_CUR   CurTyp;

  TYPE TAB_VAR_TYPE IS TABLE OF VARCHAR2(240)
      INDEX BY BINARY_INTEGER;

  T_TAB_FIELD             TAB_VAR_TYPE;
  T_TAB_EXT_VIEW_NAME     TAB_VAR_TYPE;
  T_TAB_EXT_COLUMN_NAME   TAB_VAR_TYPE;
  T_TAB_EXT_FIELD_FUNC    TAB_VAR_TYPE;
  T_TAB_FIELD_NAME        TAB_VAR_TYPE;
  T_TAB_PT                TAB_VAR_TYPE;
  T_TAB_DOCNUM            TAB_VAR_TYPE;

  T_FIELD_VALUE       VARCHAR2(200);
  T_FIELD_FUNC_VALUE  VARCHAR2(200);
  T_SQL_STR           VARCHAR2(2000);
  T_KEY               VARCHAR2(240);
  T_STEP              VARCHAR2(30) := '1';
  T_REC_FLAG          NUMBER := 0;
  T_LINE              CT_DATA%ROWTYPE;
BEGIN
  IF P_CHECK_SRC = 'STAGE' THEN
    T_SQL_STR := 'SELECT * FROM CT_EXT_DATA WHERE EXTRACTED = :S ORDER BY FILE_ID';
  ELSE
    T_SQL_STR := 'SELECT * FROM CT_DATA WHERE EXTRACTED = :S ORDER BY FILE_ID';
  END IF;

  OPEN T_DATA_CUR FOR T_SQL_STR USING P_EXT_DATE;
  LOOP

    FETCH T_DATA_CUR INTO T_LINE;
    EXIT WHEN T_DATA_CUR%NOTFOUND;

    T_KEY := T_STEP||' - '||T_LINE.FILE_ID||' - '||T_LINE.PT;
    T_LINE_TEXT := T_LINE.LINE_TEXT;
    T_POS := 1;
    T_GLOBAL_POS := 0;
    LOOP
      T_LINE_TEXT := SUBSTR(T_LINE_TEXT, T_POS);
      T_POS := INSTR(T_LINE_TEXT, P_WHAT);
      EXIT WHEN NVL(T_POS, 0) = 0;

      IF NVL(T_POS, 0) <> 0 THEN
          T_GLOBAL_POS := T_GLOBAL_POS + T_POS + T_WHAT_LENGTH - 1;
          T_FIELD := F_FIELD(T_LINE.FILE_ID, T_GLOBAL_POS, P_EXT_LAB_SRC, P_EXT_TYPE, P_REPORT_TO, P_STUDY_NAME);
          IF T_FIELD IS NOT NULL THEN
              T_COUNT1 := NVL(INSTR(T_FIELD, '+'), 0);
              T_COUNT2 := NVL(INSTR(T_FIELD, '='), 0);
              T_COUNT3 := NVL(INSTR(T_FIELD, '@'), 0);

              IF T_COUNT1 = 1 THEN
                T_FIELD_NAME := NULL;
              ELSE
                T_FIELD_NAME := SUBSTR(T_FIELD, 1, T_COUNT1 - 1);
              END IF;

              IF T_COUNT2 - T_COUNT1 = 1 THEN
                T_EXT_VIEW_NAME := NULL;
              ELSE
                 T_EXT_VIEW_NAME  := SUBSTR(T_FIELD, T_COUNT1 + 1, T_COUNT2 - T_COUNT1 - 1);
              END IF;

              IF T_COUNT3 - T_COUNT2 = 1 THEN
                T_EXT_COLUMN_NAME := NULL;
              ELSE
                 T_EXT_COLUMN_NAME  := SUBSTR(T_FIELD, T_COUNT2 + 1, T_COUNT3 - T_COUNT2 - 1);
              END IF;

              T_EXT_FIELD_FUNC  := SUBSTR(T_FIELD, T_COUNT3 + 1);
              IF T_FIELD_NAME IS NOT NULL THEN
                I := I + 1;
                T_TAB_FIELD(I)     := T_LINE.FILE_ID||' + '||T_LINE.PT||' = '||T_LINE.DOCNUM||' @ '||T_FIELD_NAME;
                T_TAB_EXT_VIEW_NAME(I)  := T_EXT_VIEW_NAME;
                T_TAB_EXT_COLUMN_NAME(I) := T_EXT_COLUMN_NAME;
                T_TAB_EXT_FIELD_FUNC(I) := T_EXT_FIELD_FUNC;
                T_TAB_FIELD_NAME(I)   := T_FIELD_NAME;
                T_TAB_PT(I)           := T_LINE.PT;
                T_TAB_DOCNUM(I)       := T_LINE.DOCNUM;
              END IF;
          END IF;
      END IF;

      T_POS := T_POS + T_WHAT_LENGTH;
    END LOOP;
  END LOOP;
  CLOSE T_DATA_CUR;
--------------------------------
  T_STEP := '2';
  IF NVL(T_TAB_FIELD.LAST, 0) <> 0 THEN
     FOR II IN NVL(T_TAB_FIELD.FIRST, 0)..NVL(T_TAB_FIELD.LAST, 0) LOOP
       IF T_TAB_FIELD.EXISTS(II) THEN
         IF II < NVL(T_TAB_FIELD.LAST, 0) THEN
           FOR III IN (II + 1)..NVL(T_TAB_FIELD.LAST, 0) LOOP
             IF T_TAB_FIELD(III) = T_TAB_FIELD(II) THEN
               T_TAB_FIELD.DELETE(III);
             END IF;
           END LOOP;
         END IF;
       END IF;
     END LOOP;
  END IF;
-----------------------------------
  T_STEP := '3';
  IF NVL(T_TAB_FIELD.LAST, 0) <> 0 THEN
     FOR IIII IN NVL(T_TAB_FIELD.FIRST, 0)..NVL(T_TAB_FIELD.LAST, 0) LOOP
       IF T_TAB_FIELD.EXISTS(IIII) THEN
         IF T_TAB_EXT_FIELD_FUNC(IIII) IS NOT NULL AND T_TAB_EXT_VIEW_NAME(IIII) IS NOT NULL THEN
           BEGIN
             T_SQL_STR :=
                      'SELECT '||T_TAB_EXT_COLUMN_NAME(IIII)||','||T_TAB_EXT_FIELD_FUNC(IIII)||
                       ' FROM '||T_TAB_EXT_VIEW_NAME(IIII)||
                      ' WHERE PT = '||''''||T_TAB_PT(IIII)||''''||
                        ' AND DOCNUM = '||''''||T_TAB_DOCNUM(IIII)||'''';
             T_KEY := T_STEP||' - '||SUBSTR(T_TAB_FIELD(IIII), 1, 2)||' + '||T_TAB_EXT_COLUMN_NAME(IIII)||' + '||
                        T_TAB_PT(IIII)||' + '||T_TAB_DOCNUM(IIII);
             OPEN T_CUR FOR T_SQL_STR;
             I := 0;
             T_REC_FLAG := 0;
             LOOP
               T_FIELD_VALUE := NULL;
               T_FIELD_FUNC_VALUE := NULL;
               FETCH T_CUR INTO T_FIELD_VALUE, T_FIELD_FUNC_VALUE;
               EXIT WHEN T_CUR%NOTFOUND;
               T_REC_FLAG := T_REC_FLAG + 1;
               IF TRIM(T_FIELD_FUNC_VALUE) = TRIM(P_WHAT) THEN
                 I := I + 1;
                   DBMS_OUTPUT.PUT_LINE(SUBSTR(T_TAB_FIELD(IIII), 1, 2)||' + '||T_TAB_FIELD_NAME(IIII)||' + '||
                                  T_TAB_PT(IIII)||' + '||T_TAB_DOCNUM(IIII)||' + '||P_EXT_LAB_SRC||
                                  ' => '||P_WHAT||' ---- '||T_FIELD_VALUE);
               END IF;
             END LOOP;
             CLOSE T_CUR;
             IF T_REC_FLAG > 0 THEN
               IF I = 0 THEN
                 DBMS_OUTPUT.PUT_LINE(SUBSTR(T_TAB_FIELD(IIII), 1, 2)||' + '||T_TAB_FIELD_NAME(IIII)||' + '||
                                  T_TAB_PT(IIII)||' + '||T_TAB_DOCNUM(IIII)||' + '||P_EXT_LAB_SRC||
                                  ' => '||P_WHAT||' ---- '||'no data found');
               END IF;
             END IF;
           EXCEPTION
             WHEN OTHERS THEN
               IF T_CUR%ISOPEN THEN
                 CLOSE T_CUR;
               END IF;
               RAISE;
           END;
         ELSE
             DBMS_OUTPUT.PUT_LINE(SUBSTR(T_TAB_FIELD(IIII), 1, 2)||' + '||T_TAB_FIELD_NAME(IIII)||' + '||
                                  T_TAB_PT(IIII)||' + '||T_TAB_DOCNUM(IIII)||' + '||P_EXT_LAB_SRC||
                                  ' => '||P_WHAT||' ---- '||'no mapping found - ');
         END IF;
       END IF;
     END LOOP;
  END IF;

EXCEPTION
  WHEN OTHERS THEN
       IF T_DATA_CUR%ISOPEN THEN
           CLOSE T_DATA_CUR;
       END IF;
       RAISE_APPLICATION_ERROR(-20000, SQLERRM||' - '||T_KEY);
END;

PROCEDURE P_CT_EXT_DATA_UPD
 (P_FILE_ID         IN VARCHAR2)
 IS

  CURSOR C_CT_DATA_EXIST
         (P_FILE_ID IN VARCHAR2, P_PROTOCOL IN VARCHAR2
         ,P_PT IN VARCHAR2, P_PATIENT IN VARCHAR2
         ,P_KEY1 IN VARCHAR2, P_KEY2 IN VARCHAR2, P_KEY3 IN VARCHAR2
         ,P_KEY4 IN VARCHAR2, P_KEY5 IN VARCHAR2) IS
       select *
         FROM CT_DATA_LAST_EXT
        WHERE FILE_ID = P_FILE_ID
          AND PROTOCOL = P_PROTOCOL
          AND PT = P_PT
          AND PATIENT = P_PATIENT
          AND '*'||KEY1 = '*'||P_KEY1
          AND '*'||KEY2 = '*'||P_KEY2
          AND '*'||KEY3 = '*'||P_KEY3
          AND '*'||KEY4 = '*'||P_KEY4
          AND '*'||KEY5 = '*'||P_KEY5
          AND EXT_SOURCE = 'N';


  T_REC     C_CT_DATA_EXIST%ROWTYPE;
  T_FLAG    VARCHAR2(1) := 'Y';
BEGIN
  FOR TT IN (SELECT A.ROWID A_ROWID, A.*
               FROM CT_EXT_DATA A
              WHERE A.FILE_ID = NVL(P_FILE_ID, A.FILE_ID)
                AND A.SUBMISSION_FLAG = 1
                AND A.EXT_SOURCE = 'N'
                AND A.DEL_FLAG <> 'D') LOOP

    T_FLAG := 'Y';

    OPEN C_CT_DATA_EXIST(TT.FILE_ID, TT.PROTOCOL, TT.PT, TT.PATIENT,
                         TT.KEY1, TT.KEY2, TT.KEY3, TT.KEY4, TT.KEY5);
    LOOP
      FETCH C_CT_DATA_EXIST INTO T_REC;
      EXIT WHEN C_CT_DATA_EXIST%NOTFOUND;
        IF T_REC.DEL_FLAG = 'D' THEN
          T_FLAG := 'Y';
          EXIT;
        ELSE
          IF '  '||SUBSTR(TT.LINE_TEXT, 24, 32)||SUBSTR(TT.LINE_TEXT, 68) =
             '  '||SUBSTR(T_REC.LINE_TEXT, 24, 32)||SUBSTR(T_REC.LINE_TEXT, 68)
          THEN
             T_FLAG := 'N';
             EXIT;
          END IF;
        END IF;
    END LOOP;

    CLOSE C_CT_DATA_EXIST;

    IF T_FLAG = 'N' THEN
      UPDATE CT_EXT_DATA SET SUBMISSION_FLAG = 9
       WHERE ROWID = TT.A_ROWID;
    END IF;

  END LOOP;

exception
  WHEN OTHERS THEN
    IF C_CT_DATA_EXIST%ISOPEN THEN
      CLOSE C_CT_DATA_EXIST;
    END IF;
    RAISE;    -- Failure
End;

PROCEDURE P_CRT_STUDY_VW
 (P_STUDY             IN VARCHAR2
 ,P_UPD_LAB_OTH_TEXT  IN VARCHAR2
 ,P_VERSION           IN VARCHAR2)
 IS
  T_TEXT LONG;
BEGIN
  IF UPPER(P_UPD_LAB_OTH_TEXT) = 'Y' THEN
      P_GEN_LAB_OTH_VW_TEXT(P_STUDY, P_VERSION);
  END IF;

  FOR T_STUDY IN (SELECT * FROM CT_EXT_STUDY_CTL WHERE OC_STUDY = P_STUDY) LOOP

    Begin  -- PRC : 02/09/05: Wrapped exception handler around this call so the whole thing
           -- doesn't fail
       P_PROC_STUDY_TAB(P_STUDY, 'LBALLAB', 'LBALLAB');  -- tables the Lab All View
    exception
       WHEN OTHERS THEN Null;
    End;

    FOR T_VW IN (SELECT * FROM CT_EXT_VW_CTL WHERE OC_STUDY = P_STUDY ORDER BY CRT_SEQ) LOOP

      BEGIN
        BEGIN -- prc 12/23/03 : Added drop view statement to ensure view removed before creation
          EXECUTE IMMEDIATE 'DROP VIEW '||T_STUDY.EXT_OBJECT_OWNER||'.'||T_VW.VIEW_NAME;
          DBMS_OUTPUT.PUT_LINE('----VIEW '||T_VW.VIEW_NAME||' DROPPED');
        EXCEPTION
          WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SUBSTR('FAILED----DROP VIEW '||T_VW.VIEW_NAME||' '||SQLERRM, 1, 250));
        END;

        BEGIN
          IF TRIM(T_VW.TEXT) IS NOT NULL THEN
            T_TEXT := T_VW.TEXT;
            T_TEXT := REPLACE(T_TEXT, 'PP_OC_OWNER.', T_STUDY.OC_OBJECT_OWNER||'.');
            T_TEXT := REPLACE(T_TEXT, 'PP_EXT_OWNER.', T_STUDY.EXT_OBJECT_OWNER||'.');
            T_TEXT := REPLACE(T_TEXT, 'P_STUDY', ''''||P_STUDY||'''');
            T_TEXT := 'CREATE OR REPLACE VIEW '||T_STUDY.EXT_OBJECT_OWNER||'.'||T_VW.VIEW_NAME||' AS '||T_TEXT;
            EXECUTE IMMEDIATE T_TEXT;
DBMS_OUTPUT.PUT_LINE('----VIEW '||T_VW.VIEW_NAME||' CREATED');
          END IF;
        EXCEPTION
          WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE(SUBSTR('FAILED----CREATE VIEW '||T_VW.VIEW_NAME||' '||T_TEXT||' '||SQLERRM, 1, 250));
        END;
          BEGIN
            EXECUTE IMMEDIATE 'DROP SYNONYM '||T_STUDY.EXT_OBJECT_OWNER||'.'||T_VW.SYNONYM_NAME;
DBMS_OUTPUT.PUT_LINE('----SYNONYM '||T_VW.SYNONYM_NAME||' DROPPED');
          EXCEPTION
            WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE(SUBSTR('FAILED----DROP SYNONYM '||T_VW.SYNONYM_NAME||' '||SQLERRM, 1, 250));
          END;
          EXECUTE IMMEDIATE 'CREATE SYNONYM '||T_STUDY.EXT_OBJECT_OWNER||'.'||T_VW.SYNONYM_NAME||
                            ' FOR '||T_STUDY.EXT_OBJECT_OWNER||'.'||T_VW.VIEW_NAME;
DBMS_OUTPUT.PUT_LINE('----SYNONYM '||T_VW.SYNONYM_NAME||' CREATED');
      EXCEPTION
          WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE(SUBSTR('FAILED----CREATE VIEW '||T_VW.VIEW_NAME||' '||SQLERRM, 1, 250));
      END;

    END LOOP;

  END LOOP;

exception
  WHEN OTHERS THEN
    RAISE;    -- Failure
End;

PROCEDURE P_PROC_STUDY_TAB
 (P_STUDY             IN VARCHAR2
 ,P_VIEW_NAME         IN VARCHAR2
 ,P_TABLE_NAME        IN VARCHAR2)
 IS
  T_MOD_NAME           VARCHAR2(60)  := 'EXT_MISC_PKG.P_PROC_STUDY_TAB';
  T_STEP_NAME          VARCHAR2(30)  := '1';
  T_PROC_NAME          VARCHAR2(30);
    T_SQL_ERROR_CODE       CT_EXT_ERRORS.SQL_ERROR_CODE%TYPE;
    T_SQL_ERROR_DESC       CT_EXT_ERRORS.SQL_ERROR_DESC%TYPE;
    T_KEY_VALUE            CT_EXT_ERRORS.KEY_VALUE%TYPE;
    T_CT_ERROR_DESC        CT_EXT_ERRORS.CT_ERROR_DESC%TYPE;
  T_SQL_STR VARCHAR2(2000);
  T_STR VARCHAR2(2000);
  T_TEMP NUMBER;
  T_OC_OBJECT_OWNER  VARCHAR2(30);
  T_EXT_OBJECT_OWNER  VARCHAR2(30);
  T_EXT_OBJECT_OWNER_TS  VARCHAR2(30);
  T_STEP    VARCHAR2(30);
BEGIN
T_STEP := '1';
      BEGIN
        SELECT OC_OBJECT_OWNER, EXT_OBJECT_OWNER, EXT_OBJECT_OWNER_TS
          INTO T_OC_OBJECT_OWNER, T_EXT_OBJECT_OWNER, T_EXT_OBJECT_OWNER_TS
          FROM CT_EXT_STUDY_CTL
         WHERE OC_STUDY = P_STUDY
           AND ROWNUM = 1;
        IF T_EXT_OBJECT_OWNER_TS IS NULL THEN
          T_EXT_OBJECT_OWNER_TS := 'USERS';
        END IF;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE;    -- Failure
      END;
T_STEP := '2';
      BEGIN
        SELECT 1 INTO T_TEMP
          FROM ALL_VIEWS
         WHERE OWNER = T_OC_OBJECT_OWNER
           AND VIEW_NAME = P_VIEW_NAME;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          BEGIN
            SELECT 1 INTO T_TEMP
              FROM CT_EXT_STUDY_RPT_CTL
             WHERE REPORT_TO = 'THERADEX'
               AND OC_STUDY = P_STUDY
               AND ROWNUM = 1;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              T_TEMP := 0;
          END;
          IF T_TEMP = 0 THEN
              RETURN;
          ELSE
              RAISE;    -- Failure
          END IF;

      END;

T_STEP := '3';
      T_TEMP := 0;
      BEGIN
            SELECT COUNT(*) INTO T_TEMP
              FROM (
                SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH             -- VIEW
                  FROM ALL_TAB_COLUMNS A
                 WHERE A.TABLE_NAME = P_VIEW_NAME
                   AND A.OWNER = T_OC_OBJECT_OWNER
                   AND EXISTS (SELECT 1
                                 FROM ALL_VIEWS B
                                WHERE OWNER = T_OC_OBJECT_OWNER
                                  AND VIEW_NAME = P_VIEW_NAME)
                MINUS (
                SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH              -- TABLE
                  FROM ALL_TAB_COLUMNS A
                 WHERE A.TABLE_NAME = P_TABLE_NAME
                   AND A.OWNER = T_EXT_OBJECT_OWNER
                   AND EXISTS (SELECT 1
                                 FROM ALL_TABLES B
                                WHERE OWNER = T_EXT_OBJECT_OWNER
                                  AND TABLE_NAME = P_TABLE_NAME)
                      ) );
T_STEP := '4';
        IF (T_TEMP = 0) THEN
            SELECT COUNT(*) INTO T_TEMP
              FROM (
                SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH              -- TABLE
                  FROM ALL_TAB_COLUMNS A
                 WHERE A.TABLE_NAME = P_TABLE_NAME
                   AND A.OWNER = T_EXT_OBJECT_OWNER
                   AND EXISTS (SELECT 1
                                 FROM ALL_TABLES B
                                WHERE OWNER = T_EXT_OBJECT_OWNER
                                  AND TABLE_NAME = P_TABLE_NAME)
                MINUS (
                SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH             -- VIEW
                  FROM ALL_TAB_COLUMNS A
                 WHERE A.TABLE_NAME = P_VIEW_NAME
                   AND A.OWNER = T_OC_OBJECT_OWNER
                   AND EXISTS (SELECT 1
                                 FROM ALL_VIEWS B
                                WHERE OWNER = T_OC_OBJECT_OWNER
                                  AND VIEW_NAME = P_VIEW_NAME)
                      ) );

        END IF;
T_STEP := '5';
        IF T_TEMP <> 0 THEN

          BEGIN
            T_STEP := '5.01'; --PRC 4/8/09 : Added to help identify exact failure Step
            SELECT 1 INTO T_TEMP
              FROM ALL_TABLES
             WHERE OWNER = T_EXT_OBJECT_OWNER
               AND TABLE_NAME = P_TABLE_NAME;

              T_STEP := '5.02'; --PRC 4/8/09 : Added to help identify exact failure Step
              T_SQL_STR := 'TRUNCATE TABLE '||T_EXT_OBJECT_OWNER||'.'||P_TABLE_NAME;
              EXECUTE IMMEDIATE T_SQL_STR;

              T_STEP := '5.03'; --PRC 4/8/09 : Added to help identify exact failure Step
              T_SQL_STR := 'DROP TABLE '||T_EXT_OBJECT_OWNER||'.'||P_TABLE_NAME;
              EXECUTE IMMEDIATE T_SQL_STR;

          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
          END;

          T_STEP := '5.04'; --PRC 4/8/09 : Added to help identify exact failure Step
          T_SQL_STR := 'CREATE TABLE '||T_EXT_OBJECT_OWNER||'.'||P_TABLE_NAME||
                       ' TABLESPACE '||T_EXT_OBJECT_OWNER_TS||
                       ' AS SELECT * FROM '||T_OC_OBJECT_OWNER||'.'||P_VIEW_NAME;
          EXECUTE IMMEDIATE T_SQL_STR;

          T_STEP := '5.05'; --PRC 4/8/09 : Added to help identify exact failure Step
          T_SQL_STR := 'ANALYZE TABLE '||T_EXT_OBJECT_OWNER||'.'||P_TABLE_NAME||
                       ' ESTIMATE STATISTICS';
          EXECUTE IMMEDIATE T_SQL_STR;

        ELSE
        T_STEP := '5.10'; --PRC 4/8/09 : Added to help identify exact failure Step

          T_STR := NULL;
          FOR T_COL IN (
                SELECT COLUMN_NAME
                  FROM ALL_TAB_COLUMNS A
                 WHERE A.TABLE_NAME = P_VIEW_NAME
                   AND A.OWNER = T_OC_OBJECT_OWNER
                   AND EXISTS (SELECT 1
                                 FROM ALL_VIEWS B
                                WHERE OWNER = T_OC_OBJECT_OWNER
                                  AND VIEW_NAME = P_VIEW_NAME )  ) LOOP

              T_STEP := '5.11'; --PRC 4/8/09 : Added to help identify exact failure Step

              IF T_STR IS NULL THEN
                T_STR := T_COL.COLUMN_NAME;
              ELSE
                T_STR := T_STR||', '||T_COL.COLUMN_NAME;
              END IF;

          END LOOP;
          T_STEP := '5.12'; --PRC 4/8/09 : Added to help identify exact failure Step

          T_SQL_STR := 'TRUNCATE TABLE '||T_EXT_OBJECT_OWNER||'.'||P_TABLE_NAME;
          EXECUTE IMMEDIATE T_SQL_STR;

          T_STEP := '5.13'; --PRC 4/8/09 : Added to help identify exact failure Step
          T_SQL_STR := 'INSERT INTO '||T_EXT_OBJECT_OWNER||'.'||P_TABLE_NAME||'('||T_STR||') '||
                       ' SELECT '||T_STR||' FROM '||T_OC_OBJECT_OWNER||'.'||P_VIEW_NAME;
          EXECUTE IMMEDIATE T_SQL_STR;

          T_STEP := '5.14'; --PRC 4/8/09 : Added to help identify exact failure Step
          COMMIT;

          T_STEP := '5.15'; --PRC 4/8/09 : Added to help identify exact failure Step
          T_SQL_STR := 'ANALYZE TABLE '||T_EXT_OBJECT_OWNER||'.'||P_TABLE_NAME||
                       ' ESTIMATE STATISTICS';
          EXECUTE IMMEDIATE T_SQL_STR;

        END IF;

      EXCEPTION
        WHEN OTHERS THEN
          RAISE;    -- Failure
      END;

exception
  WHEN OTHERS THEN
        T_SQL_ERROR_CODE    := SQLCODE;
        T_SQL_ERROR_DESC    := SQLERRM;
        T_KEY_VALUE         := NULL;
        T_CT_ERROR_DESC := 'Insert CT_DATA failed @'||T_MOD_NAME||'--'||T_STEP; -- prc 09/30/04
        -- Error handling procedure
        EXT_UTIL_PKG.P_CT_EXT_ERRORS
                    (P_STUDY, 'ALL', T_MOD_NAME, T_STEP_NAME
                    ,T_KEY_VALUE, T_SQL_ERROR_CODE, T_SQL_ERROR_DESC
                    ,T_CT_ERROR_DESC, 'CONT');
      RAISE;    -- Failure

End;

PROCEDURE P_CRT_STUDY_OC_SYN
 (P_STUDY             IN VARCHAR2)
 IS

   X_Fnd  Number := 0; -- PRC 03/15/04 : Added check for missing OC OBJ CTL records
BEGIN

 -- The following section was added to first check for, then add (if missing)
 -- OC OBJ CTL records that are used to create Study-Extraction Specific OC
 -- Synonyms.
 -- PRC 03/15/2004 BEGIN NEW SECTION
 select count(*)
   into X_Fnd
   from ct_ext_oc_obj_ctl
  where oc_study = P_STUDY;

  If X_Fnd = 0 then
     insert into ct_ext_oc_obj_ctl(OC_STUDY,SYNONYM_NAME,OBJECT_NAME,OBJECT_OWNER,CRT_SEQ )
     select P_STUDY, synonym_name, object_name, object_owner, crt_seq
       from ct_ext_oc_obj_ctl
      where oc_study= 'THER_STD';

     Commit;
  End If;
 -- PRC 03/15/2004 END NEW SECTION

  FOR T_STUDY IN (SELECT * FROM CT_EXT_STUDY_CTL WHERE OC_STUDY = P_STUDY) LOOP
    FOR T_SYN IN (SELECT * FROM CT_EXT_OC_OBJ_CTL WHERE OC_STUDY = P_STUDY ORDER BY CRT_SEQ) LOOP
      BEGIN
          BEGIN
            EXECUTE IMMEDIATE 'DROP SYNONYM '||T_STUDY.EXT_OBJECT_OWNER||'.'||T_SYN.SYNONYM_NAME;
DBMS_OUTPUT.PUT_LINE('----SYNONYM '||T_SYN.SYNONYM_NAME||' DROPPED');
          EXCEPTION
            WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE(SUBSTR('FAILED----DROP SYNONYM '||T_SYN.SYNONYM_NAME||' '||SQLERRM, 1, 250));
          END;

          EXECUTE IMMEDIATE 'CREATE SYNONYM '||T_STUDY.EXT_OBJECT_OWNER||'.'||T_SYN.SYNONYM_NAME||
                            ' FOR '||T_SYN.OBJECT_OWNER||'.'||T_SYN.OBJECT_NAME;
DBMS_OUTPUT.PUT_LINE('----SYNONYM '||T_SYN.SYNONYM_NAME||' CREATED');

      exception
        WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE(SUBSTR('FAILED----CREATE SYNONYM '||T_SYN.SYNONYM_NAME||' '||SQLERRM, 1, 250));
      End;

    END LOOP;
  END LOOP;

exception
  WHEN OTHERS THEN
    RAISE;    -- Failure
End;

PROCEDURE P_GEN_LAB_OTH_VW_TEXT
 (P_STUDY     IN VARCHAR2
 ,P_VERSION   IN VARCHAR2)
 IS
  T_TEXT           LONG;
  T_TEXT2           LONG := Null;
  T_VIEW_NAME      VARCHAR2(30) := NULL;
  T_SYNONYM_NAME   VARCHAR2(30) := NULL;
  T_COUNT          NUMBER := 0;

  v_pp_oc_owner    ct_ext_study_ctl.oc_object_owner%type;
  V_CourseNumb     varchar2(1) := 'N';
  crlf             varchar2(4) := Chr(10);

BEGIN

  --Log_Util.SetLogName('EXTRACT_P_GEN_LAB_OTH_VW_TEXT','EXT_RFRSH');
  --Log_Util.LogMessage('Starting "P_GEN_LAB_OTH_VW_TEXT" with P_STUDY="'||P_STUDY||'".');
  DBMS_OUTPUT.PUT_LINE('Starting "P_GEN_LAB_OTH_VW_TEXT" with P_STUDY="'||P_STUDY||'".');

  /* BEGIN COURSE NUMBER INCLUSION */
  select oc_object_owner into v_pp_oc_owner
    from ct_ext_study_ctl
   where oc_study = P_Study;

  Begin
     Select 'Y' into v_CourseNumb
       from all_tab_columns
      where owner = v_pp_oc_owner
        and table_name = 'LBAL'
        and column_name = 'COURS_NUM';

  Exception
     When Others Then
        v_CourseNumb := 'N';
  End;
  /* END COURSE NUMBER INCLUSION */

  FOR T_FILE IN (SELECT DISTINCT FILE_ID
                   FROM NCI_LABTEST_MAPPING
                  WHERE TRIM(FILE_ID) IS NOT NULL) LOOP

    T_VIEW_NAME := 'CTS_LAB_OTH_'||T_FILE.FILE_ID||'_VW';
    T_SYNONYM_NAME := 'CTSC_LAB_OTH_'||T_FILE.FILE_ID;

    /* BEGIN COURSE NUMBER INCLUSION */
    If v_CourseNumb = 'Y' Then
       T_TEXT := 'select A.*, C.COURS_NUM,  NVL(B.PATIENT_FUL, A.PT) PATIENT_FUL, B.REG_INST_FUL ';

    Else
       T_TEXT := 'select A.*, NVL(B.PATIENT_FUL, A.PT) PATIENT_FUL, B.REG_INST_FUL ';
    End If;
    /* END COURSE NUMBER INCLUSION */

    If P_Version = 'T310' Then
       T_TEXT := T_Text || crlf ||
              '  from ('|| crlf ||
              '  SELECT * FROM ('|| crlf ||
              '           select'|| crlf ||
              '                  STUDY'    || crlf ||
              '                 ,DCMNAME'  || crlf ||
              '                 ,DCMSUBNM' || crlf ||
              '                 ,SUBSETSN' || crlf ||
              '                 ,DOCNUM'   || crlf ||
              '                 ,INVSITE'    || crlf ||
              '                 ,INV'        || crlf ||
              '                 ,PT'         || crlf ||
              '                 ,ACCESSTS'   || crlf ||
              '                 ,LOGINTS'    || crlf ||
              '                 ,LSTCHGTS'   || crlf ||
              '                 ,LOCKFLAG'   || crlf ||
              '                 ,CPEVENT'    || crlf ||
              '                 ,DCMDATE   SMPL_DT'|| crlf ||
              '                 ,DCMTIME   SMPL_TM'|| crlf ||
              '                 ,ACTEVENT' || crlf ||
              '                 ,SUBEVENT_NUMBER'    || crlf ||
              '                 ,VISIT_NUMBER'       || crlf ||
              '                 ,QUALIFYING_VALUE'   || crlf ||
              '                 ,QUALIFYING_QUESTION'|| crlf ||
              '                 ,LAB'                || crlf ||
              '                 ,LABRANGE_SUBSET_NUMBER'  || crlf ||
              '                 ,LAB_ASSIGNMENT_TYPE_CODE'|| crlf ||
              '                 ,LAB_ID';
    End If;
    If P_Version = 'T312' Then
       T_TEXT := T_Text || crlf ||
              '  from ('|| crlf ||
              '  SELECT * FROM ('|| crlf ||
              '           select'|| crlf ||
              '                  STUDY'    || crlf ||
              '                 ,DCMNAME'  || crlf ||
              '                 ,DCMSUBNM' || crlf ||
              '                 ,SUBSETSN' || crlf ||
              '                 ,DOCNUM'   || crlf ||
              '                 ,RECEIVED_DCI_ID' || crlf ||  -- prc 06/07/06: Requested
              '                 ,RECEIVED_DCM_ID' || crlf ||  -- prc 06/07/06: Requested
              '                 ,INVSITE'    || crlf ||
              '                 ,INV'        || crlf ||
              '                 ,PT'         || crlf ||
              '                 ,ACCESSTS'   || crlf ||
              '                 ,LOGINTS'    || crlf ||
              '                 ,LSTCHGTS'   || crlf ||
              '                 ,LOCKFLAG'   || crlf ||
              '                 ,ENTERED_BY' || crlf ||                -- prc 06/07/06: Requested
              '                 ,CPEVENT'    || crlf ||
              '                 ,DCMDATE   SMPL_DT'|| crlf ||
              '                 ,DCMTIME   SMPL_TM'|| crlf ||
              '                 ,ACTEVENT' || crlf ||
              '                 ,SUBEVENT_NUMBER'    || crlf ||
              '                 ,VISIT_NUMBER'       || crlf ||
              '                 ,QUALIFYING_VALUE'   || crlf ||
              '                 ,QUALIFYING_QUESTION'|| crlf ||
              '                 ,DCI_ID'             || crlf ||  -- prc 06/07/06: Requested
              '                 ,DCM_ID'             || crlf ||  -- prc 06/07/06: Requested
              '                 ,LAB'                || crlf ||
              '                 ,LABRANGE_SUBSET_NUMBER'  || crlf ||
              '                 ,LAB_ASSIGNMENT_TYPE_CODE'|| crlf ||
              '                 ,LAB_ID';
   End If;
/* Only LX and EX will have PANEL, so only add for those FILES -- CGA 12/5/03 */
IF (T_FILE.FILE_ID = 'LX' or T_FILE.FILE_ID = 'EX') THEN
   T_TEXT := T_TEXT|| crlf ||
              '                 ,PANEL';

    /*FOR T_FIELD IN (SELECT DISTINCT FILE_ID, FILE_ID||'_'||FIELD_NAME,
                           F_LPARM_STR_VW_FUL(FILE_ID,FIELD_NAME) FIELD_STR
                      FROM (SELECT DISTINCT FILE_ID, FIELD_NAME
                              FROM NCI_LABTEST_MAPPING
                             WHERE FILE_ID = T_FILE.FILE_ID
                               AND TRIM(FILE_ID) IS NOT NULL
                               AND TRIM(FIELD_NAME) IS NOT NULL ))     LOOP */
   T_TEXT2 := Null;

   For T_Field In (select oc_study, substr(field_name,7), panel,
                       decode(oc_lab_question,null,',null ',
                              ',max(DECODE(PANEL,'||panel||', DECODE(LPARM_FUL,'''||oc_lab_question||''',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL)) ')||replace(field_name,' ','_')||'_FUL' FIELD_STR
                  from nci_labtest_mapping
                 where file_id=T_FILE.FILE_ID
                   and (oc_study=P_STUDY or oc_study = 'ALL')
                union
                select oc_study, substr(field_name,7), panel,
                       decode(oc_lab_question,null,',null ',',max(DECODE(PANEL,'||panel||', DECODE(LPARM_FUL,'''||oc_lab_question||''',LAB_RANGE_IND,NULL),NULL)) ')||replace(field_name,' ','_')||'_RANG_IND' FIELD_STR
                  from nci_labtest_mapping
                 where file_id=T_FILE.FILE_ID
                   and (oc_study=P_STUDY or oc_study = 'ALL')
                union
                select oc_study, substr(field_name,7), panel,
                       decode(oc_lab_question,null,',null ',',max(DECODE(PANEL,'||panel||', DECODE(LPARM_FUL,'''||oc_lab_question||''',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL)) ')||replace(field_name,' ','_')||'_GRADE_FUL' FIELD_STR
                  from nci_labtest_mapping
                 where file_id=T_FILE.FILE_ID
                   and (oc_study=P_STUDY or oc_study = 'ALL')) Loop

     if T_FIELD.FIELD_STR is not null then
        T_TEXT2 := T_TEXT2||crlf||T_FIELD.FIELD_STR;
     End If;

   END LOOP;
ELSE
   T_TEXT2 := Null;

   For T_Field In (select oc_study, substr(field_name,7), panel,
                       decode(oc_lab_question,null,',null ',
                              ',max(DECODE(LPARM_FUL,'''||oc_lab_question||''',SUBSTR(LVALUE_FUL, 1, 20),NULL)) ')||replace(field_name,' ','_')||'_FUL' FIELD_STR
                  from nci_labtest_mapping
                 where file_id=T_FILE.FILE_ID
                   and (oc_study=P_STUDY or oc_study = 'ALL')
         and not (file_id = 'BC' and P_STUDY = '03_C_0176' and oc_lab_question='CPK')
                union
                select oc_study, substr(field_name,7), panel,
                       decode(oc_lab_question,null,',null ',',max(DECODE(LPARM_FUL,'''||oc_lab_question||''',LAB_RANGE_IND,NULL)) ')||replace(field_name,' ','_')||'_RANG_IND' FIELD_STR
                  from nci_labtest_mapping
                 where file_id=T_FILE.FILE_ID
                   and (oc_study=P_STUDY or oc_study = 'ALL')
         and not (file_id = 'BC' and P_STUDY = '03_C_0176' and oc_lab_question='CPK')
                union
                select oc_study, substr(field_name,7), panel,
                       decode(oc_lab_question,null,',null ',',max(DECODE(LPARM_FUL,'''||oc_lab_question||''',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL)) ')||replace(field_name,' ','_')||'_GRADE_FUL' FIELD_STR
                  from nci_labtest_mapping
                 where file_id=T_FILE.FILE_ID
                   and (oc_study=P_STUDY or oc_study = 'ALL')
         and not (file_id = 'BC' and P_STUDY = '03_C_0176' and oc_lab_question='CPK')) Loop

     if T_FIELD.FIELD_STR is not null then
        T_TEXT2 := T_TEXT2||crlf||T_FIELD.FIELD_STR;
     End If;

   END LOOP;
END IF;


If T_TEXT2 is null Then
   FOR T_FIELD1 IN (SELECT DISTINCT ',NULL '||A.FIELD_NAME||'_FUL' NOT_NULL_STR
                          FROM NCI_LABTEST_MAPPING A
                         WHERE FILE_ID = T_FILE.FILE_ID
                           AND TRIM(A.FILE_ID) IS NOT NULL
                        AND TRIM(A.FIELD_NAME) IS NOT NULL)     LOOP


      T_Text2 := T_TEXT2 || crlf ||T_FIELD1.NOT_NULL_STR;

   End Loop;

End If;

 T_TEXT := T_TEXT || T_TEXT2;

 If P_VERSION = 'T310' Then
    T_TEXT := T_TEXT|| crlf ||
              '      FROM ('|| crlf ||
              '        SELECT A.*, NVL(B.PANEL, 0) PANEL'|| crlf ||
              '          FROM PP_OC_OWNER.LBALLAB A,'|| crlf ||
              '            (SELECT DISTINCT OC_LAB_QUESTION, PANEL'|| crlf ||
              '               FROM NCI_LABTEST_MAPPING'|| crlf ||
              '              WHERE FILE_ID IS NOT NULL'|| crlf ||
              '                AND FIELD_NAME IS NOT NULL'|| crlf ||
              '                AND OC_LAB_QUESTION IS NOT NULL'|| crlf ||
              '                AND (OC_STUDY = ''ALL'' OR OC_STUDY = '''||P_STUDY||''' ) ) B'|| crlf ||
              '         WHERE A.LPARM = B.OC_LAB_QUESTION'|| crlf ||
              '           )'|| crlf ||
              '     GROUP BY'|| crlf ||
              '          STUDY'|| crlf ||
              '         ,DCMNAME'|| crlf ||
              '         ,DCMSUBNM'|| crlf ||
              '         ,SUBSETSN'|| crlf ||
              '         ,DOCNUM'|| crlf ||
              '         ,INVSITE'|| crlf ||
              '         ,INV'|| crlf ||
              '         ,PT'|| crlf ||
              '         ,ACCESSTS'|| crlf ||
              '         ,LOGINTS'|| crlf ||
              '         ,LSTCHGTS'|| crlf ||
              '         ,LOCKFLAG'|| crlf ||
              '         ,CPEVENT'|| crlf ||
              '         ,DCMDATE'|| crlf ||
              '         ,DCMTIME'|| crlf ||
              '         ,ACTEVENT'|| crlf ||
              '         ,SUBEVENT_NUMBER'|| crlf ||
              '         ,VISIT_NUMBER'|| crlf ||
              '         ,QUALIFYING_VALUE'|| crlf ||
              '         ,QUALIFYING_QUESTION'|| crlf ||
              '         ,LAB'|| crlf ||
              '         ,LABRANGE_SUBSET_NUMBER'|| crlf ||
              '         ,LAB_ASSIGNMENT_TYPE_CODE'|| crlf ||
              '         ,LAB_ID';
End If;
 If P_VERSION = 'T312' Then
    T_TEXT := T_TEXT|| crlf ||
              '      FROM ('|| crlf ||
              '        SELECT A.*, NVL(B.PANEL, 0) PANEL'|| crlf ||
              '          FROM PP_OC_OWNER.LBALLAB A,'|| crlf ||
              '            (SELECT DISTINCT OC_LAB_QUESTION, PANEL'|| crlf ||
              '               FROM NCI_LABTEST_MAPPING'|| crlf ||
              '              WHERE FILE_ID IS NOT NULL'|| crlf ||
              '                AND FIELD_NAME IS NOT NULL'|| crlf ||
              '                AND OC_LAB_QUESTION IS NOT NULL'|| crlf ||
              '                AND (OC_STUDY = ''ALL'' OR OC_STUDY = '''||P_STUDY||''' ) ) B'|| crlf ||
              '         WHERE A.LPARM = B.OC_LAB_QUESTION'|| crlf ||
              '           )'|| crlf ||
              '     GROUP BY'|| crlf ||
              '          STUDY'|| crlf ||
              '         ,DCMNAME'|| crlf ||
              '         ,DCMSUBNM'|| crlf ||
              '         ,SUBSETSN'|| crlf ||
              '         ,DOCNUM'|| crlf ||
              '         ,RECEIVED_DCI_ID'|| crlf ||
              '         ,RECIEVED_DCM_ID'|| crlf ||
              '         ,INVSITE'|| crlf ||
              '         ,INV'|| crlf ||
              '         ,PT'|| crlf ||
              '         ,ACCESSTS'|| crlf ||
              '         ,LOGINTS'|| crlf ||
              '         ,LSTCHGTS'|| crlf ||
              '         ,LOCKFLAG'|| crlf ||
              '         ,ENTERED_BY'|| crlf ||
              '         ,CPEVENT'|| crlf ||
              '         ,DCMDATE'|| crlf ||
              '         ,DCMTIME'|| crlf ||
              '         ,ACTEVENT'|| crlf ||
              '         ,SUBEVENT_NUMBER'|| crlf ||
              '         ,VISIT_NUMBER'|| crlf ||
              '         ,QUALIFYING_VALUE'|| crlf ||
              '         ,QUALIFYING_QUESTION'|| crlf ||
              '         ,DCI_ID'|| crlf ||
              '         ,DCM_ID'|| crlf ||
              '         ,LAB'|| crlf ||
              '         ,LABRANGE_SUBSET_NUMBER'|| crlf ||
              '         ,LAB_ASSIGNMENT_TYPE_CODE'|| crlf ||
              '         ,LAB_ID';

End If;
/* Only LX and EX will have PANEL, so only add for those FILES -- CGA 12/5/03 */
IF T_FILE.FILE_ID = 'LX' or T_FILE.FILE_ID = 'EX' THEN
   T_TEXT := T_TEXT|| crlf ||
             '   ,PANEL )';
ELSE
   T_TEXT := T_TEXT||' )';
END IF;

    T_TEXT := T_TEXT|| crlf ||
              '        WHERE ';

    T_COUNT := 0;

/* CGA kludge to suppress 03_C_0176 LAB_OTH_BC by excluding CPK - Creat_Phos
              AND NOT (A.FILE_ID = 'BC' and P_STUDY = '03_C_0176' and a.oc_lab_question='CPK')
*/

    FOR T_FIELD1 IN (SELECT DISTINCT A.FIELD_NAME||'_FUL IS NOT NULL' NOT_NULL_STR
                       FROM NCI_LABTEST_MAPPING A
                      WHERE FILE_ID = T_FILE.FILE_ID
                        AND TRIM(A.FILE_ID) IS NOT NULL
                        AND TRIM(A.FIELD_NAME) IS NOT NULL
              AND NOT (A.FILE_ID = 'BC' and P_STUDY = '03_C_0176' and a.oc_lab_question='CPK') )     LOOP

      T_COUNT := T_COUNT + 1;

      IF T_COUNT = 1 THEN
        T_TEXT := T_TEXT|| crlf ||T_FIELD1.NOT_NULL_STR;
      ELSE
        T_TEXT := T_TEXT|| crlf ||
                  '       OR '||T_FIELD1.NOT_NULL_STR;
      END IF;

    END LOOP;

  /* BEGIN COURSE NUMBER INCLUSION */
  If v_CourseNumb = 'Y' Then
    T_TEXT := T_TEXT||' ) A,'|| crlf ||
                '   PP_EXT_OWNER.CTS_PTID_ENRL_VW B, '|| crlf ||
                '   PP_OC_OWNER.LBAL C '|| crlf ||
                'WHERE A.STUDY = B.STUDY (+)'|| crlf ||
                '  AND A.PT = B.PT (+)'|| crlf ||
                '  AND A.DOCNUM = C.DOCNUM';
  Else
    T_TEXT := T_TEXT||' ) A,'|| crlf ||
              '   PP_EXT_OWNER.CTS_PTID_ENRL_VW B'|| crlf ||
              'WHERE A.STUDY = B.STUDY (+)'|| crlf ||
              '  AND A.PT = B.PT (+)';
  End If;
  /* END COURSE NUMBER INCLUSION */


    BEGIN

      Log_Util.LogMessage('Getting CRT_SEQ from CT_EXT_VW_CTL');

      SELECT CRT_SEQ INTO T_COUNT
        FROM CT_EXT_VW_CTL
       WHERE OC_STUDY = P_STUDY
         AND VIEW_NAME = T_VIEW_NAME
         AND ROWNUM = 1;

      Log_Util.LogMessage('Updating CT_EXT_VW_CTL');

      UPDATE CT_EXT_VW_CTL SET TEXT = T_TEXT
       WHERE OC_STUDY = P_STUDY
         AND VIEW_NAME = T_VIEW_NAME;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        BEGIN
          SELECT MAX(CRT_SEQ) INTO T_COUNT
            FROM CT_EXT_VW_CTL
           WHERE OC_STUDY = P_STUDY;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
             T_COUNT := 0;
        END;

        Log_Util.LogMessage('Inserting Into CT_EXT_VW_CTL');

        INSERT INTO CT_EXT_VW_CTL(OC_STUDY, VIEW_NAME, CRT_SEQ, TEXT, SYNONYM_NAME)
            VALUES (P_STUDY, T_VIEW_NAME, NVL(T_COUNT, 0) + 10, T_TEXT, REPLACE(T_VIEW_NAME, '_VW', NULL));

    END;

  END LOOP;

  COMMIT;

exception
  WHEN OTHERS THEN
    Log_Util.LogMessage('P_GEN_LAB_OTH_VW_TEXT Failed with - '||Substr(SQLERRM, 1, 250));
    RAISE;    -- Failure
End;

BEGIN
  NULL;
END;
/
SHOW ERROR
