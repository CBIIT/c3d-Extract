CREATE OR REPLACE PACKAGE CTDEV.CTVW_PKG2 IS
  /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
  /*    Authors: Unknown                                                               */
  /*       Date: Unknown                                                               */
  /*Description: This package contains procedures and functions used for identifying   */
  /*             dates related to data collection.  The Union Views are used as the    */
  /*             primary querying mechanism.                                           */
  /*    Effects: CT_STG_DATA_DATES                                                     */
  /*             CT_ENROLLMENT                                                         */
  /*             CT_DATA_DATES                                                         */
  /*             CT_COURSE_INIT                                                        */
  /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
  /*  Modification History                                                             */
  /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
  /* PRC          : Cleaned; made more readable; placed Log_Util calls                 */
  /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
  /* PRC 06/15/04 : Updated package.  More Cleaning; made even more readable;          */
  /*                place Log_Util calls                                               */
  /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

   -- Sub-Program Unit Declarations

   FUNCTION F_CRS_NUM_DT (P_STUDY    IN VARCHAR2,
                          P_PT       IN VARCHAR2,
                          P_START_DT IN VARCHAR2)  RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (F_CRS_NUM_DT, WNDS, WNPS);

   FUNCTION F_CRS1_DT (P_STUDY IN VARCHAR2,
                       P_PT    IN VARCHAR2)  RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (F_CRS1_DT, WNDS, WNPS);

   FUNCTION F_DAY_SINCE_REG (P_STUDY    IN VARCHAR2,
                             P_PT       IN VARCHAR2,
                             P_START_DT IN VARCHAR2)  RETURN NUMBER;

   PRAGMA RESTRICT_REFERENCES (F_DAY_SINCE_REG, WNDS, WNPS);

   FUNCTION F_DAY_SINCE_CRS1 (P_START_DT IN VARCHAR2,
                              P_CRS1_DT  IN VARCHAR2)  RETURN NUMBER;

   PRAGMA RESTRICT_REFERENCES (F_DAY_SINCE_CRS1, WNDS, WNPS);

   FUNCTION F_FILE_ID (P_STUDY    IN VARCHAR2,
                       P_PATIENT  IN VARCHAR2,
                       P_START_DT IN VARCHAR2)  RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (F_FILE_ID, WNDS);

   PROCEDURE P_CT_DATA_DT;

END;
/


CREATE OR REPLACE PACKAGE BODY CTDEV.CTVW_PKG2 IS

   CURSOR GC_CRS_NUM_DT(P_STUDY IN VARCHAR2, P_PT IN VARCHAR2, P_START_DT IN VARCHAR2) IS
       SELECT COURS_NUM, START_DT
         FROM CT_COURSE_INIT
        WHERE STUDY = P_STUDY
          AND PT = P_PT
          AND START_DT = (SELECT MAX(START_DT)
                            FROM CT_COURSE_INIT
                           WHERE STUDY = P_STUDY
                             AND PT = P_PT
                             AND START_DT <= RPAD(P_START_DT, 8, '0'));

   CURSOR GC_CRS1_DT(P_STUDY IN VARCHAR2, P_PT IN VARCHAR2) IS
       SELECT START_DT
         FROM CT_COURSE_INIT
        WHERE STUDY = P_STUDY
          AND PT = P_PT
          AND COURS_NUM = '1'
          AND ROWNUM = 1;

   CURSOR GC_REG_DT(P_STUDY IN VARCHAR2, P_PT IN VARCHAR2) IS
       SELECT REG_DT
         FROM CT_ENROLLMENT
        WHERE STUDY = P_STUDY
          AND PT = P_PT
          AND ROWNUM = 1;

   CURSOR GC_FILE_ID(P_STUDY IN VARCHAR2, P_PATIENT IN VARCHAR2, P_START_DT IN VARCHAR2) IS
       SELECT FILE_ID
         FROM CT_STG_DATA_DATES
        WHERE STUDY = P_STUDY
          AND PATIENT = P_PATIENT
          AND START_DT = P_START_DT
        GROUP BY FILE_ID;

   -- Program Data
   G_FATAL_ERR EXCEPTION;

   FUNCTION F_CRS_NUM_DT (P_STUDY    IN VARCHAR2,
                          P_PT       IN VARCHAR2,
                          P_START_DT IN VARCHAR2)  RETURN VARCHAR2
   IS
      T_CRS_NUM_DT    VARCHAR2(120);
      T_CRS_NUM       NUMBER;
      T_CRS_START_DT  VARCHAR2(30);
      T_DAY           NUMBER;
      T_CRS1_DT       VARCHAR2(30);
   BEGIN
      IF TRIM(P_START_DT) IS NULL THEN
         RETURN(' + ');
      END IF;

      OPEN GC_CRS_NUM_DT(P_STUDY, P_PT, P_START_DT);
      FETCH GC_CRS_NUM_DT INTO T_CRS_NUM, T_CRS_START_DT;
      IF GC_CRS_NUM_DT%NOTFOUND THEN
         CLOSE GC_CRS_NUM_DT;
         T_CRS1_DT := F_CRS1_DT(P_STUDY, P_PT);

         IF TRIM(T_CRS1_DT) IS NULL THEN
            RETURN(' + ');
         END IF;

         IF NVL(LENGTH(P_START_DT), 0) < 8 OR NVL(LENGTH(T_CRS1_DT), 0) < 8 THEN
            IF TO_NUMBER(RPAD(P_START_DT, 8, '0')) < TO_NUMBER(RPAD(T_CRS1_DT, 8, '0')) THEN
               RETURN ('-1+'||' ');    -- Not exist
            ELSE
               RETURN(' + ');
            END IF;
         ELSE
            T_DAY := ROUND(NVL(TO_DATE(P_START_DT, 'RRRRMMDD') - TO_DATE(T_CRS1_DT, 'RRRRMMDD'), 0));
            RETURN ('-1+'||T_DAY);    -- Not exist
         END IF;

      ELSE
         CLOSE GC_CRS_NUM_DT;

         IF NVL(LENGTH(P_START_DT), 0) < 8 OR NVL(LENGTH(T_CRS_START_DT), 0) < 8 THEN
            IF TO_NUMBER(RPAD(P_START_DT, 8, '0')) < TO_NUMBER(RPAD(T_CRS_START_DT, 8, '0')) THEN
               RETURN ('-1+'||' ');    -- Not exist
            ELSE
               RETURN(' + ');
            END IF;
         ELSE
            T_DAY := ROUND(NVL(TO_DATE(P_START_DT, 'RRRRMMDD') - TO_DATE(T_CRS_START_DT, 'RRRRMMDD'), 0));
         END IF;

         IF T_DAY >= 0 THEN
            T_DAY := T_DAY + 1;
         END IF;
         RETURN(RPAD(TO_CHAR(NVL(T_CRS_NUM, -1))||'+'||T_DAY, 20, ' ')||P_START_DT||'='||T_CRS_START_DT);
      END IF;
   Exception
      WHEN OTHERS THEN
         IF GC_CRS_NUM_DT%ISOPEN THEN
            CLOSE GC_CRS_NUM_DT;
         END IF;
         RETURN (' + ');
   END;

   FUNCTION F_CRS1_DT (P_STUDY IN VARCHAR2,
                       P_PT    IN VARCHAR2)  RETURN VARCHAR2
   IS
      T_CRS1_DT    VARCHAR2(120);

   BEGIN
      OPEN GC_CRS1_DT(P_STUDY, P_PT);
      FETCH GC_CRS1_DT INTO T_CRS1_DT;
      IF GC_CRS1_DT%NOTFOUND THEN
         CLOSE GC_CRS1_DT;
         RETURN (NULL);    -- Not exist
      ELSE
         CLOSE GC_CRS1_DT;
         RETURN(T_CRS1_DT);
      END IF;
   Exception
      WHEN OTHERS THEN
         IF GC_CRS1_DT%ISOPEN THEN
            CLOSE GC_CRS1_DT;
         END IF;
         RAISE;    -- Failure
   End;


   FUNCTION F_DAY_SINCE_REG (P_STUDY    IN VARCHAR2,
                             P_PT       IN VARCHAR2,
                             P_START_DT IN VARCHAR2)  RETURN NUMBER
   IS

      T_REG_DT    VARCHAR2(120);
      T_TEMP_NUM  NUMBER;

   BEGIN
      IF TRIM(P_START_DT) IS NULL  THEN
         RETURN(NULL);
      END IF;
      OPEN GC_REG_DT(P_STUDY, P_PT);
      FETCH GC_REG_DT INTO T_REG_DT;
      IF GC_REG_DT%NOTFOUND THEN
         CLOSE GC_REG_DT;
         RETURN (NULL);    -- Not exist
      ELSE
         CLOSE GC_REG_DT;
         T_TEMP_NUM := ROUND(NVL(TO_DATE(P_START_DT, 'RRRRMMDD') - TO_DATE(T_REG_DT, 'RRRRMMDD'), 0));
         IF T_TEMP_NUM >= 0 THEN
            T_TEMP_NUM := T_TEMP_NUM + 1;
         END IF;
         RETURN(T_TEMP_NUM);
      END IF;
   Exception
      WHEN OTHERS THEN
         IF GC_REG_DT%ISOPEN THEN
            CLOSE GC_REG_DT;
         END IF;
         RETURN(NULL);    -- Failure
   End;

   FUNCTION F_DAY_SINCE_CRS1 (P_START_DT IN VARCHAR2,
                              P_CRS1_DT  IN VARCHAR2)  RETURN NUMBER
   IS

     T_TEMP_NUM    NUMBER;

   BEGIN
      IF NVL(LENGTH(TRIM(P_START_DT)), 0) < 8 OR NVL(LENGTH(TRIM(P_CRS1_DT)), 0) < 8 THEN
         RETURN(NULL);
      END IF;
      T_TEMP_NUM := ROUND(NVL(TO_DATE(P_START_DT, 'RRRRMMDD') - TO_DATE(P_CRS1_DT, 'RRRRMMDD'), 0));
      IF T_TEMP_NUM >= 0 THEN
         T_TEMP_NUM := T_TEMP_NUM + 1;
      END IF;
      RETURN(T_TEMP_NUM);
   Exception
      WHEN OTHERS THEN
         RETURN(NULL);    -- Failure
   End;


   FUNCTION F_FILE_ID (P_STUDY    IN VARCHAR2,
                       P_PATIENT  IN VARCHAR2,
                       P_START_DT IN VARCHAR2)  RETURN VARCHAR2
   IS

      T_FILE_ID     VARCHAR2(2);
      T_STR        VARCHAR2(240);

   BEGIN
      OPEN GC_FILE_ID(P_STUDY, P_PATIENT, P_START_DT);
      LOOP
         T_FILE_ID := NULL;
         FETCH GC_FILE_ID INTO T_FILE_ID;
         EXIT WHEN GC_FILE_ID%NOTFOUND;
         T_STR := T_STR||','||T_FILE_ID;
      END LOOP;
      CLOSE GC_FILE_ID;
      RETURN(T_STR);
   Exception
      WHEN OTHERS THEN
         IF GC_FILE_ID%ISOPEN THEN
            CLOSE GC_FILE_ID;
         END IF;
         RETURN(NULL);    -- Failure
   End;


PROCEDURE P_CT_DATA_DT
 IS

  T_MOD_NAME           VARCHAR2(60)  := 'CT_BUILD_PKG.P_CT_EXT_ERRORS';
  T_STEP_NAME          VARCHAR2(30)   := '1';

BEGIN

   If Log_Util.Log$LogName is null Then
      Log_Util.LogSetName('PCTDATADT_' || to_char(sysdate, 'YYYYMMDD-HH24MI'),'DATADATE');
   Else
      Log_Util.LogMessage('  P_CT_DATA_DT Starting');
   End If;

   /* CT COURSE INIT Section */
   Log_Util.LogMessage('CTDT - TRUNCATE TABLE CT_COURSE_INIT Start');
   EXECUTE IMMEDIATE 'TRUNCATE TABLE CT_COURSE_INIT';
   Log_Util.LogMessage('CTDT - TRUNCATE TABLE CT_COURSE_INIT Finish');

   INSERT INTO CT_COURSE_INIT (STUDY, PT, START_DT, COURS_NUM  )
      SELECT STUDY, PT, START_DT, COURS_NUM
        FROM UNION_COURSE_INIT_VW;

   Log_Util.LogMessage('CTDT - CT_COURSE_INIT ('||to_char(SQL%RowCount)||' rows inserted).');
   COMMIT;

   Log_Util.LogMessage('CTDT - ANALYZING CT_COURSE_INIT Start.');
   EXECUTE IMMEDIATE 'ANALYZE TABLE CT_COURSE_INIT COMPUTE STATISTICS';
   Log_Util.LogMessage('CTDT - ANALYZING CT_COURSE_INIT Finish.');

   /* CT ENROLLEMNT INIT Section */
   Log_Util.LogMessage('CTDT - TRUNCATE TABLE CT_ENROLLMENT Start');
   EXECUTE IMMEDIATE 'TRUNCATE TABLE CT_ENROLLMENT';
   Log_Util.LogMessage('CTDT - TRUNCATE TABLE CT_ENROLLMENT Finish');

   INSERT INTO CT_ENROLLMENT (STUDY, PT, REG_DT)
      SELECT STUDY, PT, REG_DT
        FROM UNION_ENROLLMENT_VW;

   Log_Util.LogMessage('CTDT - CT_ENROLLMENT ('||to_char(SQL%RowCount)||' rows inserted).');
   COMMIT;

   Log_Util.LogMessage('CTDT - ANALYZING CT_ENROLLMENT Start.');
   EXECUTE IMMEDIATE 'ANALYZE TABLE CT_ENROLLMENT COMPUTE STATISTICS';
   Log_Util.LogMessage('CTDT - ANALYZING CT_ENROLLMENT Finish.');


   /* CT STG DATA DATES  Section */
   Log_Util.LogMessage('CTDT - TRUNCATE TABLE CT_STG_DATA_DATES Start');
   EXECUTE IMMEDIATE 'TRUNCATE TABLE CT_STG_DATA_DATES';
   Log_Util.LogMessage('CTDT - TRUNCATE TABLE CT_STG_DATA_DATES Finish');

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'TX';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [TX]).');

      INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
         SELECT STUDY, PT, ONSET_DT, NULL, 0, 'TX', DCMNAME
           FROM UNION_ADVERSE_EVENTS_VW;
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [TX]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [TX] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'MH';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [MH]).');

      INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
         SELECT STUDY, PT, EXAM_DT, NULL, 0, 'MH', DCMNAME
           FROM UNION_BASE_MED_HIST_VW;
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [MH]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [MH] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'BS';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [BS]).');

      INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
         SELECT STUDY, PT, ONSET_DT, NULL, 0, 'BS', DCMNAME
           FROM UNION_BASE_SYMP_VW;
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [BS]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [BS] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'PH';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [PH]).');

      INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
         SELECT STUDY, PT, NOTE_DT, NULL, 0, 'PH', DCMNAME
           FROM UNION_COMMENTS_VW;
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [PH]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [PH] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'CM';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [CM]).');

      INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
         SELECT STUDY, PT, START_DT, NULL, 0, 'CM', DCMNAME
           FROM UNION_CONCOM_MEDS_MEAS_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [CM]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [CM] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'CA';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [CA]).');

      INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
         SELECT STUDY, PT, COURSE_START_DT, NULL, 0, 'CA', DCMNAME
           FROM UNION_COURSE_ASSESS_VW;
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [CA]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [CA] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'CI';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [CI]).');

      INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
         SELECT STUDY, PT, START_DT, NULL, 0, 'CI', DCMNAME
           FROM UNION_COURSE_INIT_VW;
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [CI]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [CI] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'EC';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [EC]).');

      INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
         SELECT STUDY, PT, EFFCT_DT, NULL, 0, 'EC', DCMNAME
           FROM UNION_ELIG_CHECK_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [EC]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [EC] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'EN';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [EN]).');

      INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
         SELECT STUDY, PT, REG_DT, NULL, 0, 'EN', DCMNAME
           FROM UNION_ENROLLMENT_VW;
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [EN]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [EN] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'XT';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [XT]).');

      INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
         SELECT STUDY, PT, DCMDATE, NULL, 0, 'XT', DCMNAME
           FROM UNION_EXT_OF_DISEASE_VW;
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [XT]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [XT] DATES.');
   End;

   /*   PRC 06/15/04 : This section was commented out, Wrapped it anyway and left it commented
   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'FP';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [FP]).');

      INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
         SELECT STUDY, PT, DEATH_DT, NULL, 0, 'FP', DCMNAME
           FROM UNION_FOLLOW_UP_VW;
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [FP]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [FP] DATES.');
   End;      */

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'IE';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [IE]).');

      INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
         SELECT STUDY, PT, ONSET_DT, NULL, 0, 'IE', DCMNAME
           FROM UNION_INFECTION_EP_VW;
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [IE]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [IE] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'OTH';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [OTH]).');

      INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
         SELECT STUDY, PT, DCMDATE, DCMTIME, 1, 'OTH', DCMNAME
           FROM UNION_OTHER_LABS_VW;
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [OTH]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [OTH] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'BC';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [BC]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, DCMDATE, DCMTIME, 1, 'BC', DCMNAME
               FROM UNION_LAB_BC_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [BC]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [BC] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'BM';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [BM]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, DCMDATE, DCMTIME, 1, 'BM', DCMNAME
               FROM UNION_LAB_BM_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [BM]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [BM] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'HM';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [HM]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, DCMDATE, DCMTIME, 1, 'HM', DCMNAME
               FROM UNION_LAB_HM_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [HM]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [HM] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'IP';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [IP]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, DCMDATE, DCMTIME, 1, 'IP', DCMNAME
               FROM UNION_LAB_IP_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [IP]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [IP] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'LL';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [LL]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, DCMDATE, DCMTIME, 1, 'LL', DCMNAME
               FROM UNION_LAB_LL_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [LL]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [LL] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'NL';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [NL]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, DCMDATE, DCMTIME, 1, 'NL', DCMNAME
               FROM UNION_LAB_NL_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [NL]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [NL] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'OU';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [OU]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, DCMDATE, DCMTIME, 1, 'OU', DCMNAME
               FROM UNION_LAB_OU_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [OU]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [OU] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'RC';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [RC]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, DCMDATE, DCMTIME, 1, 'RC', DCMNAME
               FROM UNION_LAB_RC_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [RC]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [RC] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'RF';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [RF]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, DCMDATE, DCMTIME, 1, 'RF', DCMNAME
               FROM UNION_LAB_RF_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [RF]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [RF] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'SC';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [SC]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, DCMDATE, DCMTIME, 1, 'SC', DCMNAME
               FROM UNION_LAB_SC_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [SC]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [SC] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'SE';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [SE]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, DCMDATE, DCMTIME, 1, 'SE', DCMNAME
               FROM UNION_LAB_SE_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [SE]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [SE] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'SR';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [SR]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, DCMDATE, DCMTIME, 1, 'SR', DCMNAME
               FROM UNION_LAB_SR_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [SR]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [SR] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'UE';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [UE]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, DCMDATE, DCMTIME, 1, 'UE', DCMNAME
               FROM UNION_LAB_UE_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [UE]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [UE] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'UL';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [UL]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, DCMDATE, DCMTIME, 1, 'UL', DCMNAME
               FROM UNION_LAB_UL_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [UL]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [UL] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'US';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [US]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, DCMDATE, DCMTIME, 1, 'US', DCMNAME
               FROM UNION_LAB_US_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [US]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [US] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'FO';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [FO]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, OFF_STDY_DT, NULL, 0, 'FO', DCMNAME
               FROM UNION_OFF_STUDY_SUMM_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [FO]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [FO] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'PK';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [PK]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, DOSE_DT, NULL, 0, 'PK', DCMNAME
               FROM UNION_PHARMACOKINETICS_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [PK]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [PK] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'PE';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [PE]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, EXAM_DT, NULL, 0, 'PE', DCMNAME
               FROM UNION_PHYSICAL_EXAM_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [PE]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [PE] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'PR';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [PR]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, FRST_DOSE_DT, NULL, 0, 'PR', DCMNAME
               FROM UNION_PRIOR_RAD_SUPP_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [PR]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [PR] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'PS';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [PS]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, SURG_DT, NULL, 0, 'PS', DCMNAME
               FROM UNION_PRIOR_SURG_SUPP_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [PS]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [PS] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'PT';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [PT]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, FRST_DOSE_DT, NULL, 0, 'PT', DCMNAME
               FROM UNION_PRIOR_THRPY_SUPP_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [PT]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [PT] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'TF';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [TF]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, LAST_DOSE_DT, NULL, 0, 'TF', DCMNAME
               FROM UNION_PRIOR_TREAT_SUMM_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [TF]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [TF] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'SN';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [SN]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, SMPL_COLLCT_DT, NULL, 0, 'SN', DCMNAME
               FROM UNION_SCINTIGRAPHY_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [SN]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [SN] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'DA';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [DA]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, START_DT, NULL, 0, 'DA', DCMNAME
               FROM UNION_STUDY_DRUG_ADMIN_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [DA]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [DA] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'UX';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [UX]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, DOSE_DT, NULL, 0, 'UX', DCMNAME
               FROM UNION_URINARY_EXCR_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [UX]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [UX] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'PL';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [PL]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, LAB_DT, TIME, 1, 'PL', DCMNAME
               FROM UNION_VITAL_SIGNS_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [PL]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [PL] DATES.');
   End;

   Begin
      Delete From CT_STG_DATA_DATES
       where FILE_ID = 'PSA';
      Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows deleted [PSA]).');

         INSERT INTO CT_STG_DATA_DATES (STUDY, PATIENT, START_DT, START_TM, LAB_FLAG, FILE_ID, DCMNAME)
             SELECT STUDY, PT, SMPL_DT, SMPL_TM, 1, 'PSA', NULL
               FROM PSA_LAST_VW;
         Log_Util.LogMessage('CTDT - CT_STG_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted [PSA]).');
   Exception
      When Others Then
         Log_Util.LogMessage('CTDT - FAILURE TO COLLECT [PSA] DATES.');
   End;

   COMMIT;
   -------------------------------------

   Log_Util.LogMessage('CTDT - TRUNCATE TABLE CT_DATA_DATES Start');
   EXECUTE IMMEDIATE 'TRUNCATE TABLE CT_DATA_DATES';
   Log_Util.LogMessage('CTDT - TRUNCATE TABLE CT_DATA_DATES Finish.');

   INSERT INTO CT_DATA_DATES (
                 STUDY
                ,PATIENT
                ,START_DT
                ,PSA_IND
                ,ADVERSE_EVENTS_IND
                ,BASELINE_MEDICAL_HIST_IND
                ,BASELINE_SYMPTOMS_IND
                ,COMMENTS_IND
                ,CONCOMITANTS_IND
                ,COURSE_ASSESSMENT_IND
                ,COURSE_INITIATION_IND
                ,ELIGIBILITY_IND
                ,ENROLLMENT_IND
                ,EXTENT_OF_DISEASE_IND
                ,FOLLOW_UP_IND
                ,INFECTION_EPISODE_IND
                ,OTHER_LABS_IND
                ,BLOOD_CHEMISTRY_IND
                ,BONE_MARROW_IND
                ,HEMATOLOGY_IND
                ,IMMUNE_PARAMETERS_IND
                ,PROCEDURES_IND
                ,SPECIAL_LABS_IND
                ,OTHER_URINARY_RESULTS_IND
                ,RED_CELL_INDICES_IND
                ,RESPIRATORY_FUNCTION_IND
                ,OTHER_SERUM_CHEMICTRIES_IND
                ,SERUM_ELECTRO_IND
                ,SEROLOGY_IND
                ,URINE_IMMUNE_ELECTRO_IND
                ,UNANTICIPATED_LABS_IND
                ,URINALYSIS_IND
                ,OFF_STUDY_IND
                ,PHARMACOKINETICS_IND
                ,PHYSICAL_EXAM_IND
                ,PRIOR_RADIATION_SUPPLEMENT_IND
                ,PRIOR_SURGERY_SUPPLEMENT_IND
                ,PRIOR_THERAPY_SUPPLEMENT_IND
                ,PRIOR_TREATMENT_SUMMARY_IND
                ,SCINTIGRAPHY_IND
                ,DRUG_ADMIN_IND
                ,URINARY_EXCRETION_IND
                ,VITAL_SIGNS_IND     )
       SELECT STUDY
             ,PATIENT
             ,START_DT
             ,MAX(DECODE(FILE_ID, 'PSA', 1, 0))    PSA_IND
             ,MAX(DECODE(DCMNAME, 'ADVERSE EVENTS', 1, 0))    ADVERSE_EVENTS_IND
             ,MAX(DECODE(DCMNAME, 'BASE MED HIST', 1, 0))    BASE_MED_HIST_IND
             ,MAX(DECODE(DCMNAME, 'BASE SYMP', 1, 0))    BASE_SYMP_IND
             ,MAX(DECODE(DCMNAME, 'COMMENTS', 1, 0))    COMMENTS_IND
             ,MAX(DECODE(DCMNAME, 'CONCOM MEDS/MEAS', 1, 0))    CONCOM_MEDS_MEAS_IND
             ,MAX(DECODE(DCMNAME, 'COURSE ASSESS', 1, 0))    COURSE_ASSESS_IND
             ,MAX(DECODE(DCMNAME, 'COURSE INIT', 1, 0))    COURSE_INIT_IND
             ,MAX(DECODE(DCMNAME, 'ELIG CHECK', 1, 0))    ELIG_CHECK_IND
             ,MAX(DECODE(DCMNAME, 'ENROLLMENT', 1, 0))    ENROLLMENT_IND
             ,MAX(DECODE(DCMNAME, 'EXT OF DISEASE', 1, 0))    EXT_OF_DISEASE_IND
             ,MAX(DECODE(DCMNAME, 'FOLLOW_UP', 1, 0))    FOLLOW_UP_IND
             ,MAX(DECODE(DCMNAME, 'INFECTION EP', 1, 0))    INFECTION_EP_IND
             ,MAX(DECODE(DCMNAME, 'LAB_ALL', 1, 0))    OTHER_LABS_IND
             ,MAX(DECODE(DCMNAME, 'LAB_BC', 1, 0))    LAB_BC_IND
             ,MAX(DECODE(DCMNAME, 'LAB_BM', 1, 0))    LAB_BM_IND
             ,MAX(DECODE(DCMNAME, 'LAB_HM', 1, 0))    LAB_HM_IND
             ,MAX(DECODE(DCMNAME, 'LAB_IP', 1, 0))    LAB_IP_IND
             ,MAX(DECODE(DCMNAME, 'LAB_LL', 1, 0))    LAB_LL_IND
             ,MAX(DECODE(DCMNAME, 'LAB_NL', 1, 0))    LAB_NL_IND
             ,MAX(DECODE(DCMNAME, 'LAB_OU', 1, 0))    LAB_OU_IND
             ,MAX(DECODE(DCMNAME, 'LAB_RC', 1, 0))    LAB_RC_IND
             ,MAX(DECODE(DCMNAME, 'LAB_RF', 1, 0))    LAB_RF_IND
             ,MAX(DECODE(DCMNAME, 'LAB_SC', 1, 0))    LAB_SC_IND
             ,MAX(DECODE(DCMNAME, 'LAB_SE', 1, 0))    LAB_SE_IND
             ,MAX(DECODE(DCMNAME, 'LAB_SR', 1, 0))    LAB_SR_IND
             ,MAX(DECODE(DCMNAME, 'LAB_UE', 1, 0))    LAB_UE_IND
             ,MAX(DECODE(DCMNAME, 'LAB_UL', 1, 0))    LAB_UL_IND
             ,MAX(DECODE(DCMNAME, 'LAB_US', 1, 0))    LAB_US_IND
             ,MAX(DECODE(DCMNAME, 'OFF STUDY SUMM', 1, 0))    OFF_STUDY_SUMM_IND
             ,MAX(DECODE(DCMNAME, 'PHARMACOKINETICS', 1, 0))    PHARMACOKINETICS_IND
             ,MAX(DECODE(DCMNAME, 'PHYSICAL EXAM', 1, 0))    PHYSICAL_EXAM_IND
             ,MAX(DECODE(DCMNAME, 'PRIOR RAD SUPP', 1, 0))    PRIOR_RAD_SUPP_IND
             ,MAX(DECODE(DCMNAME, 'PRIOR SURG SUPP', 1, 0))    PRIOR_SURG_SUPP_IND
             ,MAX(DECODE(DCMNAME, 'PRIOR THRPY SUPP', 1, 0))    PRIOR_THRPY_SUPP_IND
             ,MAX(DECODE(DCMNAME, 'PRIOR TREAT SUMM', 1, 0))    PRIOR_TREAT_SUMM_IND
             ,MAX(DECODE(DCMNAME, 'SCINTIGRAPHY', 1, 0))    SCINTIGRAPHY_IND
             ,MAX(DECODE(DCMNAME, 'STUDY DRUG ADMIN', 1, 0))    STUDY_DRUG_ADMIN_IND
             ,MAX(DECODE(DCMNAME, 'URINARY_EXCR', 1, 0))    URINARY_EXCR_IND
             ,MAX(DECODE(DCMNAME, 'VITAL SIGNS', 1, 0))    VITAL_SIGNS_IND
         FROM CT_STG_DATA_DATES
       GROUP BY STUDY
               ,PATIENT
               ,START_DT;

   Log_Util.LogMessage('CTDT - CT_DATA_DATES ('||to_char(SQL%RowCount)||' rows inserted)');

   COMMIT;

   UPDATE CT_DATA_DATES
      SET NOTE = CTVW_PKG.F_CRS_NUM_DT(STUDY, PATIENT, START_DT);

   Log_Util.LogMessage('CTDT - CT_DATA_DATES ('||to_char(SQL%RowCount)||' rows updated (NOTE)');
   COMMIT;

   UPDATE CT_DATA_DATES
     SET COURSE_NUM = TRIM(SUBSTR(NOTE, 1, INSTR(NOTE, '+') - 1))
        ,NUM_OF_DAY = TRIM(SUBSTR(NOTE, INSTR(NOTE, '+') + 1, 10));

   Log_Util.LogMessage('CTDT - CT_DATA_DATES ('||to_char(SQL%RowCount)||' rows updated (COURSE_NUM, NUM_OF_DAY)');
   COMMIT;

   UPDATE CT_DATA_DATES
      SET DAY_SINCE_REG = CTVW_PKG.F_DAY_SINCE_REG(STUDY, PATIENT, START_DT);

   Log_Util.LogMessage('CTDT - CT_DATA_DATES ('||to_char(SQL%RowCount)||' rows updated (DAY_SINCE_REG)');
   COMMIT;

   FOR T_THIS_REC IN (SELECT STUDY, PATIENT FROM CT_DATA_DATES GROUP BY STUDY, PATIENT) LOOP
     UPDATE CT_DATA_DATES
        SET CRS1_DT = CTVW_PKG.F_CRS1_DT(STUDY, PATIENT)
      WHERE STUDY = T_THIS_REC.STUDY
        AND PATIENT = T_THIS_REC.PATIENT;
   END LOOP;
   Log_Util.LogMessage('CTDT - CT_DATA_DATES ('||to_char(SQL%RowCount)||' rows updated (CRS1_DT)');
   COMMIT;

   UPDATE CT_DATA_DATES
      SET DAY_SINCE_CRS1 = CTVW_PKG.F_DAY_SINCE_CRS1(START_DT, CRS1_DT);

   Log_Util.LogMessage('CTDT - CT_DATA_DATES ('||to_char(SQL%RowCount)||' rows updated (DAY_SINCE_CRS1)');
   COMMIT;

   UPDATE CT_DATA_DATES A
      SET A.LAB_FLAG = 1
    WHERE EXISTS (SELECT 1
                   FROM CT_STG_DATA_DATES B
                  WHERE A.STUDY = B.STUDY
                    AND A.PATIENT = B.PATIENT
                    AND A.START_DT = B.START_DT
                    AND B.LAB_FLAG = 1);

   Log_Util.LogMessage('CTDT - CT_DATA_DATES ('||to_char(SQL%RowCount)||' rows updated (LAB_FLAG))');
   COMMIT;

--  UPDATE CT_DATA_DATES
--     SET FILE_ID = F_FILE_ID(STUDY, PATIENT, START_DT);
  COMMIT;

  Log_Util.LogMessage('CTDT - ANALYZING CT_DATA_DATES Start.');
  EXECUTE IMMEDIATE 'ANALYZE TABLE CT_DATA_DATES COMPUTE STATISTICS';
  Log_Util.LogMessage('CTDT - ANALYZING CT_DATA_DATES Finish.');

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20000,'Error occured in '||T_MOD_NAME||
                                    '-'||T_STEP_NAME||'----'||SQLERRM);
END;

BEGIN
  NULL;
END;
/


GRANT EXECUTE ON  CTDEV.CTVW_PKG2 TO PUBLIC;

