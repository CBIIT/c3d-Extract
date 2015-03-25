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
 ,max(decode(LPARM,'ALDOLASE',LVALUE_FUL,NULL))          ALDOLASE_FUL 
 ,max(decode(LPARM,'AMMONIA',LVALUE_FUL,NULL))          AMMONIA_FUL 
 ,max(decode(LPARM,'CALCIUM_IONIZD_SERUM',LVALUE_FUL,NULL))          CALCIUM_FUL 
 ,max(decode(LPARM,'COPPER_SERUM',LVALUE_FUL,NULL))          COPPER_FUL 
 ,max(decode(LPARM,'FERRITIN',LVALUE_FUL,NULL))          FERRITIN_FUL 
 ,max(decode(LPARM,'HDL',LVALUE_FUL,NULL))          HDL_FUL 
 ,max(decode(LPARM,'INSULIN',LVALUE_FUL,NULL))          INSULIN_FUL 
 ,max(decode(LPARM,'IRON_SERUM',LVALUE_FUL,NULL))          IRON_FUL 
 ,max(decode(LPARM,'IRON_BINDING_CAP',LVALUE_FUL,NULL))          IRON_BIND_FUL 
 ,max(decode(LPARM,'IRON_SATURATION',LVALUE_FUL,NULL))         IRON_SAT_FUL 
 ,max(decode(LPARM,'LDL',LVALUE_FUL,NULL))         LDL_FUL 
 ,max(decode(LPARM,'LIPASE_SERUM',LVALUE_FUL,NULL))         LIPASE_FUL 
 ,max(decode(LPARM,'OSMOLALITY_SERUM',LVALUE_FUL,NULL))         OSMOLALITY_FUL 
 ,max(decode(LPARM,'ACID_PHOSPHATASE',LVALUE_FUL,NULL))         ACID_PHOS_FUL 
 ,max(decode(LPARM,'TRANSFERRIN',LVALUE_FUL,NULL))         TRANSFERRI_FUL 
 ,max(decode(LPARM,'TRIGLYCERIDES',LVALUE_FUL,NULL))         TRIGLYC_FUL 
 ,max(decode(LPARM,'T3',LVALUE_FUL,NULL))         T3_FUL 
 ,max(decode(LPARM,'T4',LVALUE_FUL,NULL))         T4_FUL 
 ,max(decode(LPARM,'TSH',LVALUE_FUL,NULL))         TSH_FUL 
from PP_OC_OWNER.LBSCLBSC 
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
 ,max(decode(LPARM,'ALDOLASE',LVALUE_FUL,NULL))          ALDOLASE_FUL 
 ,max(decode(LPARM,'AMMONIA',LVALUE_FUL,NULL))          AMMONIA_FUL 
 ,max(decode(LPARM,'CALCIUM_IONIZD_SERUM',LVALUE_FUL,NULL))          CALCIUM_FUL 
 ,max(decode(LPARM,'COPPER_SERUM',LVALUE_FUL,NULL))          COPPER_FUL 
 ,max(decode(LPARM,'FERRITIN',LVALUE_FUL,NULL))          FERRITIN_FUL 
 ,max(decode(LPARM,'HDL',LVALUE_FUL,NULL))          HDL_FUL 
 ,max(decode(LPARM,'INSULIN',LVALUE_FUL,NULL))          INSULIN_FUL 
 ,max(decode(LPARM,'IRON_SERUM',LVALUE_FUL,NULL))          IRON_FUL 
 ,max(decode(LPARM,'IRON_BINDING_CAP',LVALUE_FUL,NULL))          IRON_BIND_FUL 
 ,max(decode(LPARM,'IRON_SATURATION',LVALUE_FUL,NULL))         IRON_SAT_FUL 
 ,max(decode(LPARM,'LDL',LVALUE_FUL,NULL))         LDL_FUL 
 ,max(decode(LPARM,'LIPASE_SERUM',LVALUE_FUL,NULL))         LIPASE_FUL 
 ,max(decode(LPARM,'OSMOLALITY_SERUM',LVALUE_FUL,NULL))         OSMOLALITY_FUL 
 ,max(decode(LPARM,'ACID_PHOSPHATASE',LVALUE_FUL,NULL))         ACID_PHOS_FUL 
 ,max(decode(LPARM,'TRANSFERRIN',LVALUE_FUL,NULL))         TRANSFERRI_FUL 
 ,max(decode(LPARM,'TRIGLYCERIDES',LVALUE_FUL,NULL))         TRIGLYC_FUL 
 ,max(decode(LPARM,'T3',LVALUE_FUL,NULL))         T3_FUL 
 ,max(decode(LPARM,'T4',LVALUE_FUL,NULL))         T4_FUL 
 ,max(decode(LPARM,'TSH',LVALUE_FUL,NULL))         TSH_FUL 
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