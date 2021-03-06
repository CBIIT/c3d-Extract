select A.*, NVL(B.PATIENT_FUL, A.PT) PATIENT_FUL, B.REG_INST_FUL
from (
SELECT * FROM (
select
       STUDY
      ,DCMNAME
      ,DCMSUBNM
      ,SUBSETSN
      ,DOCNUM
      ,INVSITE
      ,INV
      ,PT
      ,ACCESSTS
      ,LOGINTS
      ,LSTCHGTS
      ,LOCKFLAG
      ,CPEVENT
      ,DCMDATE      SMPL_DT
      ,DCMTIME      SMPL_TM
      ,ACTEVENT
      ,SUBEVENT_NUMBER
      ,VISIT_NUMBER
      ,QUALIFYING_VALUE
      ,QUALIFYING_QUESTION
      ,LAB
      ,LABRANGE_SUBSET_NUMBER
      ,LAB_ASSIGNMENT_TYPE_CODE
      ,LAB_ID
      ,PANEL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'BILE',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))             BILE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'BILE',LAB_RANGE_IND,NULL),NULL))             BILE_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'BILE',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))             BILE_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'CASTS',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))            CASTS_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'CASTS',LAB_RANGE_IND,NULL),NULL))            CASTS_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'CASTS',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))            CASTS_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'COLLECTION_PERIOD',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))  COLL_PER_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'COLLECTION_PERIOD',LAB_RANGE_IND,NULL),NULL))  COLL_PER_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'COLLECTION_PERIOD',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))  COLL_PER_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'CREATININE_CLEARANCE',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))  CREAT_CLR_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'CREATININE_CLEARANCE',LAB_RANGE_IND,NULL),NULL))  CREAT_CLR_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'CREATININE_CLEARANCE',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))  CREAT_CLR_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'GLUCOSE',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))          GLUCOSE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'GLUCOSE',LAB_RANGE_IND,NULL),NULL))          GLUCOSE_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'GLUCOSE',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))          GLUCOSE_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'PH_URINE',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))         HYDROGEN_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'PH_URINE',LAB_RANGE_IND,NULL),NULL))         HYDROGEN_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'PH_URINE',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))         HYDROGEN_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'KETONES',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))          KETONES_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'KETONES',LAB_RANGE_IND,NULL),NULL))          KETONES_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'KETONES',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))          KETONES_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'PROTEIN',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))          PROTEIN_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'PROTEIN',LAB_RANGE_IND,NULL),NULL))          PROTEIN_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'PROTEIN',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))          PROTEIN_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'RBC_URINE',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))        RBCS_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'RBC_URINE',LAB_RANGE_IND,NULL),NULL))        RBCS_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'RBC_URINE',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))        RBCS_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'SPECIFIC_GRAVITY',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))  SP_GRAVITY_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'SPECIFIC_GRAVITY',LAB_RANGE_IND,NULL),NULL))  SP_GRAVITY_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'SPECIFIC_GRAVITY',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))  SP_GRAVITY_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'CREATININE_URINE',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))  URIN_CREAT_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'CREATININE_URINE',LAB_RANGE_IND,NULL),NULL))  URIN_CREAT_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'CREATININE_URINE',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))  URIN_CREAT_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'VOLUME_URINE',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))     VOLUME_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'VOLUME_URINE',LAB_RANGE_IND,NULL),NULL))     VOLUME_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'VOLUME_URINE',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))     VOLUME_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'WBC_URINE',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))        WBCS_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'WBC_URINE',LAB_RANGE_IND,NULL),NULL))        WBCS_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'WBC_URINE',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))        WBCS_GRADE_FUL
 from (
        SELECT A.*, NVL(B.PANEL, 0) PANEL
          FROM PP_OC_OWNER.LBALLAB A,
               (SELECT DISTINCT OC_LAB_QUESTION, PANEL
                  FROM NCI_LABTEST_MAPPING
                 WHERE FILE_ID IS NOT NULL
                   AND FIELD_NAME IS NOT NULL
                   AND OC_LAB_QUESTION IS NOT NULL
                   AND (OC_STUDY = 'ALL' OR OC_STUDY = 'THER_STD' )  ) B
         WHERE A.LPARM = B.OC_LAB_QUESTION
        )
 GROUP BY
      STUDY
     ,DCMNAME
     ,DCMSUBNM
     ,SUBSETSN
     ,DOCNUM
     ,INVSITE
     ,INV
     ,PT
     ,ACCESSTS
     ,LOGINTS
     ,LSTCHGTS
     ,LOCKFLAG
     ,CPEVENT
     ,DCMDATE
     ,DCMTIME
     ,ACTEVENT
     ,SUBEVENT_NUMBER
     ,VISIT_NUMBER
     ,QUALIFYING_VALUE
     ,QUALIFYING_QUESTION
     ,LAB
     ,LABRANGE_SUBSET_NUMBER
     ,LAB_ASSIGNMENT_TYPE_CODE
     ,LAB_ID
     ,PANEL )
  WHERE 
        BILE_FUL IS NOT NULL
     OR CASTS_FUL IS NOT NULL
     OR COLL_PER_FUL IS NOT NULL
     OR CREAT_CLR_FUL IS NOT NULL
     OR GLUCOSE_FUL IS NOT NULL
     OR HYDROGEN_FUL IS NOT NULL
     OR KETONES_FUL IS NOT NULL
     OR PROTEIN_FUL IS NOT NULL
     OR RBCS_FUL IS NOT NULL
     OR SP_GRAVITY_FUL IS NOT NULL
     OR URIN_CREAT_FUL IS NOT NULL
     OR VOLUME_FUL IS NOT NULL
     OR WBCS_FUL IS NOT NULL ) A,
  PP_EXT_OWNER.CTS_PTID_ENRL_VW B
WHERE A.STUDY = B.STUDY (+)
  AND A.PT = B.PT (+)