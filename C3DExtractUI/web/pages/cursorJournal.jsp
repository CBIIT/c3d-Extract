<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>C3D Data Extract - Cursor Journal</title>
<link rel="stylesheet" type="text/css" href="styleSheet.css" />
<script src="script.js" type="text/javascript"></script>

<script type="text/javascript" src="prototype.js"></script>
<script type="text/javascript">

var cursorRecords;
var curRec = 0;
var lastRec = -1;
var noteShown = false;
var openTrans = false;

function AutoStart() {
    getCursorJournals();
}

function setStatus(msg){
  document.getElementById("statusText").innerHTML=msg;
}

function clearStatus(){
  document.getElementById("statusText").innerHTML="&nbsp";
}

<s:url id="getCursorJournals" namespace="/" action="cursorJournal"/>
<s:url id="cursorUrl" namespace="/" action="goCursorsPage" />

function getCursorJournals(){
  var selectedStudy    = '<s:property value="study" />';
  var selectedReportTo = '<s:property value="reportTo" />';
  var selectedVersion  = '<s:property value="version" />';
  var selectedFileId  = '<s:property value="fileId" />';
  var selectedCrsName  = '<s:property value="crsName" />';
  var selectedCurRec   = '<s:property value="cRec" />';

  document.getElementById("back2cursors").href = '${cursorUrl}?study=' + selectedStudy + '&reportTo='+selectedReportTo+
                                                '&version='+selectedVersion+'&cRec='+selectedCurRec+'&'+Math.random();

  displayClean();

  if ((selectedStudy != "Pick Study...") && (selectedReportTo != "ReportTo...") &&  
      (selectedVersion != "Version..."))  {
    var url = '${getCursorJournals}';
    var myAjax = new Ajax.Request(url, {
                     method: 'get',
                     onComplete: populateCursorTable,
                     parameters: 'study='+selectedStudy+'&reportTo='+selectedReportTo+'&version='+selectedVersion
                                 +'&fileId='+selectedFileId+'&crsName='+selectedCrsName});
                     
  } 
}

function trim(stringToTrim) {
	return stringToTrim.replace(/^\s+|\s+$/g,"");
}

function populateCursorTable(originalRequest){
  var results = originalRequest.responseText.evalJSON();
  cursorRecords=results.ctExtCrsCtlJNs;
  
  lastRec = cursorRecords.length-1;
  if (curRec >= lastRec) {
    curRec = lastRec;
  }
  clearStatus();
  
  displayCursorRecord(curRec);   // Study Record Display  
}

function recordTransit(transit) {
  clearStatus();
  if (openTrans) {
    setStatus('<b>WARNING</b>: You must complete previous Transaction first!');
  }else{
    if (transit == 'first') {
      displayFirstRecord()
    }
    if (transit == 'last') {
      displayLastRecord()
    }
    if (transit == 'prev') {
      displayBackward()
    }
    if (transit == 'next') {
      displayForward()
    }
  }
}  

function displayFirstRecord(){
  if (curRec <= 0) {
    setStatus('<b>NOTE</b>: At first record.');
  }
  curRec = 0;
  displayCursorRecord(curRec);
}

function displayLastRecord(){
  if (curRec >= lastRec) {
    setStatus('<b>NOTE</b>: At last record.');
  }
  curRec = lastRec;
  displayCursorRecord(curRec);
}

function displayBackward(){
  if (curRec <= 0) {
    setStatus('<b>NOTE</b>: At first record.');
    curRec = 0;
  }else{
    curRec -= 1;
  }
  displayCursorRecord(curRec);
}

function displayForward(){
  if (curRec >= lastRec) {
    setStatus('<b>NOTE</b>: At last record.');
    curRec = lastRec;
  }else{
    curRec += 1;
  }
  displayCursorRecord(curRec);
}

function displayCurrentRecord(){
  if (curRec >= lastRec) {
    curRec = lastRec;
  }
  displayCursorRecord(curRec);
}

function setFieldDisplayType(type, field, value) {
  field.value=value;
  if (type == "view") {
    field.readOnly=true;
    field.style.backgroundColor="transparent";
  }
  if (type == "edit") {
    field.readOnly=false;
    field.style.backgroundColor="White";
  }
}

function displayClean(){

  //Key Row
  setFieldDisplayType("view", document.getElementById("studyId"), "");
		      	
  setFieldDisplayType("view", document.getElementById("reportTo"), "");

  setFieldDisplayType("view", document.getElementById("version"), "");

  //First Row
  setFieldDisplayType("view", document.getElementById("fileId"), "");
		      	
  setFieldDisplayType("view", document.getElementById("cursorName"), "");

  setFieldDisplayType("view", document.getElementById("modDate"), "");
   
  //Second Row
  setFieldDisplayType("view", document.getElementById("cursorType"), "");

  setFieldDisplayType("view", document.getElementById("extSeq"), "");
                        
  setFieldDisplayType("view", document.getElementById("extSrc"), "");

  setFieldDisplayType("view", document.getElementById("modUser"), "");

  //Journal Row
  setFieldDisplayType("view", document.getElementById("jnOperation"), "");

  setFieldDisplayType("view", document.getElementById("jnTimeStamp"), "");
                        
  setFieldDisplayType("view", document.getElementById("jnSn"), "");

  setFieldDisplayType("view", document.getElementById("jnOracleUser"), "");

  //Cursor text
  setFieldDisplayType("view", document.getElementById("cursorText"), "");

  var field = document.getElementById("recOfRecs");
  field.innerHTML= '0 / 0';

  setFieldDisplayType("view", document.getElementById("Note"), "");
  hideNote();

  var field = document.getElementById("noteButton");
  field.disabled=false;
}

function displayCursorRecord(rec){

  //Key Row
  setFieldDisplayType("view", document.getElementById("studyId"), cursorRecords[rec].ocStudy);
		      	
  setFieldDisplayType("view", document.getElementById("reportTo"), cursorRecords[rec].reportTo);

  setFieldDisplayType("view", document.getElementById("version"), cursorRecords[rec].version);

  //First Row
  setFieldDisplayType("view", document.getElementById("fileId"), cursorRecords[rec].fileId);
		      	
  setFieldDisplayType("view", document.getElementById("cursorName"), cursorRecords[rec].crsName);

  setFieldDisplayType("view", document.getElementById("modDate"), cursorRecords[rec].modifiedDate);
   
  //Second Row
  setFieldDisplayType("view", document.getElementById("cursorType"), cursorRecords[rec].crsType);

  setFieldDisplayType("view", document.getElementById("extSeq"), cursorRecords[rec].extSeq);
                        
  setFieldDisplayType("view", document.getElementById("extSrc"), cursorRecords[rec].extSource);

  setFieldDisplayType("view", document.getElementById("modUser"), cursorRecords[rec].modifiedBy);

  //Journal Row
  setFieldDisplayType("view", document.getElementById("jnOperation"), cursorRecords[rec].jnOperation);

  setFieldDisplayType("view", document.getElementById("jnTimeStamp"), cursorRecords[rec].jnTimeStamp);
                        
  setFieldDisplayType("view", document.getElementById("jnSn"), cursorRecords[rec].jnSn);

  setFieldDisplayType("view", document.getElementById("jnOracleUser"), cursorRecords[rec].jnOracleUser);

  //Cursor text
  setFieldDisplayType("view", document.getElementById("cursorText"), cursorRecords[rec].text);

  var field = document.getElementById("recOfRecs");
  field.innerHTML= (curRec+1) + ' / ' + (lastRec+1)

  setFieldDisplayType("view", document.getElementById("Note"), cursorRecords[rec].note);
  if (noteShown) {
    showNote();
  }else{
    hideNote();
  }

  var field = document.getElementById("noteButton");
  field.disabled=false;
}

function showNote() {
    var field = document.getElementById("cursorText");
    field.rows="15";
    var field = document.getElementById("noteButton");
    field.value="Hide Note"
    var field = document.getElementById("Note");
    field.style.position="relative";
    field.cols="80";
    field.rows="2";
    field.style.width=658;
    field.style.fontSize="1.25em";
    field.style.visibility="visible";
}

function hideNote() {
    var field = document.getElementById("cursorText");
    field.rows="17";
    var field = document.getElementById("noteButton");
    field.value="Show Note"
    var field = document.getElementById("Note");
    field.style.width=10;
    field.style.position="absolute";
    field.cols="1";
    field.rows="1";
    field.style.visibility="hidden";
}

function showHideNote(){
  if (noteShown) { //hide it
    hideNote();

  }else{ //show it
    showNote();

    document.getElementById("Note").focus();  
  }
  noteShown = !(noteShown);
}

function doRefresh() {
  clearStatus();
}
  
/* v v v v v Suckerfish Menu Controls v v v v v */
sfHover = function() {
	var sfEls = document.getElementById("nav").getElementsByTagName("LI");
	for (var i=0; i<sfEls.length; i++) {
		sfEls[i].onmouseover=function() {
			this.className+=" sfhover";
		}
		sfEls[i].onmouseout=function() {
			this.className=this.className.replace(new RegExp(" sfhover\\b"), "");
		}
	}
}
if (window.attachEvent) window.attachEvent("onload", sfHover);
/* ^ ^ ^ ^ ^ Suckerfish Menu Controls ^ ^ ^ ^ ^ */

</script>

</head>

<body onLoad="AutoStart()">
<table summary="" cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">

  <tr><!-- nci hdr begins -->
    <td>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="hdrBG">
        <tr>
          <td width="283" height="37" align="left">
            <a href="http://www.cancer.gov">
               <img alt="National Cancer Institute" src="images/logotype.gif"
                width="283" height="37" border="0">
            </a>
          </td>
          <td>&nbsp;</td>
          <td width="295" height="37" align="right">
            <a href="http://www.cancer.gov">
              <img alt="U.S. National Institutes of Health | www.cancer.gov"
               src="images/tagline.gif" width="295" height="37" border="0">
            </a>
          </td>
        </tr>
      </table>
    </td>
  </tr><!-- nci hdr ends -->

  <tr><!-- application hdr begins -->
    <td height="100%" align="center" valign="top">
      <table summary="" cellpadding="0" cellspacing="0" border="0" height="100%" width="771">
        <tr>
	          <td height="45">
	            <table width="100%" height="45" border="0" cellspacing="0"
	             cellpadding="0" class="subhdrBG">
	              <tr>
	                <td><img src="images/AppLogo.jpeg" height="45" width="100%"></td>
	                <!--<td height="100%" width="100%" align="left">
	                  <a href="#">
	                    <img src="images/AppLogo.jpeg" alt="Application Logo"  border="0">
	                  </a>-->
	                </td>
	              </tr>
	            </table>
	          </td>
	        </tr><!-- application hdr ends -->
        
        <tr>
          <td valign="top">
            <table summary="" cellpadding="0" cellspacing="0" border="0" height="100%" width="100%">
              <tr>
                <!-- main menu begins -->
                <td height="20" class="mainMenu">
	          <!--<table summary="" cellpadding="0" cellspacing="0" border="0" height="20">-->
	          <div>
                  <s:url id="logoutUrl" namespace="/" action="logout" />

	            <ul id="nav">
	              <li><a id="back2cursors" href="#">Back to Cursors</a></li>
	              <li><a href="${logoutUrl}">Log Out</a></li>
	            </ul>     
	          </div>
                  <!--</table>-->
                </td><!-- main menu ends -->
              </tr>
              <!--_____ main content begins _____-->
              <tr>
                <td valign="top">
                  <a name="content" /></a><!-- target of anchor to skip menus -->
                  <table summary="" cellpadding="0" cellspacing="0" border="0"
                   class="contentPage" width="100%" height="100%">
                  <tr>
                    <td valign="top" align="center">
                      <table cellpadding="0" cellspacing="0" border="0" class="contentBegins">
                        <tr>
                          <td>
                            <table width="100%" align="center">
			      <td style="text-align:center; margin-bottom: 9px; color:black; font-size:2em; font-weight:bold">Cursor Journal</td>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <!-- Study Selector -->
                      <table class="formSimpleBox" cellpadding="6" cellspacing="0" border="0" 
                             style=" width:700;border:1px solid black;">
		        <tr>
		          <td width=20pt style="text-align:right;" >
			    <label style="text-align:right" for="studyId">Study:</label>
			  </td>
		          <td>
                            <input type="text" class="formFieldSizeM" font-size:1em; background-color:transparent;"
                                   id="studyId" name="studyId" value="&nbsp" readonly="true"/>
			  </td>
                          <td>&nbsp;</td>
			  <td style="border-left:1px solid #5C5C5C;padding-left:2em">
			    <label style="text-align:right" for="reportTo">Report To:</label>
			  </td>
			  <td>
			    <input type="text" class="formFieldSizeM" font-size:1em; background-color:transparent;"
			           id="reportTo" name="reportTo" value="&nbsp" readonly="true"/>
			  </td>
                          <td>&nbsp;</td>
			  <td  style="border-left:1px solid #5C5C5C;padding-left:2em">
			    <label style="text-align:right" for="version">Version:</label>
			  </td>
			  <td>
			    <input type="text" class="formFieldSizeM" font-size:1em; background-color:transparent;"
			           id="version" name="version" value="&nbsp" readonly="true"/>
			  </td>
                        </tr>
                      </table>
                      <table class="formSimpleBox"  
                             style="width:700;border:1px solid black; padding: 2px; border-bottom-width:0px; border-top-width:0px; table-layout:fixed;" id="cursors" >
                        <tr>
                          <td style="width:70px; text-align:right;">File Id:</td>
                          <td style="width:155px;">
		      	    <input type="text" class="formFieldSizeM" style="width:155px; font-size:1em; background-color:transparent;" 
		      	           id="fileId" value="&nbsp" readonly="true"/>
		      	  </td>
		      	
                          <td style="width:75px; text-align:right">Cursor Name:</td>
                          <td style="width:175px;">
                            <input type="text" class="formFieldSizeM" style="width:175px; font-size:1em; background-color:transparent;" 
                                   id="cursorName" value="&nbsp" readonly="true"/>
		      	  </td>
		      	  
                          <td style="width:75px; text-align:right">Mod. Date:</td>
                          <td style="width:100px;">
                            <input type="text" class="formFieldSizeM" style="width:100px; font-size:1em; background-color:transparent;" 
                                   id="modDate" value="&nbsp" readonly="true"/>
		      	  </td>
                        </tr>
                        
		      </table>	
                      <table class="formSimpleBox" 
                             style="width:700;border:1px solid black; padding: 2px; border-bottom-width:0px; border-top-width:0px; table-layout:fixed;" id="cursors" >
                        <tr>
                          <td style="width:70px; text-align:right">Cursor Type:</td>
                          <td style="width:100px">
                            <input type="text" class="formFieldSizeM" style="width:100px; font-size:1em; background-color:transparent;" 
                                   id="cursorType" value="&nbsp" readonly="true"/>
                          </td>

                          <td style="width:130px; text-align:right">Extract Seq:</td>
                          <td style="width:25px">
                            <input type="text" class="formFieldSizeM" style="width:25px; font-size:1em; background-color:transparent;" 
                                   id="extSeq" value="&nbsp" readonly="true"/>
                          </td>
                        
                          <td style="width:119px; text-align:right">Extract Source:</td>
                          <td style="width:25px">
                            <input type="text" class="formFieldSizeM" style="width:25px; font-size:1em; background-color:transparent;" 
                                   id="extSrc" value="&nbsp" readonly="true"/>
                          </td>

                          <td style="width:75px; text-align:right">Mod. User:</td>
                          <td style="width:100px">
                            <input type="text" class="formFieldSizeM" style="width:100px; font-size:1em; background-color:transparent;" 
                                   id="modUser" value="&nbsp" readonly="true"/>
                          </td>
                        </tr>
                      </table>
                      <!-- Journal information -->
                      <table class="formSimpleBox" 
                             style="width:700;border:1px solid black; padding: 2px; border-bottom-width:0px; border-top-width:0px; table-layout:fixed;" id="cursors" >
                        <tr>
                          <td style="width:70px; text-align:right">Journal Type:</td>
                          <td style="width:70px">
                            <input type="text" class="formFieldSizeM" style="width:70px; font-size:1em; background-color:transparent;" 
                                   id="jnOperation" value="&nbsp" readonly="true"/>
                          </td>

                          <td style="width:70px; text-align:right">TimeStamp:</td>
                          <td style="width:115px">
                            <input type="text" class="formFieldSizeM" style="width:115px; font-size:1em; background-color:transparent;" 
                                   id="jnTimeStamp" value="&nbsp" readonly="true"/>
                          </td>
                        
                          <td style="width:50px; text-align:right">Seq#:</td>
                          <td style="width:94px">
                            <input type="text" class="formFieldSizeM" style="width:94px; font-size:1em; background-color:transparent;" 
                                   id="jnSn" value="&nbsp" readonly="true"/>
                          </td>

                          <td style="width:75px; text-align:right">User:</td>
                          <td style="width:100px">
                            <input type="text" class="formFieldSizeM" style="width:100px; font-size:1em; background-color:transparent;" 
                                   id="jnOracleUser" value="&nbsp" readonly="true"/>
                          </td>
                        </tr>
                      </table>
                      <table class="formSimpleBox" 
                             style="width:700;border:1px solid black; border-bottom-width:0px; border-top-width:0px; table-layout:fixed;" id="cursors" >
                        <tr>
                          <td style="border-spacing: 0; padding: 2px; text-align:center">
                            <textarea  class="dataCell2Text" id="cursorText" 
                                       style="border-spacing: 0; border-style: inset; border-width: 1px; font-size:1.25em; 
                                              width:658; background-color:transparent"
		                       cols="80" rows="17"  readonly="true" id="cursorText">&nbsp</textarea>
                          </td>
                        </tr>
                    </table>
                      <table class="formSimpleBox" 
                             style="width:700;border:1px solid black; border-top-width:0px; 
                                    table-layout:fixed;" id="cursors" >
                        <tr>
                          <td style="border-spacing: 0; padding: 2px; text-align:left">
                             <input type="button" class="formFieldSizeM" disabled="true" value="Show Note" 
                                    id="noteButton" onclick="showHideNote()" />
                          </td>
                        </tr>
                        <tr>
                          <td style="border-spacing: 0; padding: 2px; text-align:center">
                            <textarea  class="dataCell2Text" id="Note" 
                                       style="position:absolute; visibility:hidden; border-spacing: 0; border-style: inset; 
                                       border-width: 1px;  background-color:transparent;"
		                       cols="1" rows="1"  readonly="true" >&nbsp</textarea>
                          </td>
                        </tr>
                    </table>
                    <table class="formSimpleBox" cellpadding="6" cellspacing="0"  
                             style=" width:700;border:1px solid black; border-top-width:0px;">
                      <tr>
                        <td style="width:10px; text-align:right">
                          <a href="#" title="First Record" onclick="recordTransit('first')"><<</a>
                        </td>
                        <td style="width:10px; text-align:right">
                          <a href="#" title="Previous Record" onclick="recordTransit('prev')"><</a>
                        </td>
                        <td style="width:10px; text-align:right">
                          <a href="#" title="Next Record" onclick="recordTransit('next')">></a>
                        </td>
                        <td style="width:10px; text-align:right">
                          <a href="#" title="Last Record" onclick="recordTransit('last')">>></a>
                        </td>
                        <td style="width:580px; text-align:center" id="recOfRecs">0 / 0</td>                        
                        <td style="width:80px; text-align:center" >
                        </td>
                      </tr>
                    </table>
	                                
                    <table style="width: 700px;">
                      <tr>
		        <td colspan="5" style="text-align: left;">
		          <span style="font-size:0.7em;padding:0px;text-align:center;padding-left: 6px" id="statusText">&nbsp;</span>
		        </td>	
                      </tr>
                    </table>
                    </td>
                  </tr>
                  </table>
                </td>
              </tr>

          <!--_____ main content ends _____-->

          <tr>
            <td height="20" width="100%" class="footerMenu"><!-- application ftr begins -->
            <table summary="" cellpadding="0" cellspacing="0" border="0"
              width="100%">
              <tr>
                <td align="center" height="20" class="footerMenuItem"
                  onmouseover="changeMenuStyle(this,'footerMenuItemOver'),showCursor()"
                  onmouseout="changeMenuStyle(this,'footerMenuItem'),hideCursor()"
                  onclick="document.location.href='#'">&nbsp;&nbsp;<a
                  class="footerMenuLink" href="#">CONTACT US</a>&nbsp;&nbsp;</td>
                <td><img src="images/ftrMenuSeparator.gif" width="1"
                  height="16" alt="" /></td>
                <td align="center" height="20" class="footerMenuItem"
                  onmouseover="changeMenuStyle(this,'footerMenuItemOver'),showCursor()"
                  onmouseout="changeMenuStyle(this,'footerMenuItem'),hideCursor()"
                  onclick="document.location.href='#'">&nbsp;&nbsp;<a
                  class="footerMenuLink" href="#">PRIVACY NOTICE</a>&nbsp;&nbsp;
                </td>
                <td><img src="images/ftrMenuSeparator.gif" width="1"
                  height="16" alt="" /></td>
                <td align="center" height="20" class="footerMenuItem"
                  onmouseover="changeMenuStyle(this,'footerMenuItemOver'),showCursor()"
                  onmouseout="changeMenuStyle(this,'footerMenuItem'),hideCursor()"
                  onclick="document.location.href='#'">&nbsp;&nbsp;<a
                  class="footerMenuLink" href="#">DISCLAIMER</a>&nbsp;&nbsp;</td>
                <td><img src="images/ftrMenuSeparator.gif" width="1"
                  height="16" alt="" /></td>
                <td align="center" height="20" class="footerMenuItem"
                  onmouseover="changeMenuStyle(this,'footerMenuItemOver'),showCursor()"
                  onmouseout="changeMenuStyle(this,'footerMenuItem'),hideCursor()"
                  onclick="document.location.href='#'">&nbsp;&nbsp;<a
                  class="footerMenuLink" href="#">ACCESSIBILITY</a>&nbsp;&nbsp;</td>
                <td><img src="images/ftrMenuSeparator.gif" width="1"
                  height="16" alt="" /></td>
                <td align="center" height="20" class="footerMenuItem"
                  onmouseover="changeMenuStyle(this,'footerMenuItemOver'),showCursor()"
                  onmouseout="changeMenuStyle(this,'footerMenuItem'),hideCursor()"
                  onclick="document.location.href='#'">&nbsp;&nbsp;<a
                  class="footerMenuLink" href="#">APPLICATION SUPPORT</a>&nbsp;&nbsp;
                </td>
              </tr>
            </table>
            <!-- application ftr ends --></td>
          </tr>
        </table>
        </td>
      </tr>
    </table>
    </td>
  </tr>
  <tr>
    <td><!-- footer begins -->
    <table width="100%" border="0" cellspacing="0" cellpadding="0"
      class="ftrTable">
      <tr>
        <td valign="top">
        <div align="center"><a href="http://www.cancer.gov/"><img
          src="images/footer_nci.gif" width="63" height="31"
          alt="National Cancer Institute" border="0"></a> <a
          href="http://www.dhhs.gov/"><img src="images/footer_hhs.gif"
          width="39" height="31"
          alt="Department of Health and Human Services" border="0"></a> <a
          href="http://www.nih.gov/"><img src="images/footer_nih.gif"
          width="46" height="31" alt="National Institutes of Health"
          border="0"></a> <a href="http://www.firstgov.gov/"><img
          src="images/footer_firstgov.gif" width="91" height="31"
          alt="FirstGov.gov" border="0"></a></div>
        </td>
      </tr>
    </table>
    <!-- footer ends --></td>
  </tr>
</table>

</body>
</html>
