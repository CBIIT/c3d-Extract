/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* Author: Patrick Conrad (Ekagra Software Technologies)                 */
/* Date:   June 29, 2006                                                 */
/* Description: This is a basic script used to install object            */
/*              enhancements for the C3D Data Extract Utility.  It is a  */
/*              template.                                                */
/*              The first few lines are there to docuemtn the execution  */
/*              Place individual object scripts between the "BEGIN" and  */
/*              "END" markers.                                           */

Set Timing off verify off

-- Spool a log file
spool DATA_EXTRACT_UPGRADE.LST

Select to_char(sysdate,'MM/DD/YYYY HH24:MI:SS') "Execution Date", User "User"
  from dual;
  
PROMPT
PROMPT BEGINNING!
PROMPT

-- BEGIN ENHANCEMENT SCRIPTS

-- END   ENHANCEMENT SCRIPTS

PROMPT
PROMPT FINISHED!
PROMPT

Spool off
