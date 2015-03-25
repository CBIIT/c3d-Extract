select A.*, NVL(B.PATIENT_FUL, A.PT) PATIENT_FUL, B.REG_INST_FUL 
from ( 
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
            ,DCMDATE       SMPL_DT 
            ,DCMTIME       SMPL_TM 
            ,ACTEVENT 
            ,SUBEVENT_NUMBER 
            ,VISIT_NUMBER 
            ,QUALIFYING_VALUE 
            ,QUALIFYING_QUESTION 
            ,LAB 
            ,LABRANGE_SUBSET_NUMBER 
            ,LAB_ASSIGNMENT_TYPE_CODE 
            ,LAB_ID 
            ,max(decode(LPARM,'BUN',LVALUE_FUL,NULL))          BUN_FUL 
            ,max(decode(LPARM,'CREATININE',LVALUE_FUL,NULL))          CREATININE_FUL 
            ,max(decode(LPARM,'SODIUM',LVALUE_FUL,NULL))          SODIUM_FUL 
            ,max(decode(LPARM,'POTASSIUM',LVALUE_FUL,NULL))          POTASSIUM_FUL 
            ,max(decode(LPARM,'CHLORIDE',LVALUE_FUL,NULL))          CHLORIDE_FUL 
            ,max(decode(LPARM,'MAGNESIUM',LVALUE_FUL,NULL))          MAGNESIUM_FUL 
            ,max(decode(LPARM,'BICARB_SERUM',LVALUE_FUL,NULL))          BICARB_FUL 
            ,max(decode(LPARM,'URIC_ACID',LVALUE_FUL,NULL))          URIC_ACID_FUL 
            ,max(decode(LPARM,'BILIRUBIN_TOTAL',LVALUE_FUL,NULL))          BILIRUBIN_FUL 
            ,max(decode(LPARM,'ALK_PHOS',LVALUE_FUL,NULL))         ALK_PHOS_FUL 
            ,max(decode(LPARM,'SGOT_AST',LVALUE_FUL,NULL))         SGOT_AST_FUL 
            ,max(decode(LPARM,'SGPT_ALT',LVALUE_FUL,NULL))         SGPT_ALT_FUL 
            ,max(decode(LPARM,'SGGT',LVALUE_FUL,NULL))         SGGT_FUL 
            ,max(decode(LPARM,'LDH',LVALUE_FUL,NULL))         LDH_FUL 
            ,max(decode(LPARM,'TOT_PROT',LVALUE_FUL,NULL))         TOTAL_PROT_FUL 
            ,max(decode(LPARM,'ALBUMIN_SERUM',LVALUE_FUL,NULL))         ALBUMIN_FUL 
            ,max(decode(LPARM,'GLOBULIN',LVALUE_FUL,NULL))         GLOBULIN_FUL 
            ,max(decode(LPARM,'CALCIUM',LVALUE_FUL,NULL))         CALCIUM_FUL 
            ,max(decode(LPARM,'INORG_PHOS',LVALUE_FUL,NULL))         INORG_PHOS_FUL 
            ,max(decode(LPARM,'GLUC_FASTING',LVALUE_FUL,NULL))         GLUC_FAST_FUL 
            ,max(decode(LPARM,'GLUC_NONFASTING',LVALUE_FUL,NULL))         GLUC_NFAST_FUL 
            ,max(decode(LPARM,'CHOLESTEROL_TOTAL',LVALUE_FUL,NULL))         CHOLEST_FUL 
            ,max(decode(LPARM,'AMYLASE_SERUM',LVALUE_FUL,NULL))         AMYLASE_FUL 
            ,max(decode(LPARM,'5_NUCLEOTIDASE',LVALUE_FUL,NULL))         FIVE_NUCLEO_FUL 
            ,max(decode(LPARM,'CPK',LVALUE_FUL,NULL))         CREAT_PHOS_FUL 
           from PP_OC_OWNER.LBBCLBBC 
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
            ,LAB_ID ) A, 
  PP_EXT_OWNER.CTS_PTID_ENRL_VW B 
WHERE A.STUDY = B.STUDY (+) 
  AND A.PT = B.PT (+) 
UNION
select A.*, NVL(B.PATIENT_FUL, A.PT) PATIENT_FUL, B.REG_INST_FUL 
from ( 
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
            ,DCMDATE       SMPL_DT 
            ,DCMTIME       SMPL_TM 
            ,ACTEVENT 
            ,SUBEVENT_NUMBER 
            ,VISIT_NUMBER 
            ,QUALIFYING_VALUE 
            ,QUALIFYING_QUESTION 
            ,LAB 
            ,LABRANGE_SUBSET_NUMBER 
            ,LAB_ASSIGNMENT_TYPE_CODE 
            ,LAB_ID 
            ,max(decode(LPARM,'BUN',LVALUE_FUL,NULL))          BUN_FUL 
            ,max(decode(LPARM,'CREATININE',LVALUE_FUL,NULL))          CREATININE_FUL 
            ,max(decode(LPARM,'SODIUM',LVALUE_FUL,NULL))          SODIUM_FUL 
            ,max(decode(LPARM,'POTASSIUM',LVALUE_FUL,NULL))          POTASSIUM_FUL 
            ,max(decode(LPARM,'CHLORIDE',LVALUE_FUL,NULL))          CHLORIDE_FUL 
            ,max(decode(LPARM,'MAGNESIUM',LVALUE_FUL,NULL))          MAGNESIUM_FUL 
            ,max(decode(LPARM,'BICARB_SERUM',LVALUE_FUL,NULL))          BICARB_FUL 
            ,max(decode(LPARM,'URIC_ACID',LVALUE_FUL,NULL))          URIC_ACID_FUL 
            ,max(decode(LPARM,'BILIRUBIN_TOTAL',LVALUE_FUL,NULL))          BILIRUBIN_FUL 
            ,max(decode(LPARM,'ALK_PHOS',LVALUE_FUL,NULL))         ALK_PHOS_FUL 
            ,max(decode(LPARM,'SGOT_AST',LVALUE_FUL,NULL))         SGOT_AST_FUL 
            ,max(decode(LPARM,'SGPT_ALT',LVALUE_FUL,NULL))         SGPT_ALT_FUL 
            ,max(decode(LPARM,'SGGT',LVALUE_FUL,NULL))         SGGT_FUL 
            ,max(decode(LPARM,'LDH',LVALUE_FUL,NULL))         LDH_FUL 
            ,max(decode(LPARM,'TOT_PROT',LVALUE_FUL,NULL))         TOTAL_PROT_FUL 
            ,max(decode(LPARM,'ALBUMIN_SERUM',LVALUE_FUL,NULL))         ALBUMIN_FUL 
            ,max(decode(LPARM,'GLOBULIN',LVALUE_FUL,NULL))         GLOBULIN_FUL 
            ,max(decode(LPARM,'CALCIUM',LVALUE_FUL,NULL))         CALCIUM_FUL 
            ,max(decode(LPARM,'INORG_PHOS',LVALUE_FUL,NULL))         INORG_PHOS_FUL 
            ,max(decode(LPARM,'GLUC_FASTING',LVALUE_FUL,NULL))         GLUC_FAST_FUL 
            ,max(decode(LPARM,'GLUC_NONFASTING',LVALUE_FUL,NULL))         GLUC_NFAST_FUL 
            ,max(decode(LPARM,'CHOLESTEROL_TOTAL',LVALUE_FUL,NULL))         CHOLEST_FUL 
            ,max(decode(LPARM,'AMYLASE_SERUM',LVALUE_FUL,NULL))         AMYLASE_FUL 
            ,max(decode(LPARM,'5_NUCLEOTIDASE',LVALUE_FUL,NULL))         FIVE_NUCLEO_FUL 
            ,max(decode(LPARM,'CPK',LVALUE_FUL,NULL))         CREAT_PHOS_FUL 
           from PP_OC_OWNER.LBALLAB
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
            ,LAB_ID ) A, 
  PP_EXT_OWNER.CTS_PTID_ENRL_VW B 
WHERE A.STUDY = B.STUDY (+) 
  AND A.PT = B.PT (+)