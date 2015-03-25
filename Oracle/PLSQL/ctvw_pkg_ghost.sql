CREATE OR REPLACE PACKAGE CTDEV.CTVW_PKG IS
  /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
  /*    Authors: Patrick Conrad - Ekagra                                               */
  /*       Date: 07/01/2005                                                            */
  /*Description: PLEASE NOT THAT THIS IS A GHOST PACKAGE.  IT HAS BEEN CREATED TO CHECK*/
  /*             VALIDATETY OF REAL PACKAGE BEFORE EXECUTING REAL PACKAGE.             */
  /*             Package was created to resolve continuing problem with CTVW_PKG2      */
  /*             becoming invalid due to missing or invalid Views
  /*    Effects: CTDEV.CTVW_PKG2 - The Real Package.                                   */
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


CREATE OR REPLACE PACKAGE BODY CTDEV.CTVW_PKG IS

   -- Program Data
   G_FATAL_ERR EXCEPTION;

   FUNCTION F_CRS_NUM_DT (P_STUDY    IN VARCHAR2,
                          P_PT       IN VARCHAR2,
                          P_START_DT IN VARCHAR2)  RETURN VARCHAR2
   IS

      v_status        varchar2(200);
      v_return        varchar2(2000);

   BEGIN
       select 'X'
         into v_status
         from all_objects
           where owner = 'CTDEV'
             and object_name = 'CTVW_PKG'
             and ((object_type = 'PACKAGE' and status = 'INVALID')
               or (object_type = 'PACKAGE BODY' and status = 'INVALID'));

       Raise G_FATAL_ERR;

   Exception
      When No_DATA_FOUND Then
         v_return := CTVW_PKG2.F_CRS_NUM_DT(P_STUDY, P_PT, P_START_DT);
         return v_return;
      When Others then
         Raise;
   ENd;

   FUNCTION F_CRS1_DT (P_STUDY IN VARCHAR2,
                       P_PT    IN VARCHAR2)  RETURN VARCHAR2
   IS
      v_status        varchar2(200);
      v_return        varchar2(2000);

   BEGIN
       select 'X'
         into v_status
         from all_objects
           where owner = 'CTDEV'
             and object_name = 'CTVW_PKG'
             and object_type = 'PACKAGE' and status = 'VALID';

       select 'X'
         into v_status
         from all_objects
           where owner = 'CTDEV'
             and object_name = 'CTVW_PKG'
             and object_type = 'PACKAGE BODY' and status = 'VALID';

      v_return := CTVW_PKG2.F_CRS1_DT(P_STUDY, P_PT);
         return v_return;

   Exception
      When No_DATA_FOUND Then
            Raise;
      When Others then
         Raise;
   End;


   FUNCTION F_DAY_SINCE_REG (P_STUDY    IN VARCHAR2,
                             P_PT       IN VARCHAR2,
                             P_START_DT IN VARCHAR2)  RETURN NUMBER
   IS
      v_status        varchar2(200);
      v_return        Number;

   BEGIN
       select 'X'
         into v_status
         from all_objects
           where owner = 'CTDEV'
             and object_name = 'CTVW_PKG'
             and ((object_type = 'PACKAGE' and status = 'INVALID')
               or (object_type = 'PACKAGE BODY' and status = 'INVALID'));

       Raise G_FATAL_ERR;

   Exception
      When No_DATA_FOUND Then
         v_return := CTVW_PKG2.F_DAY_SINCE_REG(P_STUDY, P_PT,P_START_DT);
         return v_return;
      When Others then
         Raise;
   End;

   FUNCTION F_DAY_SINCE_CRS1 (P_START_DT IN VARCHAR2,
                              P_CRS1_DT  IN VARCHAR2)  RETURN NUMBER
   IS
      v_status        varchar2(200);
      v_return        Number;

   BEGIN
       select 'X'
         into v_status
         from all_objects
           where owner = 'CTDEV'
             and object_name = 'CTVW_PKG'
             and ((object_type = 'PACKAGE' and status = 'INVALID')
               or (object_type = 'PACKAGE BODY' and status = 'INVALID'));

       Raise G_FATAL_ERR;

   Exception
      When No_DATA_FOUND Then
         v_return := CTVW_PKG2.F_DAY_SINCE_CRS1(P_START_DT, P_CRS1_DT);
         return v_return;
      When Others then
         Raise;
   End;


   FUNCTION F_FILE_ID (P_STUDY    IN VARCHAR2,
                       P_PATIENT  IN VARCHAR2,
                       P_START_DT IN VARCHAR2)  RETURN VARCHAR2
   IS

      v_status        varchar2(200);
      v_return        Varchar2(2000);

   BEGIN
       select 'X'
         into v_status
         from all_objects
           where owner = 'CTDEV'
             and object_name = 'CTVW_PKG'
             and ((object_type = 'PACKAGE' and status = 'INVALID')
               or (object_type = 'PACKAGE BODY' and status = 'INVALID'));

       Raise G_FATAL_ERR;

   Exception
      When No_DATA_FOUND Then
         v_return := CTVW_PKG2.F_FILE_ID(P_STUDY, P_PATIENT,P_START_DT);
         return v_return;
      When Others then
         Raise;
   End;


   PROCEDURE P_CT_DATA_DT IS

      v_status        varchar2(200);
      v_return        Varchar2(2000);
      v_jobnumber     number;

   BEGIN
       If Log_Util.Log$LogName is null Then
            Log_Util.LogSetName('PCTDATADT_' || to_char(sysdate, 'YYYYMMDD-HH24MI'),'DATADATE');
       End If;

       Log_Util.LogMessage('   Checking Validity of CTVW_PKG2 Package.');

       select 'X'
         into v_status
         from all_objects
           where owner = 'CTDEV'
             and object_name = 'CTVW_PKG2'
             and object_type = 'PACKAGE' and status = 'VALID';


       Log_Util.LogMessage('   Package appears Valid.');

       Log_Util.LogMessage('   Checking Validity of CTVW_PKG2 Package Body.');

       select 'X'
         into v_status
         from all_objects
           where owner = 'CTDEV'
             and object_name = 'CTVW_PKG2'
             and object_type = 'PACKAGE BODY' and status = 'VALID';

       Log_Util.LogMessage('   Package Body appears Valid.');

       Log_Util.LogMessage('   Submitting Job "ctvw_pkg2.p_ct_data_dt".');

       DBMS_JOB.Submit(v_jobnumber,'Begin ctvw_pkg2.p_ct_data_dt; ENd;');

   Exception
      When No_DATA_FOUND Then
         Log_Util.LogMessage('  P_CT_DATA_DT Cannot Start.  Does not Exists or is Invalid.');
      When Others then
         Log_Util.LogMessage('  P_CT_DATA_DT Cannot Start.  Does not Exists or is Invalid.');
   END;

BEGIN
  NULL;
END;
/


GRANT EXECUTE ON  CTDEV.CTVW_PKG TO OPS$BDL;

GRANT EXECUTE ON  CTDEV.CTVW_PKG TO CTVIEW;

GRANT EXECUTE ON  CTDEV.CTVW_PKG TO CTVIEW_ROLE;

