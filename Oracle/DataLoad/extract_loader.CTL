-- Author: Patrick Conrad - Ekagra Software Technologies
--   Date: 05/14/2004
-- Detail: This SQL*Loader file is used to load data from Extract TAP files into the
--         staging table CTEXT300.CT_EXT_DATA_LOAD.  It was designed in conjunction with
--         the batch file extract_loader.bat so that the following "for" command can be 
--         given to loop through found tap files:
--         for /r %1 in (*.tap) do c:\extract_utils\extract_loader "%1" userid/password
-- 

LOAD DATA

APPEND PRESERVE BLANKS
INTO TABLE CTEXT300.CT_EXT_DATA_LOAD
--FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
(

  LINE_TEXT   char(2600) 

)
