/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* Author: Patrick R Conrad - Ekagra Software Technologies   */
/* Date:   10/28/2003                                        */
/* Description:                                              */
/* This file contains the needed Roles and privilege         */
/* statements needed to setup Extract Processing for the     */
/* CTEXT schema.                                             */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
Create role EXTRACT_ADMIN;

Create Role EXTRACT_EXECUTE;

GRANT CREATE ANY SYNONYM TO EXTRACT_ADMIN;
GRANT CREATE ANY TABLE   TO EXTRACT_ADMIN;
GRANT CREATE ANY VIEW    TO EXTRACT_ADMIN;
GRANT DELETE ANY TABLE   TO EXTRACT_ADMIN;
GRANT DROP ANY SYNONYM   TO EXTRACT_ADMIN;
GRANT DROP ANY TABLE     TO EXTRACT_ADMIN;
GRANT CREATE USER        TO EXTRACT_ADMIN;
GRANT SELECT ANY TABLE   TO EXTRACT_ADMIN;
GRANT BECOME USER        TO EXTRACT_ADMIN;
GRANT ALTER USER         TO EXTRACT_ADMIN;

Grant select on CTEXT.CT_APP_META_DATA to EXTRACT_EXECUTE;

Grant select, insert, update, delete on CTEXT.CT_APP_META_DATA to EXTRACT_ADMIN;

Grant select on CTEXT.CT_DATA_MAP_CTL to EXTRACT_EXECUTE;

Grant select, insert, update, delete on CTEXT.CT_DATA_MAP_CTL to EXTRACT_ADMIN;

Grant select on CTEXT.CT_EXT_ACCOUNTS to EXTRACT_EXECUTE;

Grant select, insert, update, delete on CTEXT.CT_EXT_ACCOUNTS to EXTRACT_ADMIN;

Grant select on CTEXT.CT_EXT_CRS_CTL to EXTRACT_EXECUTE;

Grant select, insert, update, delete on CTEXT.CT_EXT_CRS_CTL to EXTRACT_ADMIN;

Grant select, insert, update, delete on CTEXT.CT_EXT_DATA to EXTRACT_EXECUTE;

Grant select, insert, update, delete on CTEXT.CT_EXT_DATA to EXTRACT_ADMIN;

Grant select, insert, update, delete on CTEXT.CT_EXT_ERRORS to EXTRACT_EXECUTE;

Grant select, insert, update, delete on CTEXT.CT_EXT_ERRORS to EXTRACT_ADMIN;

Grant select, insert, update, delete on CTEXT.CT_EXT_FILE_CTL to EXTRACT_EXECUTE;

Grant select, insert, update, delete on CTEXT.CT_EXT_FILE_CTL to EXTRACT_ADMIN;

Grant select, insert, update, delete on CTEXT.CT_EXT_LOGS to EXTRACT_EXECUTE;

Grant select, insert, update, delete on CTEXT.CT_EXT_LOGS to EXTRACT_ADMIN;

Grant select, insert, update, delete on CTEXT.CT_EXT_OC_OBJ_CTL to EXTRACT_EXECUTE;

Grant select, insert, update, delete on CTEXT.CT_EXT_OC_OBJ_CTL to EXTRACT_ADMIN;

Grant select, insert, update, delete on CTEXT.CT_EXT_STUDY_CTL to EXTRACT_EXECUTE;

Grant select, insert, update, delete on CTEXT.CT_EXT_STUDY_CTL to EXTRACT_ADMIN;

Grant select, insert, update, delete on CTEXT.CT_EXT_STUDY_RPT_CTL to EXTRACT_EXECUTE;

Grant select, insert, update, delete on CTEXT.CT_EXT_STUDY_RPT_CTL to EXTRACT_ADMIN;

Grant select, insert, update, delete on CTEXT.CT_EXT_TEMP to EXTRACT_EXECUTE;

Grant select, insert, update, delete on CTEXT.CT_EXT_TEMP to EXTRACT_ADMIN;

Grant select, insert, update, delete on CTEXT.CT_EXT_VW_CTL to EXTRACT_EXECUTE;

Grant select, insert, update, delete on CTEXT.CT_EXT_VW_CTL to EXTRACT_ADMIN;

Grant select, insert, update, delete on CTEXT.CT_REC_TYPE to EXTRACT_EXECUTE;

Grant select, insert, update, delete on CTEXT.CT_REC_TYPE to EXTRACT_ADMIN;

Grant select, insert, update, delete on OC_DATA.CT_DATA to EXTRACT_EXECUTE;

Grant select, insert, update, delete on OC_DATA.CT_DATA to EXTRACT_ADMIN;

Grant select, insert, update, delete on OC_DATA.CDUS_DATA to EXTRACT_EXECUTE;

Grant select, insert, update, delete on OC_DATA.CDUS_DATA to EXTRACT_ADMIN;

grant execute on CTEXT.EXTRACT_PKG to EXTRACT_EXECUTE;
grant execute on CTEXT.EXTRACT_PKG to EXTRACT_ADMIN;

grant execute on CTEXT.EXT_DATA_PKG to EXTRACT_EXECUTE;
grant execute on CTEXT.EXT_DATA_PKG to EXTRACT_ADMIN;

grant execute on CTEXT.EXT_MISC_PKG to EXTRACT_EXECUTE;
grant execute on CTEXT.EXT_MISC_PKG to EXTRACT_ADMIN;

grant execute on CTEXT.EXT_UTIL_PKG to EXTRACT_EXECUTE;
grant execute on CTEXT.EXT_UTIL_PKG to EXTRACT_ADMIN;

create public synonym CT_APP_META_DATA     for CTEXT.CT_APP_META_DATA;
create public synonym CT_DATA_MAP_CTL      for CTEXT.CT_DATA_MAP_CTL;
create public synonym CT_EXT_ACCOUNTS      for CTEXT.CT_EXT_ACCOUNTS;
create public synonym CT_EXT_CRS_CTL       for CTEXT.CT_EXT_CRS_CTL;
create public synonym CT_EXT_DATA          for CTEXT.CT_EXT_DATA;
create public synonym CT_EXT_ERRORS        for CTEXT.CT_EXT_ERRORS;
create public synonym CT_EXT_FILE_CTL      for CTEXT.CT_EXT_FILE_CTL;
create public synonym CT_EXT_LOGS          for CTEXT.CT_EXT_LOGS;
create public synonym CT_EXT_OC_OBJ_CTL    for CTEXT.CT_EXT_OC_OBJ_CTL;
create public synonym CT_EXT_STUDY_CTL     for CTEXT.CT_EXT_STUDY_CTL;
create public synonym CT_EXT_STUDY_RPT_CTL for CTEXT.CT_EXT_STUDY_RPT_CTL;
create public synonym CT_EXT_TEMP          for CTEXT.CT_EXT_TEMP;
create public synonym CT_EXT_VW_CTL        for CTEXT.CT_EXT_VW_CTL;
create public synonym CT_REC_TYPE          for CTEXT.CT_REC_TYPE;
create public synonym EXTRACT_PKG          for CTEXT.EXTRACT_PKG;
create public synonym EXT_DATA_PKG         for CTEXT.EXT_DATA_PKG;
create public synonym EXT_MISC_PKG         for CTEXT.EXT_MISC_PKG;
create public synonym EXT_UTIL_PKG         for CTEXT.EXT_UTIL_PKG;

