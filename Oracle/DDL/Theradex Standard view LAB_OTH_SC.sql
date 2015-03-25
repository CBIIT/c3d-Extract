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
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'ACID_PHOSPHATASE',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))  ACID_PHOS_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'ACID_PHOSPHATASE',LAB_RANGE_IND,NULL),NULL))  ACID_PHOS_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'ACID_PHOSPHATASE',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))  ACID_PHOS_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'ALDOLASE',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))         ALDOLASE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'ALDOLASE',LAB_RANGE_IND,NULL),NULL))         ALDOLASE_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'ALDOLASE',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))         ALDOLASE_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'AMMONIA',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))          AMMONIA_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'AMMONIA',LAB_RANGE_IND,NULL),NULL))          AMMONIA_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'AMMONIA',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))          AMMONIA_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'CALCIUM_IONIZD_SERUM',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))  CALCIUM_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'CALCIUM_IONIZD_SERUM',LAB_RANGE_IND,NULL),NULL))  CALCIUM_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'CALCIUM_IONIZD_SERUM',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))  CALCIUM_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'COPPER_SERUM',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))     COPPER_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'COPPER_SERUM',LAB_RANGE_IND,NULL),NULL))     COPPER_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'COPPER_SERUM',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))     COPPER_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'FERRITIN',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))         FERRITIN_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'FERRITIN',LAB_RANGE_IND,NULL),NULL))         FERRITIN_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'FERRITIN',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))         FERRITIN_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'HDL',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))              HDL_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'HDL',LAB_RANGE_IND,NULL),NULL))              HDL_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'HDL',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))              HDL_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'INSULIN',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))          INSULIN_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'INSULIN',LAB_RANGE_IND,NULL),NULL))          INSULIN_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'INSULIN',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))          INSULIN_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'IRON_SERUM',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))       IRON_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'IRON_SERUM',LAB_RANGE_IND,NULL),NULL))       IRON_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'IRON_SERUM',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))       IRON_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'IRON_BINDING_CAP',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))  IRON_BIND_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'IRON_BINDING_CAP',LAB_RANGE_IND,NULL),NULL))  IRON_BIND_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'IRON_BINDING_CAP',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))  IRON_BIND_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'IRON_SATURATION',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))  IRON_SAT_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'IRON_SATURATION',LAB_RANGE_IND,NULL),NULL))  IRON_SAT_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'IRON_SATURATION',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))  IRON_SAT_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'LDL',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))              LDL_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'LDL',LAB_RANGE_IND,NULL),NULL))              LDL_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'LDL',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))              LDL_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'LIPASE_SERUM',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))     LIPASE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'LIPASE_SERUM',LAB_RANGE_IND,NULL),NULL))     LIPASE_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'LIPASE_SERUM',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))     LIPASE_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'OSMOLALITY_SERUM',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))  OSMOLALITY_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'OSMOLALITY_SERUM',LAB_RANGE_IND,NULL),NULL))  OSMOLALITY_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'OSMOLALITY_SERUM',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))  OSMOLALITY_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'T3',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))               T3_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'T3',LAB_RANGE_IND,NULL),NULL))               T3_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'T3',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))               T3_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'T4',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))               T4_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'T4',LAB_RANGE_IND,NULL),NULL))               T4_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'T4',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))               T4_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'TRANSFERRIN',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))      TRANSFERRI_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'TRANSFERRIN',LAB_RANGE_IND,NULL),NULL))      TRANSFERRI_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'TRANSFERRIN',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))      TRANSFERRI_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'TRIGLYCERIDES',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))    TRIGLYC_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'TRIGLYCERIDES',LAB_RANGE_IND,NULL),NULL))    TRIGLYC_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'TRIGLYCERIDES',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))    TRIGLYC_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'TSH',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))              TSH_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'TSH',LAB_RANGE_IND,NULL),NULL))              TSH_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'TSH',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))              TSH_GRADE_FUL
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
        ACID_PHOS_FUL IS NOT NULL
     OR ALDOLASE_FUL IS NOT NULL
     OR AMMONIA_FUL IS NOT NULL
     OR CALCIUM_FUL IS NOT NULL
     OR COPPER_FUL IS NOT NULL
     OR FERRITIN_FUL IS NOT NULL
     OR HDL_FUL IS NOT NULL
     OR INSULIN_FUL IS NOT NULL
     OR IRON_BIND_FUL IS NOT NULL
     OR IRON_FUL IS NOT NULL
     OR IRON_SAT_FUL IS NOT NULL
     OR LDL_FUL IS NOT NULL
     OR LIPASE_FUL IS NOT NULL
     OR OSMOLALITY_FUL IS NOT NULL
     OR T3_FUL IS NOT NULL
     OR T4_FUL IS NOT NULL
     OR TRANSFERRI_FUL IS NOT NULL
     OR TRIGLYC_FUL IS NOT NULL
     OR TSH_FUL IS NOT NULL ) A,
  PP_EXT_OWNER.CTS_PTID_ENRL_VW B
WHERE A.STUDY = B.STUDY (+)
  AND A.PT = B.PT (+)