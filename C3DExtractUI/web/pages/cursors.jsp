<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>C3D Data Extract - Cursor Manipulator</title>
<link rel="stylesheet" type="text/css" href="styleSheet.css" />
<script src="script.js" type="text/javascript"></script>

<script type="text/javascript" src="prototype.js"></script>
<script type="text/javascript">


var selectedStudy;
var selectedReportTo;
var selectedVersion;
var cursorRecords;
var curRec = 0;
var lastRec = -1;
var noteShown = false;
var openTrans = false;
var reload = true;
var inboundStudy    = '<s:property value="study" />';
var inboundReportTo = '<s:property value="reportTo" />';
var inboundVersion  = '<s:property value="version" />';
var inboundCurRec   = '<s:property value="cRec" />';

function AutoStart() {
  if (( inboundStudy == null) || ( inboundStudy == "") || 
      ( inboundReportTo == null) || ( inboundReportTo == "") || 
      ( inboundVersion == null) || ( inboundVersion == "") || 
      ( inboundCurRec == null) || ( inboundCurRec == "") ) {
      reload = false;
      }
      
  getStudyIds();
}

function setStatus(msg){
  document.getElementById("statusText").innerHTML=msg;
}

function clearStatus(){
  document.getElementById("statusText").innerHTML="&nbsp";
}

<s:url id="queryExtractStudyIds" namespace="/" action="/getExtractStudies"/>

function getStudyIds(){
  var url = '${queryExtractStudyIds}';
  var myAjax = new Ajax.Request(url, {
               method: 'get',
               onComplete: populateStudyLOV,
               parameters: ''});
}

function populateStudyLOV(originalRequest){
  //setStatus("Starting LOV Populate for Study");
  var result = originalRequest.responseText.evalJSON();
  
  availableStudyIds=result.studies;
  var select=document.getElementById("studyId");
  select.options.length=0;
  select.disabled=false;
  select.options[0]=new Option("Pick Study...", "Pick Study...");
  
  for (var i=0;i<result.studies.length;i++){
    select.options[i+1]=new Option(result.studies[i], result.studies[i]);
  }
  if (reload) {
     for(var i = 0, j = select.options.length; i < j; ++i) { 
          if(select.options[i].innerHTML === inboundStudy) { 
             select.selectedIndex = i; 
             break; 
          } 
      } 
     getReportTos(select);    
  }
  
}

<s:url id="queryExtractStudyReportTos" namespace="/" action="/getExtractStudyReportTos"/>

function getReportTos(selectObject){
  var url = '${queryExtractStudyReportTos}';
  if (selectedStudy != selectObject.options[selectObject.selectedIndex].value) {
    selectedStudy = selectObject.options[selectObject.selectedIndex].value;
    selectedReportTo = null;
    selectedVersion = null;
    curRec = 0;
    displayClean();
    var select=document.getElementById("reportTo"); 
    select.options.length=0;
    select.disabled=true;
  }
  
  if (selectedStudy != "Pick Study...") {
    var select=document.getElementById("version"); 
    select.options.length=0;
    select.disabled=true;
    selectedStudy = selectObject.options[selectObject.selectedIndex].value;
    var myAjax = new Ajax.Request(url, {
                 method: 'get',
                 onComplete: populateReportToLOV,
                 parameters: 'study='+selectedStudy});
  }
}

function populateReportToLOV(originalRequest){
  var result = originalRequest.responseText.evalJSON();
  
  var reportTos=result.reportTos;
  var select=document.getElementById("reportTo");
  select.options.length=0;
  select.disabled=false;
  select.options[0]=new Option("ReportTo...", "ReportTo...");
  for (var i=0;i<result.reportTos.length;i++){
    select.options[i+1]=new Option(result.reportTos[i], result.reportTos[i]);
  }
  if (reload) {
     for(var i = 0, j = select.options.length; i < j; ++i) { 
          if(select.options[i].innerHTML === inboundReportTo) { 
             select.selectedIndex = i; 
             break; 
          } 
      } 
     getVersions(select);    
  }
}

<s:url id="queryExtractStudyReportToVersions" namespace="/" action="/getExtractStudyReportToVersions"/>

function getVersions(selectObject){
  var url = '${queryExtractStudyReportToVersions}';
  if (selectedReportTo != selectObject.options[selectObject.selectedIndex].value) {
    selectedReportTo = selectObject.options[selectObject.selectedIndex].value;
    selectedVersion = null;
    var select=document.getElementById("version"); 
    select.options.length=0;
    select.disabled=true;
    displayClean();
  }
  selectedReportTo = selectObject.options[selectObject.selectedIndex].value  
  displayClean();

  if ((selectedStudy != "Pick Study...") && (selectedReportTo != "ReportTo..."))  {
    var myAjax = new Ajax.Request(url, {
                 method: 'get',
                 onComplete: populateVersionLOV,
                 parameters: 'study='+selectedStudy+'&reportTo='+selectedReportTo});
  }
}

function populateVersionLOV(originalRequest){
  var result = originalRequest.responseText.evalJSON();
  
  var select=document.getElementById("version");
  select.options.length=0;
  select.disabled=false;
  select.options[0]=new Option("Version...", "Version...");
  for (var i=0;i<result.versions.length;i++){
    select.options[i+1]=new Option(result.versions[i], result.versions[i]);
  }
  if (reload) {
     for(var i = 0, j = select.options.length; i < j; ++i) { 
          if(select.options[i].innerHTML === inboundVersion) { 
             select.selectedIndex = i; 
             break; 
          } 
      } 
     getCursors(select);    
  }
  
}

<s:url id="getCursors" namespace="/" action="/getCursors"/>

function getCursors(selectObject){
  selectedVersion = selectObject.options[selectObject.selectedIndex].value  
  displayClean();

  if ((selectedStudy != "Pick Study...") && (selectedReportTo != "ReportTo...") &&  
      (selectedVersion != "Version..."))  {
    setCursor("wait");
    setStatus("<b>Query executing, please wait...</b>");
    var url = '${getCursors}';
    var myAjax = new Ajax.Request(url, {
                   method: 'get',
                   onComplete: populateCursorTable,
                   parameters: 'study='+selectedStudy+'&reportTo='+selectedReportTo+'&version='+
                               selectedVersion+'&'+Math.random()});
  } else {
    setStatus("You must select a valid Study, ReportTo and Version.");
  }
}

function trim(stringToTrim) {
	return stringToTrim.replace(/^\s+|\s+$/g,"");
}

<s:url id="getCursorJournal" namespace="/" action="/cursorJournal"/>     

function populateCursorTable(originalRequest){
  var results = originalRequest.responseText.evalJSON();
  cursorRecords=results.ctExtCrsCtls;
  setCursor("default");
  clearStatus();
  
  lastRec = cursorRecords.length-1;
  if (curRec >= lastRec) {
    curRec = lastRec;
  }
  clearStatus();
  
  if (reload) {
     curRec = parseInt(inboundCurRec);
     var url = '${getCursorJournal}';
     var myAjax = new Ajax.Request(url, {
                        method: 'get',
                        onComplete: afterClearJournal,
                        parameters: "study=null&reportTo=null&version=null"+
                                    "&cRec=0&"+Math.random()});
     reload = false;
  }
  
  displayCursorRecord(curRec);   // Study Record Display  
}

function afterClearJournal() {
  reload = false;
  displayCursorRecord(curRec);   // Study Record Display  
  setCursor("default");
}

function setCursor(cStatus){
	document.body.style.cursor=cStatus;
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
  if (value == "null") {
    field.value="";
  } else {
    field.value=value;
  }
         
  if (type == "view") {
    field.readOnly=true;
    field.style.backgroundColor="transparent";
  }
  if (type == "edit") {
    field.readOnly=false;
    field.style.backgroundColor="White";
    field.style.textTransform="none";
  }
  if (type == "editUC") {
    field.readOnly=false;
    field.style.backgroundColor="White";
    field.style.textTransform="uppercase";
  }
}

function displayClean(){

  setFieldDisplayType("view", document.getElementById("fileId"), "");
		      	
  setFieldDisplayType("view", document.getElementById("cursorName"), "");

  setFieldDisplayType("view", document.getElementById("modDate"), "");
   
  //Second Row
  setFieldDisplayType("view", document.getElementById("cursorType"), "");

  setFieldDisplayType("view", document.getElementById("extSeq"), "");
                        
  setFieldDisplayType("view", document.getElementById("extSrc"), "");

  setFieldDisplayType("view", document.getElementById("modUser"), "");

  //Cursor text
  setFieldDisplayType("view", document.getElementById("cursorText"), "");

  var field = document.getElementById("action1");
  field.innerHTML='<a href="#" onclick="setCursorActions(\'edit\')">Edit</a>';
  var field = document.getElementById("action2");
  field.innerHTML='<a href="#" onclick="setCursorActions(\'delete\')">Delete</a>';

  var field = document.getElementById("recOfRecs");
  field.innerHTML= '0 / 0';

  setFieldDisplayType("view", document.getElementById("Note"), "");
  hideNote();

  var field = document.getElementById("noteButton");
  field.disabled=false;

}

function displayCursorRecord(rec){

  setFieldDisplayType("view", document.getElementById("fileId"), cursorRecords[rec].fileId);
		      	
  setFieldDisplayType("view", document.getElementById("cursorName"), cursorRecords[rec].crsName);

  setFieldDisplayType("view", document.getElementById("modDate"), cursorRecords[rec].modifiedDate);
   
  //Second Row
  setFieldDisplayType("view", document.getElementById("cursorType"), cursorRecords[rec].crsType);

  setFieldDisplayType("view", document.getElementById("extSeq"), cursorRecords[rec].extSeq);
                        
  setFieldDisplayType("view", document.getElementById("extSrc"), cursorRecords[rec].extSource);

  setFieldDisplayType("view", document.getElementById("modUser"), cursorRecords[rec].modifiedBy);

  //Cursor text
  setFieldDisplayType("view", document.getElementById("cursorText"), cursorRecords[rec].text);

  var field = document.getElementById("action1");
  field.innerHTML='<a href="#" onclick="setCursorActions(\'edit\')">Edit</a>';
  var field = document.getElementById("action2");
  field.innerHTML='<a href="#" onclick="setCursorActions(\'delete\')">Delete</a>';

  var field = document.getElementById("recOfRecs");
  field.innerHTML= (curRec+1) + ' / ' + (lastRec+1)

  setFieldDisplayType("view", document.getElementById("Note"), cursorRecords[rec].note);
  if (noteShown) {
    showNote();
  }else{
    hideNote();
  }
  
  <s:url id="cursorJournalURL" namespace="/" action="goCursorJournalPage"/>

  var field = document.getElementById("journalAction");
  if (cursorRecords[rec].hasJournal) {
    field.setAttribute("href",'${cursorJournalURL}?study=' + selectedStudy + '&reportTo='+selectedReportTo+
                      '&version='+selectedVersion+'&fileId='+document.getElementById("fileId").value+
                      '&crsName='+document.getElementById("cursorName").value+'&cRec='+curRec);
    //field.text="Show Journal";
    field.innerHTML="Show Journal";
  }else{
    field.setAttribute("href",'#');
    //field.text="";
    field.innerHTML="";

  }

  var field = document.getElementById("noteButton");
  field.disabled=false;
}

function setCursorActions(action){

  if ((selectedStudy == null) || 
     (selectedReportTo == null) || 
     (selectedVersion == null)) {
    setStatus('<b>WARNING:</b> You must select a Study, Report To and Version first.');
  }else{
    if (action == "delete") {
      setStatus('Select "Confirm" to Confirm Deletion of ' + selectedStudy + ' Study Cursor Record; select "Cancel" to Cancel Delete.');

      var field = document.getElementById("action1");
      field.innerHTML='<a href="#" onclick="delCursor(curRec)">Confirm</a>';
      var field = document.getElementById("action2");
      field.innerHTML='<a href="#" onclick="setCursorActions(\'normal\')">Cancel</a>';
      
      openTrans = true;
    } 
    if (action == "normal") {
        clearStatus();
  
        openTrans = false;
    
        displayCursorRecord(curRec);

        var field = document.getElementById("action1");
        field.innerHTML='<a href="#" onclick="setCursorActions(\'edit\')">Edit</a>';
        var field = document.getElementById("action2");
        field.innerHTML='<a href="#" onclick="setCursorActions(\'delete\')">Delete</a>';

    }   
    if (action == "edit") {
      setStatus('Select "Save" to Commit changes for ' + selectedStudy + ' Study Cursor Control Record, "Cancel" to Cancel Edit.');

      //First Row
      setFieldDisplayType("editUC", document.getElementById("fileId"), cursorRecords[curRec].fileId);

      setFieldDisplayType("editUC", document.getElementById("cursorName"), cursorRecords[curRec].crsName);

      //setFieldDisplayType("edit", document.getElementById("modDate"), cursorRecords[curRec].fileId);
  
      //Second Row
      setFieldDisplayType("editUC", document.getElementById("cursorType"), cursorRecords[curRec].crsType);

      setFieldDisplayType("edit", document.getElementById("extSeq"), cursorRecords[curRec].extSeq);
                        
      setFieldDisplayType("editUC", document.getElementById("extSrc"), cursorRecords[curRec].extSource);

      //setFieldDisplayType("edit", document.getElementById("modUser"), cursorRecords[curRec].fileId);

      setFieldDisplayType("edit", document.getElementById("cursorText"), cursorRecords[curRec].text);
      document.getElementById("cursorText").rows="17";

      var field = document.getElementById("action1");
      field.innerHTML='<a href="#" onclick="updCursor()">Save</a>';
      var field = document.getElementById("action2");
      field.innerHTML='<a href="#" onclick="setCursorActions(\'normal\')">Cancel</a>';

      setFieldDisplayType("edit", document.getElementById("Note"), cursorRecords[curRec].note);
      showNote();
      
      document.getElementById("fileId").focus();  

      openTrans = true;

    }
  }
}

function showNote() {
    var field = document.getElementById("cursorText");
    field.rows="17";
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
    field.rows="19";
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

function delCursor(){
  <s:url id="delCursor" namespace="/" action="/delCursor"/>

  var delFileId =cursorRecords[curRec].fileId;
  var delcrsName=cursorRecords[curRec].crsName;
  
  var url = '${delCursor}';
  var myAjax = new Ajax.Request(url, {
                   method: 'post',
                   onComplete: afterDelCursor,
                   parameters: 'study='+selectedStudy+
                               '&reportTo='+selectedReportTo+'&version='+selectedVersion+
                               '&fileId='+delFileId+'&crsName='+delcrsName+'&'+Math.random()});
}

function afterDelCursor(){
  openTrans = false;

  getCursors(document.getElementById("version"));  
}

function updCursor(){
  <s:url id="updCursor" namespace="/" action="/updCursor"/>

  var edtfileId = document.getElementById("fileId").value;
  var edtcursorName = document.getElementById("cursorName").value;
  var edtcursorType = document.getElementById("cursorType").value;
  var edtextSeq = document.getElementById("extSeq").value;
  var edtextSrc = document.getElementById("extSrc").value;
  //Must encode because the SQL Text could contain ("%","+", "&")
  var edtcursorText = encodeURIComponent(document.getElementById("cursorText").value);
  var edtNote = encodeURIComponent(document.getElementById("Note").value);
  
  var url = '${updCursor}';
  var myAjax = new Ajax.Request(url, {
                   method: 'post',
                   onComplete: afterUpdCursor,
                   parameters: 'keyStudy='+selectedStudy+'&keyReportTo='+selectedReportTo+
                               '&keyVersion='+selectedVersion+'&keyFileId='+cursorRecords[curRec].fileId+
                               '&keyCrsName='+cursorRecords[curRec].crsName+'&fileId='+edtfileId+
                               '&crsName='+edtcursorName+'&crsType='+edtcursorType+
                               '&extSeq='+edtextSeq+'&text='+edtcursorText+
                               '&extSource='+edtextSrc+'&note='+edtNote+'&'+Math.random()});

}

function afterUpdCursor(){
  openTrans = false;

  getCursors(document.getElementById("version"));  
}


function doRefresh() {
  clearStatus();
}
  
/* v v v v v Suckerfich Menu Controls v v v v v */
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
/* ^ ^ ^ ^ ^ Suckerfich Menu Controls ^ ^ ^ ^ ^ */

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
                  <s:url id="extractPageUrl" namespace="/" action="goExtractPage" />
                  <s:url id="AddStudyUrl" namespace="/" action="goAddStudyPage" />
                  <s:url id="securityUrl" namespace="/" action="goSecurityPage" />
                  <s:url id="refreshViewsUrl" namespace="/" action="goRefreshViewsPage" />
                  <s:url id="controlsUrl" namespace="/" action="goControlsPage" />
                  <s:url id="cursorUrl" namespace="/" action="goCursorsPage" >
                       <s:param name="study"> </s:param>
                  </s:url>
                  <s:url id="viewUrl" namespace="/" action="goViewsPage" >
                       <s:param name="study"> </s:param>
                  </s:url>
	            <ul id="nav">
	              <li><a href="#">Home</a></li>
	              <li><a href="#">Action</a>
	                <ul>
	                  <li><a href="${extractPageUrl}">Data Extraction</a></li>
	                  <li><a href="${AddStudyUrl}">Add New Study</a></li>
	                  <li><a href="${refreshViewsUrl}">Refresh Extract Views</a></li>
	                </ul>
	       	      </li>
	              <li><a href="#">Extract Tools</a>
	                <ul>
	                  <li><a href="${controlsUrl}">Control Tables</a></li>
			  <li><a href="${securityUrl}">Security</a></li>
			  <li><a href="${viewUrl}">Extract Views</a></li>
                          <li><a href="${cursorUrl}">Extract Cursors</a></li>
	                </ul>		                            
	       	      </li>
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
                              <td style="text-align:center; margin-bottom: 9px; color:black; font-size:2em; font-weight:bold">Cursor Manipulator</td>
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
                            <select class="formFieldSizeM"  id="studyId" name="studyId" 
                                    onChange="getReportTos(this)">
                            </select>
			  </td>
                          <td>&nbsp;</td>
			  <td style="border-left:1px solid #5C5C5C;padding-left:2em">
			    <label style="text-align:right" for="reportTo">Report To:</label>
			  </td>
			  <td>
			    <select class="formFieldSizeM" id="reportTo" name="reportTo" disabled="true"
			            onChange="getVersions(this)"></select>
			  </td>
                          <td>&nbsp;</td>
			  <td  style="border-left:1px solid #5C5C5C;padding-left:2em">
			    <label style="text-align:right" for="version">Version:</label>
			  </td>
			  <td>
			    <select class="formFieldSizeM"  id="version" name="version" disabled="true"
			            onChange="getCursors(this)"></select>
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
                      <table class="formSimpleBox" 
                             style="width:700;border:1px solid black; border-bottom-width:0px; border-top-width:0px; table-layout:fixed;" id="cursors" >
                        <tr>
                          <td style="border-spacing: 0; padding: 2px; text-align:center">
                            <textarea  class="dataCell2Text" id="cursorText" 
                                       style="border-spacing: 0; border-style: inset; border-width: 1px; font-size:1.25em; 
                                              width:658; background-color:transparent"
		                       cols="80" rows="19"  readonly="true" id="cursorText">&nbsp</textarea>
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
                             <!--<a onclick="showHideNote()" id="noteAction" >Show/Hide Note</a>-->
                          </td>
                          <td style="border-spacing: 0; padding: 2px; text-align:right">
                             <a href="#" id="journalAction" ></a>
                          </td>
                        </tr>
                        <tr>
                          <td colspan="2" style="border-spacing: 0; padding: 2px; text-align:center">
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
                          <td style="width:40px; text-align:center" id="action1">
                            <a href="#" onclick="displayCursorRecord(lastRec)">Edit</a>
                          </td>
                          <td style="width:40px; text-align:center" id="action2" >
                            <a href="#" onclick="setCursorActions('delete')">Delete</a>
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
