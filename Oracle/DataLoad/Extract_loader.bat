REM Author: Patrick Conrad - Ekagra Software Technologies
REM   Date: 05/14/2004
REM Detail: The batch file is used to load data from Extract TAP files into the
REM         staging table CTEXT300.CT_EXT_DATA_LOAD.  This batch files is set so
REM         the following "for" command can be given to loop through found tap files:
REM         for /r %1 in (*.tap) do c:\extract_utils\extract_loader "%1" userid/password
REM 
sqlldr userid=%2 control=c:\extract_utils\extract_loader.ctl log='%~dpn1' bad='%~dpn1' data='%1' discard='%~dpn1'
