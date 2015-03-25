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
 ,max(decode(LPARM,'IG_A_URINE',LVALUE_FUL,NULL))          IG_A_FUL 
 ,max(decode(LPARM,'IG_D_URINE',LVALUE_FUL,NULL))          IG_D_FUL 
 ,max(decode(LPARM,'IG_E_URINE',LVALUE_FUL,NULL))          IG_E_FUL 
 ,max(decode(LPARM,'IG_G_URINE',LVALUE_FUL,NULL))          IG_G_FUL 
 ,max(decode(LPARM,'IG_M_URINE',LVALUE_FUL,NULL))          IG_M_FUL 
 ,max(decode(LPARM,'MONOCLONAL_URINE',LVALUE_FUL,NULL))          MONOCLONAL_FUL 
 ,max(decode(LPARM,'POLYCLONAL_URINE',LVALUE_FUL,NULL))          POLYCLONAL_FUL 
 ,max(decode(LPARM,'KAPPA_URINE',LVALUE_FUL,NULL))          KAPPA_FUL 
 ,max(decode(LPARM,'LAMBDA_URINE',LVALUE_FUL,NULL))          LAMBDA_FUL 
 ,max(decode(LPARM,'BENCE_JONES_URINE',LVALUE_FUL,NULL))         BENCEJONES_FUL 
from PP_OC_OWNER.LBUELBUE 
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
 ,max(decode(LPARM,'IG_A_URINE',LVALUE_FUL,NULL))          IG_A_FUL 
 ,max(decode(LPARM,'IG_D_URINE',LVALUE_FUL,NULL))          IG_D_FUL 
 ,max(decode(LPARM,'IG_E_URINE',LVALUE_FUL,NULL))          IG_E_FUL 
 ,max(decode(LPARM,'IG_G_URINE',LVALUE_FUL,NULL))          IG_G_FUL 
 ,max(decode(LPARM,'IG_M_URINE',LVALUE_FUL,NULL))          IG_M_FUL 
 ,max(decode(LPARM,'MONOCLONAL_URINE',LVALUE_FUL,NULL))          MONOCLONAL_FUL 
 ,max(decode(LPARM,'POLYCLONAL_URINE',LVALUE_FUL,NULL))          POLYCLONAL_FUL 
 ,max(decode(LPARM,'KAPPA_URINE',LVALUE_FUL,NULL))          KAPPA_FUL 
 ,max(decode(LPARM,'LAMBDA_URINE',LVALUE_FUL,NULL))          LAMBDA_FUL 
 ,max(decode(LPARM,'BENCE_JONES_URINE',LVALUE_FUL,NULL))         BENCEJONES_FUL 
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