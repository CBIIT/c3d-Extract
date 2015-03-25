CREATE OR REPLACE PACKAGE SL_BLANK_PROC

 IS

-- Sub-Program Unit Declarations

PROCEDURE P_PROC_BLANK
 (P_STUDY        IN VARCHAR2
 ,P_DEBUG_MODE   IN VARCHAR2 := 'CONT'
 );

END SL_BLANK_PROC;
/

CREATE OR REPLACE PACKAGE BODY SL_BLANK_PROC

    IS

-- Program Data
-- PL/SQL Block
-- Sub-Program Units

PROCEDURE P_PROC_BLANK
 (P_STUDY        IN VARCHAR2
 ,P_DEBUG_MODE   IN VARCHAR2 := 'CONT'
 )
 IS

  T_MOD_NAME           VARCHAR2(60)  := 'SL_BLANK_PROC.P_PROC_BLANK';
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

  T_TEMP_ROWID             ROWID;
  T_TEMP_LINE_TEXT         VARCHAR2(2600);
  T_POS_TEMP     NUMBER := 0;
  T_LENGTH       NUMBER := 0;
  T_POS          NUMBER := 0;
  T_TEMP_2       VARCHAR2(2000);
  T_REMOVE_2     VARCHAR2(1);
  T_UPDATE_FLAG  VARCHAR2(1);
  T_UPDATE_COUNT NUMBER := 0;
  T_FIELD_START   NUMBER;
  T_FIELD_LENGTH  NUMBER;
  T_FIELD_POS_STR VARCHAR2(60);
  T_FIELD_VALUE   VARCHAR2(2000);
  T_FIELD_COUNT   NUMBER;
  T_TEMP          VARCHAR2(30);
BEGIN
-----------------------
T_STEP_NAME := '1';
    DBMS_OUTPUT.PUT_LINE(T_STEP_NAME||' '||T_EXT_STATUS);
-----------------------
T_STEP_NAME := '2';          ----normal records
    T_EXT_STATUS := 'PROCESSING';
    T_PROC_NAME  := 'PROC BLANK';
-------
  BEGIN              -- populate the temporary tables for one study
    DELETE FROM SL_TEMP_FILE nologging;
    DELETE FROM SL_TEMP_LAST_REC nologging;
    DELETE FROM SL_TEMP_ALL_REC nologging;

    INSERT INTO SL_TEMP_FILE
      SELECT PROTOCOL, FILE_ID, VERSION               
                   FROM CT_DATA 
                  WHERE PROTOCOL = P_STUDY
                  GROUP BY PROTOCOL, FILE_ID, VERSION;

    INSERT INTO SL_TEMP_LAST_REC 
             SELECT A.ROWID A_ROWID, A.* 
               FROM CT_DATA A
              WHERE A.SUBMISSION_FLAG = 1
                AND A.PROTOCOL = P_STUDY
                AND A.EXTRACTED =
                      (SELECT MAX(B.EXTRACTED)
                         FROM CT_DATA B
                        WHERE '*'||B.KEY1  = '*'||A.KEY1
                          AND '*'||B.KEY2  = '*'||A.KEY2
                          AND '*'||B.KEY3  = '*'||A.KEY3
                          AND '*'||B.KEY4  = '*'||A.KEY4
                          AND '*'||B.KEY5  = '*'||A.KEY5
                          AND trim(B.FILE_ID)    = trim(A.FILE_ID)
                          AND trim(B.PROTOCOL)   = P_STUDY
                          AND trim(B.PT)         = trim(A.PT)
                          AND trim(B.PATIENT)    = trim(A.PATIENT)
                          AND B.SUBMISSION_FLAG = 1);

    INSERT INTO SL_TEMP_ALL_REC 
                       SELECT *
                         FROM CT_DATA B
                        WHERE trim(B.PROTOCOL)   = P_STUDY
                          AND B.SUBMISSION_FLAG = 1;

    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN 
      ROLLBACK;
      RAISE;
  END;
--------
  FOR T_FILE IN (SELECT * FROM SL_TEMP_FILE ) LOOP 

        FOR T_LAST_REC IN (                                           -- for each last record
             SELECT * FROM SL_TEMP_LAST_REC 
              WHERE PROTOCOL = T_FILE.PROTOCOL
                AND FILE_ID = T_FILE.FILE_ID
               ORDER BY FILE_ID                ) LOOP
           IF T_LAST_REC.DEL_FLAG <> 'D' THEN                             -- if the last rec is not a DELETE

             T_UPDATE_COUNT := 0;
             T_TEMP_LINE_TEXT := T_LAST_REC.LINE_TEXT;
             T_TEMP_ROWID := T_LAST_REC.A_ROWID;

             FOR T_FIELD IN (SELECT FIELD_NAME, START_POS, FIELD_LENGTH                -- for each position
                               FROM CT_DATA_VW_CTL
                              WHERE REPORT_TO  = 'THERADEX'
                                AND FILE_ID    = T_FILE.FILE_ID
                                AND VERSION    = T_FILE.VERSION
                                AND FIELD_TYPE = 'A'
                                AND START_POS > 90
                              ORDER BY START_POS ) LOOP

                IF TRIM(SUBSTR(T_LAST_REC.LINE_TEXT, T_FIELD.START_POS, T_FIELD.FIELD_LENGTH)) IS NULL THEN

                   T_FIELD_VALUE := NULL;
                   T_UPDATE_FLAG := 'N';
                   FOR T_ALL_REC IN (                                        -- check all the old records
                       SELECT *
                         FROM SL_TEMP_ALL_REC B
                        WHERE '*'||B.KEY1  = '*'||T_LAST_REC.KEY1
                          AND '*'||B.KEY2  = '*'||T_LAST_REC.KEY2
                          AND '*'||B.KEY3  = '*'||T_LAST_REC.KEY3
                          AND '*'||B.KEY4  = '*'||T_LAST_REC.KEY4
                          AND '*'||B.KEY5  = '*'||T_LAST_REC.KEY5
                          AND trim(B.FILE_ID)    = trim(T_LAST_REC.FILE_ID)
                          AND trim(B.PROTOCOL)   = trim(T_LAST_REC.PROTOCOL)
                          AND trim(B.PT)         = trim(T_LAST_REC.PT)
                          AND trim(B.PATIENT)    = trim(T_LAST_REC.PATIENT)
                          AND B.SUBMISSION_FLAG = 1
                       ORDER BY EXTRACTED DESC, substr(b.line_text, 32, 14) DESC ) LOOP 

                       IF T_ALL_REC.DEL_FLAG = 'D' THEN                             -- all the previous records
                                                                                    -- were deleted. Stop here
                         T_UPDATE_FLAG := 'Y';
                         T_FIELD_VALUE := '*';
                       ELSE
                         IF TRIM(SUBSTR(T_ALL_REC.LINE_TEXT, T_FIELD.START_POS, T_FIELD.FIELD_LENGTH)) IS NOT NULL THEN
                           T_UPDATE_FLAG := 'Y';
                           T_FIELD_VALUE := SUBSTR(T_ALL_REC.LINE_TEXT, T_FIELD.START_POS, T_FIELD.FIELD_LENGTH);
                                                                                   -----------
                                                                                   -- found the last NOT NULL field
                         END IF;
                       END IF;

                     EXIT WHEN T_UPDATE_FLAG = 'Y';

                   END LOOP;

                   IF T_UPDATE_FLAG = 'N' THEN
                      T_UPDATE_FLAG := 'Y';
                      T_FIELD_VALUE := '*';
                   END IF;

                   IF T_UPDATE_FLAG = 'Y' THEN                                        -- update one field
                     T_TEMP_LINE_TEXT := SUBSTR(T_TEMP_LINE_TEXT, 1, T_FIELD.START_POS - 1)||
                                         RPAD(T_FIELD_VALUE, T_FIELD.FIELD_LENGTH, ' ')||
                                         SUBSTR(T_TEMP_LINE_TEXT, T_FIELD.START_POS + T_FIELD.FIELD_LENGTH);
                     T_UPDATE_COUNT := T_UPDATE_COUNT + 1;
                   END IF;

               END IF;

             END LOOP;    -- check for each COLUMN

             IF T_UPDATE_COUNT <> 0 THEN   
                  UPDATE CT_DATA                                                  -- update one line_text
                     SET LINE_TEXT = T_TEMP_LINE_TEXT
                   WHERE ROWID = T_TEMP_ROWID;
-- FOR TESTING--
T_STEP_NAME := '900';
--                  INSERT INTO SL_TEMP_ALL_COMP
--                    VALUES (T_LAST_REC.LINE_TEXT, T_TEMP_LINE_TEXT, T_LAST_REC.A_ROWID);
                  COMMIT; 
             END IF;

          END IF;

        END LOOP;

  END LOOP;

  COMMIT;
-----------------------
T_STEP_NAME := '8';
    T_EXT_STATUS := 'SUCCESS';
    DBMS_OUTPUT.PUT_LINE(T_STEP_NAME||' '||T_EXT_STATUS);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        T_EXT_STATUS := 'FAIL';
        T_SQL_ERROR_CODE    := SQLCODE;
        T_SQL_ERROR_DESC    := SQLERRM;
        T_KEY_VALUE         := NULL;
        T_CT_ERROR_DESC := 'Update CT_DATA failed @'||T_MOD_NAME||'--'||T_STEP_NAME||'--'||T_FILE_ID;
        -- Error handling procedure
        DBMS_OUTPUT.PUT_LINE(T_STEP_NAME||' '||T_EXT_STATUS||T_CT_ERROR_DESC);
        DBMS_OUTPUT.PUT_LINE(T_SQL_ERROR_CODE||'-'||T_SQL_ERROR_DESC);
END;

------------
-- PL/SQL Block
BEGIN
  NULL;
END SL_BLANK_PROC;
/

