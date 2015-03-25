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
      ,NULL                                                                               TEST_1_FUL
      ,NULL                                                                               TEST_1_RANG_IND
      ,NULL                                                                               TEST_1_GRADE_FUL
      ,NULL                                                                               TEST_10_FUL
      ,NULL                                                                               TEST_10_RANG_IND
      ,NULL                                                                               TEST_10_GRADE_FUL
      ,NULL                                                                               TEST_11_FUL
      ,NULL                                                                               TEST_11_RANG_IND
      ,NULL                                                                               TEST_11_GRADE_FUL
      ,NULL                                                                               TEST_12_FUL
      ,NULL                                                                               TEST_12_RANG_IND
      ,NULL                                                                               TEST_12_GRADE_FUL
      ,NULL                                                                               TEST_13_FUL
      ,NULL                                                                               TEST_13_RANG_IND
      ,NULL                                                                               TEST_13_GRADE_FUL
      ,NULL                                                                               TEST_14_FUL
      ,NULL                                                                               TEST_14_RANG_IND
      ,NULL                                                                               TEST_14_GRADE_FUL
      ,NULL                                                                               TEST_15_FUL
      ,NULL                                                                               TEST_15_RANG_IND
      ,NULL                                                                               TEST_15_GRADE_FUL
      ,NULL                                                                               TEST_16_FUL
      ,NULL                                                                               TEST_16_RANG_IND
      ,NULL                                                                               TEST_16_GRADE_FUL
      ,NULL                                                                               TEST_17_FUL
      ,NULL                                                                               TEST_17_RANG_IND
      ,NULL                                                                               TEST_17_GRADE_FUL
      ,NULL                                                                               TEST_18_FUL
      ,NULL                                                                               TEST_18_RANG_IND
      ,NULL                                                                               TEST_18_GRADE_FUL
      ,NULL                                                                               TEST_19_FUL
      ,NULL                                                                               TEST_19_RANG_IND
      ,NULL                                                                               TEST_19_GRADE_FUL
      ,NULL                                                                               TEST_2_FUL
      ,NULL                                                                               TEST_2_RANG_IND
      ,NULL                                                                               TEST_2_GRADE_FUL
      ,NULL                                                                               TEST_20_FUL
      ,NULL                                                                               TEST_20_RANG_IND
      ,NULL                                                                               TEST_20_GRADE_FUL
      ,NULL                                                                               TEST_21_FUL
      ,NULL                                                                               TEST_21_RANG_IND
      ,NULL                                                                               TEST_21_GRADE_FUL
      ,NULL                                                                               TEST_22_FUL
      ,NULL                                                                               TEST_22_RANG_IND
      ,NULL                                                                               TEST_22_GRADE_FUL
      ,NULL                                                                               TEST_23_FUL
      ,NULL                                                                               TEST_23_RANG_IND
      ,NULL                                                                               TEST_23_GRADE_FUL
      ,NULL                                                                               TEST_24_FUL
      ,NULL                                                                               TEST_24_RANG_IND
      ,NULL                                                                               TEST_24_GRADE_FUL
      ,NULL                                                                               TEST_25_FUL
      ,NULL                                                                               TEST_25_RANG_IND
      ,NULL                                                                               TEST_25_GRADE_FUL
      ,NULL                                                                               TEST_3_FUL
      ,NULL                                                                               TEST_3_RANG_IND
      ,NULL                                                                               TEST_3_GRADE_FUL
      ,NULL                                                                               TEST_4_FUL
      ,NULL                                                                               TEST_4_RANG_IND
      ,NULL                                                                               TEST_4_GRADE_FUL
      ,NULL                                                                               TEST_5_FUL
      ,NULL                                                                               TEST_5_RANG_IND
      ,NULL                                                                               TEST_5_GRADE_FUL
      ,NULL                                                                               TEST_6_FUL
      ,NULL                                                                               TEST_6_RANG_IND
      ,NULL                                                                               TEST_6_GRADE_FUL
      ,NULL                                                                               TEST_7_FUL
      ,NULL                                                                               TEST_7_RANG_IND
      ,NULL                                                                               TEST_7_GRADE_FUL
      ,NULL                                                                               TEST_8_FUL
      ,NULL                                                                               TEST_8_RANG_IND
      ,NULL                                                                               TEST_8_GRADE_FUL
      ,NULL                                                                               TEST_9_FUL
      ,NULL                                                                               TEST_9_RANG_IND
      ,NULL                                                                               TEST_9_GRADE_FUL
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
        TEST_10_FUL IS NOT NULL
     OR TEST_11_FUL IS NOT NULL
     OR TEST_12_FUL IS NOT NULL
     OR TEST_13_FUL IS NOT NULL
     OR TEST_14_FUL IS NOT NULL
     OR TEST_15_FUL IS NOT NULL
     OR TEST_16_FUL IS NOT NULL
     OR TEST_17_FUL IS NOT NULL
     OR TEST_18_FUL IS NOT NULL
     OR TEST_19_FUL IS NOT NULL
     OR TEST_1_FUL IS NOT NULL
     OR TEST_20_FUL IS NOT NULL
     OR TEST_21_FUL IS NOT NULL
     OR TEST_22_FUL IS NOT NULL
     OR TEST_23_FUL IS NOT NULL
     OR TEST_24_FUL IS NOT NULL
     OR TEST_25_FUL IS NOT NULL
     OR TEST_2_FUL IS NOT NULL
     OR TEST_3_FUL IS NOT NULL
     OR TEST_4_FUL IS NOT NULL
     OR TEST_5_FUL IS NOT NULL
     OR TEST_6_FUL IS NOT NULL
     OR TEST_7_FUL IS NOT NULL
     OR TEST_8_FUL IS NOT NULL
     OR TEST_9_FUL IS NOT NULL ) A,
  PP_EXT_OWNER.CTS_PTID_ENRL_VW B
WHERE A.STUDY = B.STUDY (+)
  AND A.PT = B.PT (+)