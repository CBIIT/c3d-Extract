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
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'HEP_C',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))            FIELD_1_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'HEP_C',LAB_RANGE_IND,NULL),NULL))            FIELD_1_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'HEP_C',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))            FIELD_1_GRADE_FUL
      ,NULL                                                                               FIELD_10_FUL
      ,NULL                                                                               FIELD_10_RANG_IND
      ,NULL                                                                               FIELD_10_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'QUALITATIVE_GLUCOSE',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))  FIELD_2_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'QUALITATIVE_GLUCOSE',LAB_RANGE_IND,NULL),NULL))  FIELD_2_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'QUALITATIVE_GLUCOSE',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))  FIELD_2_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'QUALITATIVE_PROTEIN',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))  FIELD_3_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'QUALITATIVE_PROTEIN',LAB_RANGE_IND,NULL),NULL))  FIELD_3_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'QUALITATIVE_PROTEIN',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))  FIELD_3_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'TESTOSTERONE_TOTAL',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))  FIELD_4_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'TESTOSTERONE_TOTAL',LAB_RANGE_IND,NULL),NULL))  FIELD_4_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'TESTOSTERONE_TOTAL',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))  FIELD_4_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'HLA_A02',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))          FIELD_5_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'HLA_A02',LAB_RANGE_IND,NULL),NULL))          FIELD_5_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'HLA_A02',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))          FIELD_5_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'HLA',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))              FIELD_6_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'HLA',LAB_RANGE_IND,NULL),NULL))              FIELD_6_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'HLA',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))              FIELD_6_GRADE_FUL
      ,NULL                                                                               FIELD_7_FUL
      ,NULL                                                                               FIELD_7_RANG_IND
      ,NULL                                                                               FIELD_7_GRADE_FUL
      ,NULL                                                                               FIELD_8_FUL
      ,NULL                                                                               FIELD_8_RANG_IND
      ,NULL                                                                               FIELD_8_GRADE_FUL
      ,NULL                                                                               FIELD_9_FUL
      ,NULL                                                                               FIELD_9_RANG_IND
      ,NULL                                                                               FIELD_9_GRADE_FUL
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
        FIELD_10_FUL IS NOT NULL
     OR FIELD_1_FUL IS NOT NULL
     OR FIELD_2_FUL IS NOT NULL
     OR FIELD_3_FUL IS NOT NULL
     OR FIELD_4_FUL IS NOT NULL
     OR FIELD_5_FUL IS NOT NULL
     OR FIELD_6_FUL IS NOT NULL
     OR FIELD_7_FUL IS NOT NULL
     OR FIELD_8_FUL IS NOT NULL
     OR FIELD_9_FUL IS NOT NULL ) A,
  PP_EXT_OWNER.CTS_PTID_ENRL_VW B
WHERE A.STUDY = B.STUDY (+)
  AND A.PT = B.PT (+)