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
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'ANC',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))              ANC_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'ANC',LAB_RANGE_IND,NULL),NULL))              ANC_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'ANC',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))              ANC_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'A_LYMPH',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))          ATYP_LYMPH_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'A_LYMPH',LAB_RANGE_IND,NULL),NULL))          ATYP_LYMPH_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'A_LYMPH',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))          ATYP_LYMPH_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'BANDS',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))            BANDS_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'BANDS',LAB_RANGE_IND,NULL),NULL))            BANDS_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'BANDS',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))            BANDS_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'BASO',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))             BASOPHILS_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'BASO',LAB_RANGE_IND,NULL),NULL))             BASOPHILS_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'BASO',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))             BASOPHILS_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'BLAST_CELLS',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))      BLASTS_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'BLAST_CELLS',LAB_RANGE_IND,NULL),NULL))      BLASTS_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'BLAST_CELLS',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))      BLASTS_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'EOSIN',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))            EOSINOPHIL_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'EOSIN',LAB_RANGE_IND,NULL),NULL))            EOSINOPHIL_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'EOSIN',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))            EOSINOPHIL_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'ESR',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))              ESR_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'ESR',LAB_RANGE_IND,NULL),NULL))              ESR_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'ESR',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))              ESR_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'HEMATOCRIT',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))       HEMATOCRIT_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'HEMATOCRIT',LAB_RANGE_IND,NULL),NULL))       HEMATOCRIT_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'HEMATOCRIT',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))       HEMATOCRIT_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'HEMOGLOBIN',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))       HEMOGLOBIN_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'HEMOGLOBIN',LAB_RANGE_IND,NULL),NULL))       HEMOGLOBIN_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'HEMOGLOBIN',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))       HEMOGLOBIN_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'LYMPHOCYTES_SERUM',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))  LYMPHOCYTE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'LYMPHOCYTES_SERUM',LAB_RANGE_IND,NULL),NULL))  LYMPHOCYTE_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'LYMPHOCYTES_SERUM',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))  LYMPHOCYTE_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'MONOCYTES_SERUM',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))  MONOCYTES_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'MONOCYTES_SERUM',LAB_RANGE_IND,NULL),NULL))  MONOCYTES_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'MONOCYTES_SERUM',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))  MONOCYTES_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'NEUT',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))             NEUTROPHIL_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'NEUT',LAB_RANGE_IND,NULL),NULL))             NEUTROPHIL_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'NEUT',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))             NEUTROPHIL_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'OTHR_DIFF',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))        OTHER_DIFF_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'OTHR_DIFF',LAB_RANGE_IND,NULL),NULL))        OTHER_DIFF_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'OTHR_DIFF',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))        OTHER_DIFF_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'PLT',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))              PLATELETS_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'PLT',LAB_RANGE_IND,NULL),NULL))              PLATELETS_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'PLT',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))              PLATELETS_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'PT',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))               PTIME_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'PT',LAB_RANGE_IND,NULL),NULL))               PTIME_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'PT',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))               PTIME_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'PTT',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))              PTT_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'PTT',LAB_RANGE_IND,NULL),NULL))              PTT_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'PTT',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))              PTT_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'RBC_SERUM',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))        RBC_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'RBC_SERUM',LAB_RANGE_IND,NULL),NULL))        RBC_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'RBC_SERUM',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))        RBC_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'RETIC',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))            RETICULO_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'RETIC',LAB_RANGE_IND,NULL),NULL))            RETICULO_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'RETIC',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))            RETICULO_GRADE_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'WBC_SERUM',SUBSTR(LVALUE_FUL, 1, 20),NULL),NULL))        WBC_FUL
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'WBC_SERUM',LAB_RANGE_IND,NULL),NULL))        WBC_RANG_IND
      ,max(DECODE(PANEL,0, DECODE(LPARM_FUL,'WBC_SERUM',SUBSTR(CTC_GRADE_FUL, 1, 20),NULL),NULL))        WBC_GRADE_FUL
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
        ANC_FUL IS NOT NULL
     OR ATYP_LYMPH_FUL IS NOT NULL
     OR BANDS_FUL IS NOT NULL
     OR BASOPHILS_FUL IS NOT NULL
     OR BLASTS_FUL IS NOT NULL
     OR EOSINOPHIL_FUL IS NOT NULL
     OR ESR_FUL IS NOT NULL
     OR HEMATOCRIT_FUL IS NOT NULL
     OR HEMOGLOBIN_FUL IS NOT NULL
     OR LYMPHOCYTE_FUL IS NOT NULL
     OR MONOCYTES_FUL IS NOT NULL
     OR NEUTROPHIL_FUL IS NOT NULL
     OR OTHER_DIFF_FUL IS NOT NULL
     OR PLATELETS_FUL IS NOT NULL
     OR PTIME_FUL IS NOT NULL
     OR PTT_FUL IS NOT NULL
     OR RBC_FUL IS NOT NULL
     OR RETICULO_FUL IS NOT NULL
     OR WBC_FUL IS NOT NULL ) A,
  PP_EXT_OWNER.CTS_PTID_ENRL_VW B
WHERE A.STUDY = B.STUDY (+)
  AND A.PT = B.PT (+)