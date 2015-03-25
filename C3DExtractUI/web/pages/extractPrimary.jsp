<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>C3D Data Extract - Data Extract Processing</title>
<link rel="stylesheet" type="text/css" href="styleSheet.css" />
<script src="script.js" type="text/javascript"></script>

<script type="text/javascript" src="prototype.js"></script>
<script type="text/javascript">

var doRefresh=false;
var downloadFiles;
var studyId = '<s:property value="studyId" />';
function setStatus(msg){
  document.getElementById("finalStatus").innerHTML=msg;
}

function AutoStart() {
    getStudyIds();
    resetStatusTable();
    resetErrorTable();
}

<s:url id="queryExtractStudyIds" namespace="/" action="/getExtractStudies"/>

function getStudyIds(){
  var url = '${queryExtractStudyIds}';
  var myAjax = new Ajax.Request(url, {
               method: 'get',
               onComplete: populateStudyLOV,
               parameters: '&'+Math.random()});
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
}

<s:url id="queryExtractStudyReportTos" namespace="/" action="/getExtractStudyReportTos"/>

function getReportTos(selSelectObject){
  var url = '${queryExtractStudyReportTos}';
  resetControls();
  if (selSelectObject.options[selSelectObject.selectedIndex].value != "") {
    var select=document.getElementById("version"); 
    select.options.length=0;
    select.disabled=true;
    var studyId = selSelectObject.options[selSelectObject.selectedIndex].value;
    var myAjax = new Ajax.Request(url, {
                 method: 'get',
                 onComplete: populateReportToLOV,
                 parameters: 'study='+studyId+'&'+Math.random()});
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
}

<s:url id="queryExtractStudyReportToVersions" namespace="/" action="/getExtractStudyReportToVersions"/>

function getVersions(selObject){
  var url = '${queryExtractStudyReportToVersions}';
  resetControls();
  var selStudy    =document.getElementById("studyId");
  var selReportTo =document.getElementById("reportTo");

  if ((selStudy.options[selStudy.selectedIndex].value != "") &&
      (selReportTo.options[selReportTo.selectedIndex].value != ""))  {
    var studyId = selStudy.options[selStudy.selectedIndex].value;
    var reportTo= selReportTo.options[selReportTo.selectedIndex].value;
    var myAjax = new Ajax.Request(url, {
                 method: 'get',
                 onComplete: populateVersionLOV,
                 parameters: 'study='+studyId+'&reportTo='+reportTo+'&'+Math.random()});
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
}
<s:url id="queryExtractDates" namespace="/" action="/getExtractDates"/>
<s:url id="queryExtractStatus" namespace="/" action="/getExtractStatus"/>
<s:url id="queryExtractErrors" namespace="/" action="/getExtractErrors"/>
<s:url id="queryAllStatuses" namespace="/" action="/getAllStatuses"/>

function getExtractDates(){
  var url = '${queryExtractDates}';
  var selStudy    = document.getElementById("studyId");
  var selReportTo = document.getElementById("reportTo");
  var selVersion  = document.getElementById("version");
  if ((selStudy.options[selStudy.selectedIndex].value       != "Pick Study...") &&
      (selReportTo.options[selReportTo.selectedIndex].value != "ReportTo...") &&
      (selVersion.options[selVersion.selectedIndex].value   != "Version..."))  {
    var studyId = selStudy.options[selStudy.selectedIndex].value;
    var reportTo= selReportTo.options[selReportTo.selectedIndex].value;
    var version = selVersion.options[selVersion.selectedIndex].value;
    var myAjax = new Ajax.Request(url, {
                 method: 'get',
                 onComplete: populateExtractDates,
                 parameters: 'study='+studyId+'&reportTo='+reportTo+'&version='+version+'&'+Math.random()});
  
    var url2 = '${queryExtractStatus}';
    var myAjax = new Ajax.Request(url2, {
                 method: 'get',
                 onComplete: populateExtractStatus,
                 parameters: 'study='+studyId+'&'+Math.random()});
  
    var url3 = '${queryExtractErrors}';
    var myAjax = new Ajax.Request(url3, {
                 method: 'get',
                 onComplete: populateExtractErrors,
                 parameters: 'study='+studyId+'&'+Math.random()});
                 
    var url3 = '${queryAllStatuses}';
    var myAjax = new Ajax.Request(url3, {
                 method: 'get',
                 onComplete: populateAllStatuses,
                 parameters: 'study='+studyId+'&'+Math.random()});
   
  turnOnButtons(); 
  }
}

function populateAllStatuses(originalRequest){
  var result = originalRequest.responseText.evalJSON();

  document.getElementById("extractStatus").innerHTML = result.runStatusText;
  document.getElementById("overallExtStatId").innerHTML = result.logStatusText;
  document.getElementById("overallErrStatId").innerHTML = result.errorStatusText;  
}

function populateExtractDates(originalRequest){
  var result = originalRequest.responseText.evalJSON();

  document.getElementById("lastExtDate").value = result.lastExtractDate;
  document.getElementById("currExtDate").value = result.currExtractDate;
  document.getElementById("lastGenDate").value = result.lastGenDate;

  if (result.lastExtractDate == result.currExtractDate) {
    document.getElementById("confirmOverwriteId").disabled=false;
  }
  
  document.getElementById("createOptId").disabled=false;
  document.getElementById("createExtractId").disabled=false;
  
  var selReportTo = document.getElementById("reportTo");
  if  (selReportTo.options[selReportTo.selectedIndex].value == "CDUS") {
    document.getElementById("CDUSOptId").disabled=false;
  } else {
    document.getElementById("CDUSOptId").disabled=true;
  }
  
}

<s:url id="extractStatusPage" namespace="/" action="/getExtractStatusPage"/>

function populateExtractStatus(originalRequest){
  var results = originalRequest.responseText.evalJSON();
  var extractStatusRecords=results.extractStatusRecords;

  var dataTable1=document.getElementById("extractStatusTbl");
  while (dataTable1.rows.length>0) //deletes all rows of a table
    dataTable1.deleteRow(0);

  var flag=true;
  for (var i=0;i<results.extractStatusRecords.length;i++){
    var newRow=dataTable1.insertRow(-1); //add new row to end of table
    if(flag){
      newRow.className="dataRowLight";
    }else{
      newRow.className="dataRowDarker";
    }
    flag=!flag;

    var newCell=newRow.insertCell(0); //insert new cell to row
    newCell.innerHTML='<a href="${extractStatusPage}?study=' + extractStatusRecords[i].study + 
                      '&logId='+ extractStatusRecords[i].logId + '">' + 
                       extractStatusRecords[i].fileId + '</a>';
    newCell.className="dataCell2Text";
    newCell.style.width="56px";
    newCell.style.fontSize="0.7em";
    newCell.style.fontSize="0.7em";
    newCell.style.overflow="hidden";
    newCell.style.textOverflow="''";

    var newCell=newRow.insertCell(1); //insert new cell to row
    newCell.innerHTML=extractStatusRecords[i].procName;
    newCell.className="dataCell2Text";
    newCell.style.width="110px";
    newCell.style.overflow="hidden";
    newCell.style.textOverflow="''";
    
    var newCell=newRow.insertCell(2); //insert new cell to row
    newCell.innerHTML=extractStatusRecords[i].extStatus;
    newCell.className="dataCell2Text";
    newCell.style.width="56px";
    newCell.style.fontSize="0.7em";
    newCell.style.overflow="hidden";
    newCell.style.textOverflow="''";

    var newCell=newRow.insertCell(3); //insert new cell to row
    newCell.innerHTML=extractStatusRecords[i].startDate;
    newCell.className="dataCell2Text";
    newCell.style.width="110px";
    newCell.style.fontSize="0.7em";
    newCell.style.overflow="hidden";
    newCell.style.textOverflow="''";
  }
  if (results.extractStatusRecords.length<8) {
    for (var i=results.extractStatusRecords.length;i<8;i++){
      var newRow=dataTable1.insertRow(-1); //add new row to end of table
      if(flag){
        newRow.className="dataRowLight";
      }else{
        newRow.className="dataRowDarker";
      }
      flag=!flag;
  
      var newCell=newRow.insertCell(0); //insert new cell to row
      newCell.innerHTML="&nbsp";
      newCell.className="dataCell2Text";
      newCell.style.width="56px";
      newCell.style.fontSize="0.7em";

      var newCell=newRow.insertCell(1);
      newCell.innerHTML="&nbsp";
      newCell.className="dataCell2Text";
      newCell.style.width="110px";
      newCell.style.fontSize="0.7em";
    
      var newCell=newRow.insertCell(2); //insert new cell to row
      newCell.innerHTML="&nbsp";
      newCell.className="dataCell2Text";
      newCell.style.width="56px";
      newCell.style.fontSize="0.7em";

      var newCell=newRow.insertCell(3); //insert new cell to row
      newCell.innerHTML="&nbsp";
      newCell.className="dataCell2Text";
      newCell.style.width="110px";
      newCell.style.fontSize="0.7em";
    }
  }
  
  
}
<s:url id="extractErrorPage" namespace="/" action="/getExtractErrorPage"/>

function populateExtractErrors(originalRequest){
  var results = originalRequest.responseText.evalJSON();
  if (results.extractErrorRecords.length==0) {
     resetErrorTable();
  } else {
  
    var extractErrorRecords=results.extractErrorRecords;

    var dataTable1=document.getElementById("extractErrorTbl");
    while (dataTable1.rows.length>0) //deletes all rows of a table
      dataTable1.deleteRow(0);

    var flag=true;
    for (var i=0;i<results.extractErrorRecords.length;i++){
      var newRow=dataTable1.insertRow(-1); //add new row to end of table
      if(flag){
        newRow.className="dataRowLight";
      }else{
        newRow.className="dataRowDarker";
      }
      flag=!flag;

      var newCell=newRow.insertCell(0); //insert new cell to row
      newCell.innerHTML='<a href="${extractErrorPage}?study=' + extractErrorRecords[i].study + 
                        '&logId='+ extractErrorRecords[i].errId + '">' + 
                         extractErrorRecords[i].fileId + '</a>';
      newCell.className="dataCell2Text";
      newCell.style.width="114px";
      newCell.style.fontSize="0.7em";
      newCell.style.overflow="hidden";
      newCell.style.textOverflow="''";

      var newCell=newRow.insertCell(1); //insert new cell to row
      newCell.innerHTML=extractErrorRecords[i].ctErrorDesc;
      newCell.className="dataCell2Text";
      newCell.style.width="218px";
      newCell.style.fontSize="0.7em";
      newCell.style.overflow="hidden";
      newCell.style.textOverflow="''";    
    }
    if (results.extractErrorRecords.length<8) {
      for (var i=results.extractErrorRecords.length;i<8;i++){
        var newRow=dataTable1.insertRow(-1); //add new row to end of table
        if(flag){
          newRow.className="dataRowLight";
        }else{
          newRow.className="dataRowDarker";
        }
        flag=!flag;
    
        var newCell=newRow.insertCell(0); //insert new cell to row
        newCell.innerHTML="&nbsp";
        newCell.className="dataCell2Text";
        newCell.style.width="114px";
        newCell.style.fontSize="0.7em";
    
        var newCell=newRow.insertCell(1);
        newCell.innerHTML="&nbsp";
        newCell.className="dataCell2Text";
        newCell.style.width="218px";
        newCell.style.fontSize="0.7em"; 
      }
    }
  }
  
}

function turnOnButtons(){
//  document.getElementById("lastExtDate").value = "";
//  document.getElementById("currExtDate").value = "";
//  document.getElementById("createOptId").disabled=true;
//  document.getElementById("CDUSOptId").disabled=true;
//  document.getElementById("createExtractId").disabled=true;
//  document.getElementById("confirmOverwriteId").disabled=true;
//  document.getElementById("extractStatus").innerHTML = "&nbsp";
//  document.getElementById("overallExtStatId").innerHTML = "&nbsp";
//  document.getElementById("overallErrStatId").innerHTML = "&nbsp";  
  document.getElementById("fileOverwriteId").disabled=false;
  document.getElementById("createExtractId").disabled=false;  
  document.getElementById("transferToArchiveId").disabled=false;  
  document.getElementById("createFileId").disabled=false;  
  document.getElementById("removeArchiveId").disabled=false;  
  document.getElementById("refreshScreenId").disabled=false;  
}


function resetControls(){
  document.getElementById("lastExtDate").value = "";
  document.getElementById("currExtDate").value = "";
  document.getElementById("lastGenDate").value = "";  
  document.getElementById("createOptId").disabled=true;
  document.getElementById("CDUSOptId").disabled=true;
  document.getElementById("createExtractId").disabled=true;
  document.getElementById("confirmOverwriteId").disabled=true;
  document.getElementById("extractStatus").innerHTML = "&nbsp";
  document.getElementById("overallExtStatId").innerHTML = "&nbsp";
  document.getElementById("overallErrStatId").innerHTML = "&nbsp";  
  document.getElementById("createExtractId").disabled=true;  
  document.getElementById("transferToArchiveId").disabled=true;  
  document.getElementById("createFileId").disabled=true;
  document.getElementById("downLoadFileId").innerHTML="&nbsp";
  document.getElementById("removeArchiveId").disabled=true;  
  document.getElementById("refreshScreenId").disabled=true;  
  resetStatusTable();
  resetErrorTable();
}

function resetStatusTable(){
  var dataTable1=document.getElementById("extractStatusTbl");
  while (dataTable1.rows.length>0) //deletes all rows of a table
    dataTable1.deleteRow(0);

  var flag=true;
  for (var i=0;i<8;i++){
    var newRow=dataTable1.insertRow(-1); //add new row to end of table
    if(flag){
      newRow.className="dataRowLight";
    }else{
      newRow.className="dataRowDarker";
    }
    flag=!flag;

    var newCell=newRow.insertCell(0); //insert new cell to row
    newCell.innerHTML="&nbsp";
    newCell.className="dataCell2Text";
    newCell.style.width="56px";
    newCell.style.fontSize="0.7em";

    var newCell=newRow.insertCell(1);
    newCell.innerHTML="&nbsp";
    newCell.className="dataCell2Text";
    newCell.style.width="110px";
    newCell.style.fontSize="0.7em";
    
    var newCell=newRow.insertCell(2); //insert new cell to row
    newCell.innerHTML="&nbsp";
    newCell.className="dataCell2Text";
    newCell.style.width="56px";
    newCell.style.fontSize="0.7em";

    var newCell=newRow.insertCell(3); //insert new cell to row
    newCell.innerHTML="&nbsp";
    newCell.className="dataCell2Text";
    newCell.style.width="110px";
    newCell.style.fontSize="0.7em";
  }
}

function resetErrorTable(){
  var dataTable1=document.getElementById("extractErrorTbl");
  while (dataTable1.rows.length>0) //deletes all rows of a table
    dataTable1.deleteRow(0);

  var flag=true;
  for (var i=0;i<8;i++){
    var newRow=dataTable1.insertRow(-1); //add new row to end of table
    if(flag){
      newRow.className="dataRowLight";
    }else{
      newRow.className="dataRowDarker";
    }
    flag=!flag;

    var newCell=newRow.insertCell(0); //insert new cell to row
    newCell.innerHTML="&nbsp";
    newCell.className="dataCell2Text";
    newCell.style.width="114px";
    newCell.style.fontSize="0.7em";

    var newCell=newRow.insertCell(1);
    newCell.innerHTML="&nbsp";
    newCell.className="dataCell2Text";
    newCell.style.width="218px";
    newCell.style.fontSize="0.7em";    
  }
}

<s:url id="createExtract" namespace="/" action="/createExtractAction"/>

function createExtract(){
  var lExtDt = document.getElementById("lastExtDate").value;
  var cExtDt = document.getElementById("currExtDate").value;
  document.getElementById("extractStatus").innerHTML = "&nbsp";
  
  if (((lExtDt !== null) && (cExtDt !== "")) && 
      ((lExtDt == cExtDt) && (document.getElementById("confirmOverwriteId").checked ==false))) {
    document.getElementById("extractStatus").innerHTML = 
    "<b>WARNING:</b> Extract records with date <b>" + lExtDt +"</b> already exist in the archive. Continuing without " +
    "removing these records will only generate update records.  To continue with only updated records, select <b>" +
    "Updates Only</b> before pressing <b> Create Extract </b>.";
    document.getElementById("removeArchiveId").disabled=true;  
  } else {
    var selStudy    = document.getElementById("studyId");
    var selReportTo = document.getElementById("reportTo");
    var selIncOpt   = document.getElementById("studyId");
    var selCDUSType = document.getElementById("reportTo");
    var studyId = selStudy.options[selStudy.selectedIndex].value;
    var reportTo= selReportTo.options[selReportTo.selectedIndex].value;
    var IncOpt  = selIncOpt.options[selIncOpt.selectedIndex].value;
    var CDUSType= selCDUSType.options[selCDUSType.selectedIndex].value;
  
    var url = '${createExtract}';
    var myAjax = new Ajax.Request(url, {
                     method: 'get',
                     onComplete: createExtractResults,
                     parameters: 'study='+studyId+'&reportTo='+reportTo+'&CDUSType='+CDUSType+'&extractMode='+IncOpt+'&'+Math.random()});
   
  }
} 

function createExtractResults(originalRequest) {
  var results = originalRequest.responseText.evalJSON();
  document.getElementById("extractStatus").innerHTML = results.resultStatusText;
}

<s:url id="createFiles" namespace="/" action="/createFilesAction"/>

function createFiles() {
  var lExtDt = document.getElementById("lastExtDate").value;
  var lGenDt = document.getElementById("lastGenDate").value;
  var selStudy    = document.getElementById("studyId");
  var studyId = selStudy.options[selStudy.selectedIndex].value;
  var selReportTo = document.getElementById("reportTo");
  var reportTo= selReportTo.options[selReportTo.selectedIndex].value;
  document.getElementById("extractStatus").innerHTML = "&nbsp";
  
  if (( (lGenDt !== null) && (lGenDt !== ""))
      && (document.getElementById("fileOverwriteId").checked == false)) {
    document.getElementById("extractStatus").innerHTML = 
    "<b>WARNING:</b> The text files with cutoff date <b>" + lExtDt +"</b> have been generated from archive for " + studyId +
    " on " + lGenDt + ". To generate the files again, select <b>OverWrite File</b> before pressing " + 
    "<b>Generate Text Files</b>."
  } else if ((lExtDt == null) || (lExtDt == "")){
    document.getElementById("extractStatus").innerHTML = 
        "<b>WARNING:</b> The extract for " + studyId + " doesn't exist in the archive. ";
        
    } else {
      var url = '${createFiles}';
      document.getElementById("extractStatus").innerHTML = "Generate TAP file...IN PROGRESS.";
      var selVersion = document.getElementById("version");
      var version    = selVersion.options[selVersion.selectedIndex].value;
      var myAjax = new Ajax.Request(url, {
               method: 'get',
               onComplete: createFilesResults,
               parameters: 'study='+studyId+'&reportTo='+reportTo+'&version='+version+'&'+Math.random()});
               
  }
 }

<s:url id="showFiles" namespace="/" action="/showFilesAction"/>

function createFilesResults(originalRequest){
  var results = originalRequest.responseText.evalJSON();
  document.getElementById("extractStatus").innerHTML = "Generate TAP file...Files Created.  Choose the <b>Download Files</b> link to retrieve them.";

  if (results.files.length==0) {
  document.getElementById("downLoadFileId").innerHTML = "&nbsp";
  } else {
   
    var dataTable1=document.getElementById("downLoadFileId");

    var flag=true;
    var tempString = ""
    for (var i=0;i<results.files.length;i++){
      tempString += 'file' + i + '=' + results.files[i] + '&';
    }
    tempString = '<a href="${showFiles}?' + tempString.substring(0,tempString.length-1) + '">' + 'Download Files' + '</a>';
    document.getElementById("downLoadFileId").innerHTML = tempString;

  }
  
}

<s:url id="removeArchive" namespace="/" action="/removeArchiveAction"/>

function removeArchive(){
  var url = '${removeArchive}';
  var selStudy    = document.getElementById("studyId");
  var selReportTo = document.getElementById("reportTo");
  var studyId = selStudy.options[selStudy.selectedIndex].value;
  var reportTo= selReportTo.options[selReportTo.selectedIndex].value;

  document.getElementById("extractStatus").innerHTML = "Remove the Last Extract:    IN PROGRESS";
  document.getElementById("removeArchiveId").disabled=true;  

  var myAjax = new Ajax.Request(url, {
               method: 'get',
               onComplete: removeArchiveResults,
               parameters: 'study='+studyId+'&reportTo='+reportTo+'&'+Math.random()});
               
}

function removeArchiveResults(originalRequest) {
  var results = originalRequest.responseText.evalJSON();
  if (results.status == "success") {
    document.getElementById("extractStatus").innerHTML = "Remove the Last Extract:    SUCCESS";
  } else {
    document.getElementById("extractStatus").innerHTML = "Remove the Last Extract:    FAIL";
  }
  document.getElementById("removeArchiveId").disabled=false;  

}

<s:url id="transferToArchive" namespace="/" action="/transferToArchiveAction"/>

function transferToArchive(){
  var url = '${transferToArchive}';
  var lExtDt = document.getElementById("lastExtDate").value;
  var cExtDt = document.getElementById("currExtDate").value;
  
  if ((lExtDt !== "") && (cExtDt !== "") && (lExtDt == cExtDt)) {
    document.getElementById("extractStatus").innerHTML = "WARNING: This Extract is already in the Archive.";
    document.getElementById("removeArchiveId").disabled=true;  
  } else {
    var selStudy    = document.getElementById("studyId");
    var selReportTo = document.getElementById("reportTo");
    var studyId = selStudy.options[selStudy.selectedIndex].value;
    var reportTo= selReportTo.options[selReportTo.selectedIndex].value;

    document.getElementById("extractStatus").innerHTML = "Transfer data to the archive table:    IN PROGRESS";
    document.getElementById("removeArchiveId").disabled=true;  

    var myAjax = new Ajax.Request(url, {
                 method: 'get',
                 onComplete: transferToArchiveResults,
                 parameters: 'study='+studyId+'&reportTo='+reportTo+'&'+Math.random()});
  }
               
}

function transferToArchiveResults(originalRequest) {
  var results = originalRequest.responseText.evalJSON();
  if (results.status == "success") {
    document.getElementById("extractStatus").innerHTML = "Transfer data to the archive table:    SUCCESS";
  } else if (results.status == "equal") {
    document.getElementById("extractStatus").innerHTML = "WARNING: This Extract is already in the Archive.";  
  } else {
    document.getElementById("extractStatus").innerHTML = "Transfer data to the archive table:    FAIL";
  }
  document.getElementById("removeArchiveId").disabled=false;  

}

function refresh(){

  <s:url id="queryStatusUrl" namespace="/" action="queryStatus"/>
  var url = '${queryStatusUrl}';
  var myAjax = new Ajax.Request(url, {
    method: 'post',
    onComplete: statusReceived});

  if(doRefresh){
    setTimeout('refresh()',5000)
  }
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
                <!--  <table summary="" cellpadding="0" cellspacing="0" border="0" height="20">-->
                <div>
                  <s:url id="logoutUrl" namespace="/" action="logout" />
                  <s:url id="extractPageUrl" namespace="/" action="goExtractPage" />
                  <s:url id="AddStudyUrl" namespace="/" action="goAddStudyPage" />
                  <s:url id="refreshViewsUrl" namespace="/" action="goRefreshViewsPage" />
                  <s:url id="securityUrl" namespace="/" action="goSecurityPage" />
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
                              <td style="text-align:center; margin-bottom: 9px; color:black; font-size:2em; font-weight:bold">Data Extract Processing</td>
                            </table>
                            <table class="formSimpleBox" summary="" cellpadding="6" cellspacing="0" border="0" align="center">
                              <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>
                                  <label for="studyId">Study</label>
                                </td>
      		      	        <td>
			          <select class="formFieldSizeM"  id="studyId" name="studyId" disabled="true"
			            onChange="getReportTos(this)"></select>
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
			           onChange="getExtractDates()"></select>
			        </td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
		      <!-- Current and Last Extract Dates -->
                      <table cellpadding="0" cellspacing="0" border="0"  style="padding-bottom: 0px; padding-top: 0px;" class="contentBegins">
		         <tr>
                           <td>
                             <table class="formSimpleBox" summary="" cellpadding="6" cellspacing="0" border="0" align="center">
                               <tr>
                                 <td>&nbsp;</td>
                                 <td>&nbsp;</td>
                                 <td>
                                   <label for="lastExtDate">Last Extract Date</label>
                                 </td>
                                 <td>
			           <input type="text" class="formFieldSizeM" style="width:12em" readonly="readonly" id="lastExtDate" name="lastExtDate"/>
 			         </td>
                                 <td>&nbsp;</td>
                                 <td  style="border-left:1px solid #5C5C5C;padding-left:2em">
                                   <label style="text-align:right" for="currExtDate">Current Extract Date</label>
                                 </td>
       		      	        <td>
 			          <input type="text" class="formFieldSizeM" style="width:12em" readonly="readonly" id="currExtDate" name="currExtDate"/>
 			        </td>
                                 <td>&nbsp;</td>
                                 <td>&nbsp;</td>
                               </tr>
                             </table>
                           </td>
                         </tr>
                      </table>
                      <!-- Extraction Section -->
		      <table cellpadding="0" cellspacing="0" border="0" class="contentBegins">
		        <tr>
		          <td>
		            <table class="formSimpleBox" summary="" cellpadding="6" cellspacing="0" border="0" align="center">
		              <tr>
		                <td>&nbsp;</td>
                                <td>
				  <label for="createOptId">Include Data</label>
				</td>
				<td>
				  <select class="formFieldSizeM"  id="createOptId" name="createOptId" disabled="true">
				    <option value="All">All</option>
				    <option value="Since Last Extract">Since Last Extract</option>
				    <option value="By File">By File</option>
				  </select>
				</td>
				<td style="border-left:1px solid #5C5C5C;padding-left:2em">
				  <label for="CDUSOptId">CDUS Options</label>
				</td>
				<td>
				  <select class="formFieldSizeM" id="CDUSOptId" name="CDUSOptId" disabled="true">
				    <option value="CDUS-FULL">Complete</option>
				    <option value="CDUS-ABBR">Abbreviated</option>
				  </select>
			        </td>
       		      	        <td style="border-left:1px solid #5C5C5C;padding-left:2em">
 			          <input type="checkbox" id="confirmOverwriteId" name="confirmOverwriteId"
 			             disabled="true"/>Updates Only
 			        </td>
       		      	        <td style="border-left:1px solid #5C5C5C;padding-left:2em">
 			          <input type="button" class="formFieldSizeM" id="createExtractId" name="createExtractId"
 			             value="Create Extract" disabled="true" onclick="createExtract()"/>
 			        </td>
		                <td>&nbsp;</td>
		              </tr>
		              <!-- Transfer to Achive -->
		              <tr>
		                <td style="border-top:1px solid #5C5C5C">&nbsp;</td>
		                <td style="border-top:1px solid #5C5C5C">&nbsp;</td>
		                <td style="border-top:1px solid #5C5C5C">&nbsp;</td>
		                <td style="border-top:1px solid #5C5C5C">&nbsp;</td>
		                <td style="border-top:1px solid #5C5C5C">&nbsp;</td>
		                <td style="border-top:1px solid #5C5C5C">&nbsp;</td>
       		      	        <td style="border-top:1px solid #5C5C5C;padding-left:2em">
 			          <input type="button" class="formFieldSizeM" id="transferToArchiveId" name="transferToArchiveId"
 			             value="Transfer To Achive" disabled="true" onclick="transferToArchive()"/>
 			        </td>
		                <td style="border-top:1px solid #5C5C5C">&nbsp;</td>
		              </tr>
		              <!-- Generate Text Files -->
		              <tr>
		                <td style="border-top:1px solid #5C5C5C">&nbsp;</td>
                                <td style="border-top:1px solid #5C5C5C">
                                  <label for="lastGenDate">Last Gen. Date</label>
                                </td>
                                <td style="border-top:1px solid #5C5C5C">
			          <input type="text" class="formFieldSizeM" style="width:12em" 
			            readonly="readonly" id="lastGenDate" name="lastGenDate"/>
 			        </td>
				<td colspan="2" style="border-top:1px solid #5C5C5C;border-left:1px solid #5C5C5C;padding-left:2em">
 			          <input type="checkbox" id="fileOverwriteId" name="fileOverwriteId"
 			             disabled="true"/>Overwrite File
				</td>
		                <!--<td style="border-top:1px solid #5C5C5C">&nbsp;</td>-->
		                <td id="downLoadFileId" style="border-top:1px solid #5C5C5C">&nbsp;</td>
       		      	        <td style="border-top:1px solid #5C5C5C;border-left:1px solid #5C5C5C;padding-left:2em">
 			          <input type="button" class="formFieldSizeM" id="createFileId" name="createFileId"
 			             value="Generate Text Files" disabled="true" onclick="createFiles()"/>
 			        </td>
		                <td style="border-top:1px solid #5C5C5C">&nbsp;</td>
		              </tr>
		              <!-- Remove Last Achive -->
		              <tr>
		                <td style="border-top:1px solid #5C5C5C;border-bottom:1px solid #5C5C5C">&nbsp;</td>
		                <td style="border-top:1px solid #5C5C5C;border-bottom:1px solid #5C5C5C">&nbsp;</td>
		                <td style="border-top:1px solid #5C5C5C;border-bottom:1px solid #5C5C5C">&nbsp;</td>
		                <td style="border-top:1px solid #5C5C5C;border-bottom:1px solid #5C5C5C">&nbsp;</td>
		                <td style="border-top:1px solid #5C5C5C;border-bottom:1px solid #5C5C5C">&nbsp;</td>
		                <td style="border-top:1px solid #5C5C5C;border-bottom:1px solid #5C5C5C">&nbsp;</td>
       		      	        <td style="border-top:1px solid #5C5C5C;border-bottom:1px solid #5C5C5C;padding-left:2em">
 			          <input type="button" class="formFieldSizeM" id="removeArchiveId" name="removeArchiveId"
 			             value="Remove Last Achive" disabled="true" onclick="removeArchive()"/>
 			        </td>
		                <td style="border-top:1px solid #5C5C5C;border-bottom:1px solid #5C5C5C">&nbsp;</td>
		              </tr>
		              <!-- Status Field -->
		              <tr>
		                <td>&nbsp;</td>
		                <td style="text-align:right">
                                  <label for="statusId">STATUS:</label>
                                </td>
                                <td colspan="5" style="text-align:left">
			          <span id="extractStatus">&nbsp;</span>
 			        </td>		                
		                <td>&nbsp;</td>
		              </tr>
		             </table>
                           </td>
		         </tr>
                      </table>
		      <!-- FLOAT SECTION -->
		      <div style="width:770px;overflow:auto;">
		      <!-- LEFT TABLE-->
		      <table class="dataTable" style="float:left; width:370;border:1px solid black;
		             background-color:#CCCCCC;margin-left: 5px;">
		        <tr>
		          <td class="dataTableHeader" style="border-bottom-width: 0px; border-right-width: 0px; padding: 0px;">
		            <table style="width: 354px;">
                              <tr class="dataTableHeaderNoBorder">
                                <th style="width:60;padding: 0px;text-align:left;" >File</th>
                                <th style="width:115;padding: 0px;text-align:left;">Step</th>
                                <th style="width:60;padding: 0px;text-align:left;" >Status</th>
                                <th style="width:115;padding: 0px;text-align:left;" >Extract Date</th>
                              </tr>
                            </table>
		          </td>
		        </tr>
		        <tr>
  		          <td style="padding: 0px">
  		            <div style="width:370px; height:160px; overflow:auto">
                              <table id="extractStatusTbl" 
                                     style="width: 354px; border-width: 0px; border-style: solid; border-spacing: 0pt; 
                                            table-layout:fixed; white-space:nowrap; overflow:hidden">
                                <tr class="dataRowLight">
                                  <td class="dataCell2Text" style="width:56px;">&nbsp</td>
                                  <td class="dataCell2Text" style="width:110px;">&nbsp</td>
                                  <td class="dataCell2Text" style="width:56px;">&nbsp</td>
                                  <td class="dataCell2Text">&nbsp</td>
                                </tr>
		              </table>
		            </div>
		          </td>  
		        </tr>
		        <tr>
		          <td class="dataTableHeader" style="border-bottom-width: 0px; border-right-width: 0px; padding: 0px;">
			    <table style="width: 354px;">
			      <tr class="dataRowLight">
			        <td id="overallExtStatId" class="dataCell2Text" 
			            style="width:350;padding: 0px;text-align:left;padding-left: 4px" >Overall Extract Status</td>
			      </tr>
			    </table>
			  </td>
		        </tr>
                      </table>
                      <!-- Second Table RIGHT -->
		      <table class="dataTable" style="width:370;border:1px solid black;
		             background-color:#CCCCCC;margin-left: 5px;">
		        <tr>
		          <td class="dataTableHeader" style="border-bottom-width: 0px; border-right-width: 0px; padding: 0px;">
		            <table style="width: 354px;">
                              <tr class="dataTableHeaderNoBorder">
                                <th style="width:120;padding: 0px;text-align:left;" >File</th>
                                <th style="width:232;padding: 0px;text-align:left;">Error Description</th>
                              </tr>
                            </table>
		          </td>
		        </tr>
		        <tr>
  		          <td style="padding: 0px">
  		            <div style="width:370px; height:160px; overflow:auto">
                              <table id="extractErrorTbl" 
                                     style="width: 354px; border-width: 0px; border-style: solid; border-spacing: 0pt; 
                                            table-layout:fixed; white-space:nowrap; overflow:hidden">
                                <tr class="dataRowLight">
                                  <td class="dataCell2Text" style="width:114px;">&nbsp</td>
                                  <td class="dataCell2Text" style="width:218px;">&nbsp</td>
                                </tr>
	                      </table>
		            </div>
		          </td>  
		        </tr>
		        <tr>
		          <td class="dataTableHeader" style="border-bottom-width: 0px; border-right-width: 0px; padding: 0px;">
			    <table style="width: 354px;">
			      <tr class="dataRowLight">
			        <td id="overallErrStatId" class="dataCell2Text" 
			            style="width:350;padding: 0px;text-align:left;padding-left: 4px">No Overall Error Found</td>
			      </tr>
			    </table>
			  </td>
		        </tr>
                      </table>
                      <table style="width: 354px;">
                        <tr style="height: 40">
                          <td style="text-align:center">
                            <input type="button" class="formFieldSizeM" id="refreshScreenId" name="refreshScreenId"
                                   value="Refresh Screen" onclick="getExtractDates()"/>
                          </td>
                        </tr>
	              </table>
                    </div>
                    <!--Float Tables Ends -->
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
