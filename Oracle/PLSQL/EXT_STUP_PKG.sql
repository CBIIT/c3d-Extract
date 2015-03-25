PROMPT Creating Package 'EXT_STUP_PKG'

CREATE OR REPLACE PACKAGE EXT_STUP_PKG
  IS
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/*     Author: Patrick Conrad- Ekagra Software Technologies (Original Unknown)       */
/*       Date: 02/17/2009                                                            */
/*Description: This package contains functions and procedure used by the Data Extract*/
/*             utility to Create and Maintain objects within Extra Schemas.          */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/*  Modification History                                                             */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

Function Count_Snapshot_VWS(iOwner  in Varchar2) Return Number;

Procedure SET_STUDY_CTRL(iSTUDY in Varchar2,
                         iObjectOwner in Varchar2,
                         iExtObjectOwner in Varchar2);

Procedure Build_Ext_Schema(iObjectOwner in Varchar2);

Procedure Set_Report_Ctrl(iStudy in Varchar2,
                          iReportTo in Varchar2,
                          iVersion in Varchar2,
                          iReportAs in Varchar2);

Procedure Set_Crs_Ctrl(iStudy in Varchar2,
                       iReportTo in Varchar2,
                       iVersion in Varchar2,
                       iTemplateStudy in Varchar2,
                       iTemplateReportTo in Varchar2,
                       iTemplateVersion in Varchar2);

Procedure Set_View_Ctrl(iStudy in Varchar2,
                        iMrnInstCd in Varchar2,
                        iTemplateStudy in Varchar2);

Procedure Set_File_Ctrl(iStudy in Varchar2,
                        iReportTo in Varchar2,
                        iVersion in Varchar2,
                        iTemplateStudy in Varchar2,
                        iTemplateReportTo in Varchar2,
                        iTemplateVersion in Varchar2);

End;
/

Show Error

PROMPT Creating Package Body 'EXT_STUP_PKG'

CREATE OR REPLACE PACKAGE BODY EXT_STUP_PKG
  IS

-- PL/SQL Private Declaration

-- Program Data
--G_FATAL_ERR EXCEPTION;

-- Sub-Program Units

Function Count_Snapshot_VWS (iOwner  in Varchar2)
Return Number Is
/* Checks existance of SnapShot Views and returns count of those found */

   xCnt  Number := 0;

Begin
   SELECT COUNT(*)
     INTO xCnt
     FROM ALL_VIEWS
    WHERE OWNER = iOwner;

   Return xCnt;

Exception
   WHEN NO_DATA_FOUND THEN
      RETURN (0);
   WHEN OTHERS THEN
      RAISE;    -- Failure
End;

Procedure SET_STUDY_CTRL(iStudy in Varchar2,
                         iObjectOwner in Varchar2,
                         iExtObjectOwner in Varchar2) is

/* Inserts or Updates the CT_EXT_STUDY_CTL table for Study being added to Extract. */

   xCnt  Number := 0;

Begin
   Begin
      SELECT 1 INTO xCnt
        FROM CT_EXT_STUDY_CTL
       WHERE OC_STUDY = iStudy
         AND ROWNUM = 1;

      UPDATE CT_EXT_STUDY_CTL
         SET OC_OBJECT_OWNER = iObjectOwner,
             EXT_OBJECT_OWNER = iExtObjectOwner
       WHERE OC_STUDY = iStudy;

   Exception
      WHEN NO_DATA_FOUND THEN
         INSERT INTO CT_EXT_STUDY_CTL(OC_STUDY, OC_OBJECT_OWNER, EXT_OBJECT_OWNER)
  	                       VALUES(iStudy, iObjectOwner, iExtObjectOwner);
   End;

   Commit;

End;

Procedure Build_Ext_Schema(iObjectOwner in Varchar2) is
/* This procedure creates or updates the Extract Schema that holds te Extract Objects for the Study */

   xCnt  Number := 0;

Begin

   Begin
      SELECT 1 INTO xCnt
  	FROM ALL_USERS
       WHERE USERNAME = iObjectOwner
  	 AND ROWNUM = 1;

   Exception
      WHEN NO_DATA_FOUND THEN

         Execute Immediate ('CREATE USER '||iObjectOwner ||' IDENTIFIED BY SECRET '||
                            'DEFAULT TABLESPACE TEST_DATA TEMPORARY TABLESPACE TEMP '||
                            'QUOTA UNLIMITED ON TEST_DATA' ); -- Vanessa says so
    End;

    Execute Immediate('GRANT EXTRACT_OWNER TO '||iObjectOwner );
    Execute Immediate('GRANT RXCLIN_MOD TO '||iObjectOwner );
  --  Execute Immediate('GRANT SELECT ANY TABLE TO '||iObjectOwner );
  --  Execute Immediate('GRANT CONNECT TO '||iObjectOwner );
  --  Execute Immediate('GRANT RESOURCE TO '||iObjectOwner );
  --  Execute Immediate('GRANT UNLIMITED TABLESPACE TO '||iObjectOwner );
  --  Execute Immediate('GRANT OCLAPI_KEY_CHANGES TO '||iObjectOwner );
  --  Execute Immediate('GRANT OCLAPI_KEY_CHANGEST TO '||iObjectOwner );
  --  Execute Immediate('GRANT OCLAPI_UPDATE TO '||iObjectOwner );
  --  Execute Immediate('GRANT OCLAPI_UPDATET TO '||iObjectOwner );
  --  Execute Immediate('GRANT OCL_ACCESS TO '||iObjectOwner );
  --  Execute Immediate('GRANT OC_STUDY_ROLE TO '||iObjectOwner );
  --  Execute Immediate('GRANT RXCLIN_READ TO '||iObjectOwner );
  --  Execute Immediate('GRANT RXC_ANY TO '||iObjectOwner );

End;

Procedure Set_Report_Ctrl(iStudy in Varchar2,
                          iReportTo in Varchar2,
                          iVersion in Varchar2,
                          iReportAs in Varchar2) IS

/* This procedure creates or updates the Extract Study Report Control Table */

   xCnt  Number := 0;

Begin

   Begin
      -- Check the Report table for the Study AND version (PRC Added Version)
      SELECT 1 INTO xCnt
        FROM CT_EXT_STUDY_RPT_CTL
       WHERE OC_STUDY = iStudy
         AND REPORT_TO = iReportTo
         AND VERSION = iVersion
         AND ROWNUM = 1;

      UPDATE CT_EXT_STUDY_RPT_CTL
         SET VERSION = iVersion,
             REPORT_AS = iReportAs
       WHERE OC_STUDY = iStudy
         AND REPORT_TO = iReportTo
         AND VERSION = iVersion;

   Exception
      WHEN NO_DATA_FOUND THEN
         INSERT INTO CT_EXT_STUDY_RPT_CTL(OC_STUDY, REPORT_TO, VERSION, REPORT_AS )
  	                           VALUES(iStudy, iReportTo, iVersion, iReportAs);
   End;

   Commit;

End;

Procedure Set_View_Ctrl(iStudy in Varchar2,
                        iMrnInstCd in Varchar2,
                        iTemplateStudy in Varchar2) IS

/* This procedure creates or updates the Extract Study View Definitions based upon template Study */

   xText  LONG;
   xCnt  Number := 0;

Begin

   Begin
      SELECT 1 INTO xCnt
        FROM CT_EXT_VW_CTL
       WHERE OC_STUDY = iStudy
         AND ROWNUM = 1;

      DELETE FROM CT_EXT_VW_CTL
       WHERE OC_STUDY = iStudy;

   Exception
      WHEN NO_DATA_FOUND THEN
         NULL;
   End;

   FOR TT IN (SELECT * FROM CT_EXT_VW_CTL
               WHERE OC_STUDY = iTemplateStudy) Loop

      IF TT.VIEW_NAME = 'CTS_PTID_VW' THEN
         xText := REPLACE(TT.TEXT, 'CCR', iMrnInstCd);
      ELSIF TT.VIEW_NAME = 'CT_RECEIVED_DCMS_VW' THEN
         xText := REPLACE(TT.TEXT, iTemplateStudy, iStudy);
      ELSE
  	 xText := TT.TEXT;
      END IF;

      INSERT INTO CT_EXT_VW_CTL (OC_STUDY, VIEW_NAME, CRT_SEQ, TEXT, SYNONYM_NAME)
  		   	 VALUES (iStudy, TT.VIEW_NAME, TT.CRT_SEQ, xText, TT.SYNONYM_NAME);
   End Loop;

   Commit;

End;

Procedure Set_Crs_Ctrl(iStudy in Varchar2,
                       iReportTo in Varchar2,
                       iVersion in Varchar2,
                       iTemplateStudy in Varchar2,
                       iTemplateReportTo in Varchar2,
                       iTemplateVersion in Varchar2) IS

/* This procedure copies Template Cursors to New Study/Deleting old study cursors if needed */


   xCnt  Number := 0;

Begin
   Begin
      SELECT 1 INTO xCnt
        FROM CT_EXT_CRS_CTL
       WHERE OC_STUDY = iStudy
         AND REPORT_TO = iReportTo
         AND VERSION = iVersion
         AND ROWNUM = 1;

      DELETE FROM CT_EXT_CRS_CTL
       WHERE OC_STUDY = iStudy
         AND REPORT_TO = iReportTo
         AND VERSION = iVersion;

   Exception
      WHEN NO_DATA_FOUND THEN
         NULL;
   End;

   FOR TT IN (SELECT * FROM CT_EXT_CRS_CTL
  	       WHERE OC_STUDY = iTemplateStudy
  		 AND REPORT_TO = iTemplateReportTo
  		 AND VERSION = iTemplateVersion) LOOP

      INSERT INTO CT_EXT_CRS_CTL (OC_STUDY, REPORT_TO, VERSION, FILE_ID, CRS_NAME, CRS_TYPE, EXT_SEQ, TEXT, EXT_SOURCE)
  		   	  VALUES (iStudy, iReportTo, iVersion, TT.FILE_ID, TT.CRS_NAME, TT.CRS_TYPE, TT.EXT_SEQ, TT.TEXT, TT.EXT_SOURCE);
      -- NOTE: During conversion found a bug where the wrong ReportTo and Version where being used during the insert.
      --       Previous statement used ReportTo and Version from the TT cursor, New one uses TARGET ReportTo and Version
   End Loop;

   Commit;

End;

Procedure Set_File_Ctrl(iStudy in Varchar2,
                        iReportTo in Varchar2,
                        iVersion in Varchar2,
                        iTemplateStudy in Varchar2,
                        iTemplateReportTo in Varchar2,
                        iTemplateVersion in Varchar2) IS

/* This procedure copies Template File Controls to New Study using Template Study */

   xCnt  Number := 0;

Begin

   Begin
      SELECT 1 INTO xCnt
  	FROM CT_EXT_FILE_CTL
       WHERE OC_STUDY = iStudy
  	 AND REPORT_TO = iReportTo
  	 AND VERSION = iVersion
  	 AND ROWNUM = 1;

      DELETE FROM CT_EXT_FILE_CTL
       WHERE OC_STUDY = iStudy
  	 AND REPORT_TO = iReportTo
  	 AND VERSION = iVersion;

   Exception
      WHEN NO_DATA_FOUND THEN
         NULL;
   End;

   FOR TT IN (SELECT * FROM CT_EXT_FILE_CTL
               WHERE OC_STUDY = iTemplateStudy
                 AND REPORT_TO = iTemplateReportTo
                 AND VERSION = iTemplateVersion) LOOP

      INSERT INTO CT_EXT_FILE_CTL (OC_STUDY, FILE_ID, INST_ID, EXT_IND,REPORT_TO, VERSION,
                                   LAST_EXT_DATE, CURRENT_EXT_DATE, UPD_LAST_EXT_DATE)
                           VALUES (iStudy, TT.FILE_ID, TT.INST_ID, TT.EXT_IND, iReportTo, iVersion,
                                    TT.LAST_EXT_DATE, TT.CURRENT_EXT_DATE, TT.UPD_LAST_EXT_DATE);

      -- NOTE: During conversion found a bug where the wrong ReportTo and Version where being used during the insert.
      --       Previous statement used ReportTo and Version from the TT cursor, New one uses TARGET ReportTo and Version

   End Loop;

   Commit;

End;

END;
/

SHOW ERROR
