
CREATE TABLE SL_TEMP_FILE AS
  SELECT PROTOCOL, FILE_ID, VERSION     
    FROM CT_DATA 
   WHERE 1 = 2
/

CREATE TABLE SL_TEMP_LAST_REC AS
  SELECT A.ROWID A_ROWID, A.* 
    FROM CT_DATA A
    WHERE 1 = 2
/

CREATE TABLE SL_TEMP_ALL_REC AS   
  SELECT *
    FROM CT_DATA 
   WHERE 1 = 2
/



CREATE INDEX SL_LAST_REC_KEY1_I ON SL_TEMP_LAST_REC (KEY1);

CREATE INDEX SL_LAST_REC_KEY2_I ON SL_TEMP_LAST_REC (KEY2);

CREATE INDEX SL_LAST_REC_KEY3_I ON SL_TEMP_LAST_REC (KEY3);

CREATE INDEX SL_LAST_REC_KEY4_I ON SL_TEMP_LAST_REC (KEY4);

CREATE INDEX SL_LAST_REC_KEY5_I ON SL_TEMP_LAST_REC (KEY5);

CREATE INDEX SL_LAST_REC_FILE_ID_I ON SL_TEMP_LAST_REC (FILE_ID);

CREATE INDEX SL_LAST_REC_PROTOCOL_I ON SL_TEMP_LAST_REC (PROTOCOL);

CREATE INDEX SL_LAST_REC_PT_I ON SL_TEMP_LAST_REC (PT);

CREATE INDEX SL_LAST_REC_PATIENT_I ON SL_TEMP_LAST_REC (PATIENT);

CREATE INDEX SL_LAST_REC_SUBMISSION_FLAG_I ON SL_TEMP_LAST_REC (SUBMISSION_FLAG);


CREATE INDEX SL_ALL_REC_KEY1_I ON SL_TEMP_ALL_REC (KEY1);

CREATE INDEX SL_ALL_REC_KEY2_I ON SL_TEMP_ALL_REC (KEY2);

CREATE INDEX SL_ALL_REC_KEY3_I ON SL_TEMP_ALL_REC (KEY3);

CREATE INDEX SL_ALL_REC_KEY4_I ON SL_TEMP_ALL_REC (KEY4);

CREATE INDEX SL_ALL_REC_KEY5_I ON SL_TEMP_ALL_REC (KEY5);

CREATE INDEX SL_ALL_REC_FILE_ID_I ON SL_TEMP_ALL_REC (FILE_ID);

CREATE INDEX SL_ALL_REC_PROTOCOL_I ON SL_TEMP_ALL_REC (PROTOCOL);

CREATE INDEX SL_ALL_REC_PT_I ON SL_TEMP_ALL_REC (PT);

CREATE INDEX SL_ALL_REC_PATIENT_I ON SL_TEMP_ALL_REC (PATIENT);

CREATE INDEX SL_ALL_REC_SUBMISSION_FLAG_I ON SL_TEMP_ALL_REC (SUBMISSION_FLAG);


ANALYZE TABLE SL_TEMP_FILE COMPUTE STATISTICS;

ANALYZE TABLE SL_TEMP_LAST_REC COMPUTE STATISTICS;

ANALYZE TABLE SL_TEMP_ALL_REC  COMPUTE STATISTICS;


