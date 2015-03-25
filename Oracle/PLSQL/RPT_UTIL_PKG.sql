PROMPT Creating Package 'RPT_UTIL_PKG'
CREATE OR REPLACE PACKAGE RPT_UTIL_PKG

  IS

-- Sub-Program Unit Declarations
  TYPE CT_CURTYPE IS REF CURSOR;

FUNCTION F_GET_CDUS_DESC ( P_TABLE_NAME          IN VARCHAR2 
                          ,P_COLUMN_NAME         IN VARCHAR2 
                          ,P_VERSION             IN VARCHAR2 
                          ,P_VALUE               IN VARCHAR2) 
RETURN VARCHAR2;

END;
/
SHOW ERROR

PROMPT Creating Package Body 'RPT_UTIL_PKG'

CREATE OR REPLACE PACKAGE BODY RPT_UTIL_PKG 
  /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
  /*     Author: Patrick Conrad- Ekagra Software Technologies                          */
  /*       Date: 06/14/04                                                              */
  /*Description: This Package was created to contain functions and procedures that     */
  /*             relate to reporting, either via SQL*Plus or Discoverer, etc.          */ 
  /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
  /*  Modification History                                                             */
  /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
  /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
  IS

-- PL/SQL Private Declaration

-- PRC - 06/14/04 : Cursor added per SL
CURSOR GC_CDUS_DESC(
           P_TABLE_NAME          IN VARCHAR2 
          ,P_COLUMN_NAME         IN VARCHAR2 
          ,P_VERSION             IN VARCHAR2 
          ,P_VALUE               IN VARCHAR2 ) IS
    SELECT DESCRIPTION
      from CDUS_LOV_DESCRIPTIONS
     where TABLE_NAME = P_TABLE_NAME
       AND COLUMN_NAME = P_COLUMN_NAME
       AND VER_REL = P_VERSION
       AND LIST_OF_VALUES = P_VALUE
       AND ROWNUM = 1;

-- Program Data
G_FATAL_ERR EXCEPTION;

-- Sub-Program Units

/* 
PRC - 06/14/04 : Added Function F_GET_CDUS_DESC as requested by SL
*/
FUNCTION F_GET_CDUS_DESC (
  P_TABLE_NAME          IN VARCHAR2 
 ,P_COLUMN_NAME         IN VARCHAR2 
 ,P_VERSION             IN VARCHAR2 
 ,P_VALUE               IN VARCHAR2 
 ) RETURN VARCHAR2  
 IS

  T_DESC   VARCHAR2(240);

BEGIN

  OPEN GC_CDUS_DESC(P_TABLE_NAME, P_COLUMN_NAME, P_VERSION, P_VALUE);
  FETCH GC_CDUS_DESC INTO T_DESC;
  IF GC_CDUS_DESC%NOTFOUND THEN
    T_DESC := NULL;    -- Not exist
  END IF;

  CLOSE GC_CDUS_DESC;

  RETURN (T_DESC);

exception
  WHEN OTHERS THEN
    IF GC_CDUS_DESC%ISOPEN THEN
      CLOSE GC_CDUS_DESC;
    END IF;
    RAISE;

END;

BEGIN
  NULL;
END RPT_UTIL_PKG;
/
SHOW ERROR
