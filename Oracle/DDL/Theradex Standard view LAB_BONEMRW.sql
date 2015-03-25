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
            ,max(decode(LPARM,'MYELOBLASTS',LVALUE_FUL,NULL))          MYELOBLAST_FUL 
            ,max(decode(LPARM,'PROMYELOCYTES',LVALUE_FUL,NULL))          PROMYELO_FUL 
            ,max(decode(LPARM,'MYELOCYTES_NEUTROS',LVALUE_FUL,NULL))          MYEL_NEUT_FUL 
            ,max(decode(LPARM,'MYELOCYTES_EOSINOS',LVALUE_FUL,NULL))          MYEL_EOS_FUL 
            ,max(decode(LPARM,'MYELOCYTES_BASOS',LVALUE_FUL,NULL))          MYEL_BASOS_FUL 
            ,max(decode(LPARM,'METAMYELOCYTES',LVALUE_FUL,NULL))          METAMYELO_FUL 
            ,max(decode(LPARM,'POLYMORPHS_NEUTROS',LVALUE_FUL,NULL))          POLY_NEUT_FUL 
            ,max(decode(LPARM,'POLYMORPHS_EOSINOS',LVALUE_FUL,NULL))          POLY_EOS_FUL 
            ,max(decode(LPARM,'POLYMORPHS_BASOS',LVALUE_FUL,NULL))          POLY_BASOS_FUL 
            ,max(decode(LPARM,'LYMPHOCYTES',LVALUE_FUL,NULL))         LYMPHOCYTE_FUL 
            ,max(decode(LPARM,'PLASMA_CELLS',LVALUE_FUL,NULL))         PLASMA_CEL_FUL 
            ,max(decode(LPARM,'MONOCYTES',LVALUE_FUL,NULL))         MONOCYTES_FUL 
            ,max(decode(LPARM,'RETICULUM_CELLS',LVALUE_FUL,NULL))         RETIC_CELL_FUL 
            ,max(decode(LPARM,'MEGAKARYOCYTES',LVALUE_FUL,NULL))         MEGAKARYO_FUL 
            ,max(decode(LPARM,'PRONORMOBLASTS',LVALUE_FUL,NULL))         PRONORMO_FUL 
            ,max(decode(LPARM,'NORMOBLASTS',LVALUE_FUL,NULL))         NORMOBLAST_FUL 
            ,max(decode(LPARM,'M_RATING',LVALUE_FUL,NULL))         M_RATING_FUL 
        from PP_OC_OWNER.LBBMLBBM 
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
            ,max(decode(LPARM,'MYELOBLASTS',LVALUE_FUL,NULL))          MYELOBLAST_FUL 
            ,max(decode(LPARM,'PROMYELOCYTES',LVALUE_FUL,NULL))          PROMYELO_FUL 
            ,max(decode(LPARM,'MYELOCYTES_NEUTROS',LVALUE_FUL,NULL))          MYEL_NEUT_FUL 
            ,max(decode(LPARM,'MYELOCYTES_EOSINOS',LVALUE_FUL,NULL))          MYEL_EOS_FUL 
            ,max(decode(LPARM,'MYELOCYTES_BASOS',LVALUE_FUL,NULL))          MYEL_BASOS_FUL 
            ,max(decode(LPARM,'METAMYELOCYTES',LVALUE_FUL,NULL))          METAMYELO_FUL 
            ,max(decode(LPARM,'POLYMORPHS_NEUTROS',LVALUE_FUL,NULL))          POLY_NEUT_FUL 
            ,max(decode(LPARM,'POLYMORPHS_EOSINOS',LVALUE_FUL,NULL))          POLY_EOS_FUL 
            ,max(decode(LPARM,'POLYMORPHS_BASOS',LVALUE_FUL,NULL))          POLY_BASOS_FUL 
            ,max(decode(LPARM,'LYMPHOCYTES',LVALUE_FUL,NULL))         LYMPHOCYTE_FUL 
            ,max(decode(LPARM,'PLASMA_CELLS',LVALUE_FUL,NULL))         PLASMA_CEL_FUL 
            ,max(decode(LPARM,'MONOCYTES',LVALUE_FUL,NULL))         MONOCYTES_FUL 
            ,max(decode(LPARM,'RETICULUM_CELLS',LVALUE_FUL,NULL))         RETIC_CELL_FUL 
            ,max(decode(LPARM,'MEGAKARYOCYTES',LVALUE_FUL,NULL))         MEGAKARYO_FUL 
            ,max(decode(LPARM,'PRONORMOBLASTS',LVALUE_FUL,NULL))         PRONORMO_FUL 
            ,max(decode(LPARM,'NORMOBLASTS',LVALUE_FUL,NULL))         NORMOBLAST_FUL 
            ,max(decode(LPARM,'M_RATING',LVALUE_FUL,NULL))         M_RATING_FUL 
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