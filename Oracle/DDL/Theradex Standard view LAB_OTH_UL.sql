select A.*, NVL(B.PATIENT_FUL, A.PT) PATIENT_FUL, B.REG_INST_FUL
from (SELECT C.* 
        FROM PP_OC_OWNER.LBALLAB C
       WHERE NOT EXISTS 
                (SELECT 1
                   FROM NCI_LABTEST_MAPPING D
                  WHERE D.OC_LAB_QUESTION = C.LPARM
                    AND D.FILE_ID IS NOT NULL
                    AND D.FIELD_NAME IS NOT NULL)
         AND C.SIGNIFICANCE_FLAG = 'Y'
         AND C.LVALUE_FUL IS NOT NULL) A, 
     PP_EXT_OWNER.CTS_PTID_ENRL_VW B
WHERE A.STUDY = B.STUDY (+)
  AND A.PT = B.PT (+)