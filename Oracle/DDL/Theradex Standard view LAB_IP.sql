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
 ,max(decode(LPARM,'LYMPHOCYTE_BLASTS',LVALUE_FUL,NULL))          LYMPHOCYTE_FUL 
 ,max(decode(LPARM,'B_CELL_LEVEL',LVALUE_FUL,NULL))          B_CELL_LEV_FUL 
 ,max(decode(LPARM,'T_CELL_TOT',LVALUE_FUL,NULL))          T_CELL_TOT_FUL 
 ,max(decode(LPARM,'T_CELL_HELPER',LVALUE_FUL,NULL))          T_CELL_HLP_FUL 
 ,max(decode(LPARM,'T_CELL_SUPPRESSOR',LVALUE_FUL,NULL))          T_CELL_SUP_FUL 
 ,max(decode(LPARM,'T_CELL_DTH',LVALUE_FUL,NULL))          T_CELL_DTH_FUL 
 ,max(decode(LPARM,'T_CELL_CTL',LVALUE_FUL,NULL))          T_CELL_CTL_FUL 
 ,max(decode(LPARM,'NK_ACTIVITY',LVALUE_FUL,NULL))          NK_ACTIV_FUL 
 ,max(decode(LPARM,'ADCC',LVALUE_FUL,NULL))          ADCC_FUL 
 ,max(decode(LPARM,'MACROS_CYTOTXITY',LVALUE_FUL,NULL))         CYTOTOX_FUL 
 ,max(decode(LPARM,'MACROS_CYTOSTASIS',LVALUE_FUL,NULL))         CYTOSTASIS_FUL 
 ,max(decode(LPARM,'PEROXIDE_GENERATION',LVALUE_FUL,NULL))         PEROX_GEN_FUL 
 ,max(decode(LPARM,'SERUM_INTERFERON',LVALUE_FUL,NULL))         INTERFERON_FUL 
from PP_OC_OWNER.LBIPLBIP 
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
 ,max(decode(LPARM,'LYMPHOCYTE_BLASTS',LVALUE_FUL,NULL))          LYMPHOCYTE_FUL 
 ,max(decode(LPARM,'B_CELL_LEVEL',LVALUE_FUL,NULL))          B_CELL_LEV_FUL 
 ,max(decode(LPARM,'T_CELL_TOT',LVALUE_FUL,NULL))          T_CELL_TOT_FUL 
 ,max(decode(LPARM,'T_CELL_HELPER',LVALUE_FUL,NULL))          T_CELL_HLP_FUL 
 ,max(decode(LPARM,'T_CELL_SUPPRESSOR',LVALUE_FUL,NULL))          T_CELL_SUP_FUL 
 ,max(decode(LPARM,'T_CELL_DTH',LVALUE_FUL,NULL))          T_CELL_DTH_FUL 
 ,max(decode(LPARM,'T_CELL_CTL',LVALUE_FUL,NULL))          T_CELL_CTL_FUL 
 ,max(decode(LPARM,'NK_ACTIVITY',LVALUE_FUL,NULL))          NK_ACTIV_FUL 
 ,max(decode(LPARM,'ADCC',LVALUE_FUL,NULL))          ADCC_FUL 
 ,max(decode(LPARM,'MACROS_CYTOTXITY',LVALUE_FUL,NULL))         CYTOTOX_FUL 
 ,max(decode(LPARM,'MACROS_CYTOSTASIS',LVALUE_FUL,NULL))         CYTOSTASIS_FUL 
 ,max(decode(LPARM,'PEROXIDE_GENERATION',LVALUE_FUL,NULL))         PEROX_GEN_FUL 
 ,max(decode(LPARM,'SERUM_INTERFERON',LVALUE_FUL,NULL))         INTERFERON_FUL 
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