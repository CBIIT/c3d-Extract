<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>C3D Data Extract - Add New Study</title>
<link rel="stylesheet" type="text/css" href="styleSheet.css" />
<script src="script.js" type="text/javascript"></script>

<script type="text/javascript" src="prototype.js"></script>
<script type="text/javascript">


var newStudy;
var newReportTo;
var newVersion;
var copStudy;
var copReportTo;
var copVersion;
var override;
var newReportAs;
var newMRNInstCD;

function AutoStart() {
    getStudyIds();
}

<s:url id="queryAvailableStudyIds" namespace="/" action="/getAvailableStudies"/>
<s:url id="queryTemplateStudies" namespace="/" action="/getTemplateStudies"/>

function getStudyIds(){
  var url = '${queryAvailableStudyIds}';
  var url2 = '${queryTemplateStudies}';
  var myAjax = new Ajax.Request(url, {
               method: 'get',
               onComplete: populateAvailableStudyLOV,
               parameters: '&'+Math.random()});
  var myAjax = new Ajax.Request(url2, {
               method: 'get',
               onComplete: populateTemplateStudyLOV,
               parameters: '&'+Math.random()});

}

function populateAvailableStudyLOV(originalRequest){
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

function populateTemplateStudyLOV(originalRequest){
  var result = originalRequest.responseText.evalJSON();
  
  //availableStudyIds=result.studies;
  var select=document.getElementById("fromStudy");
  select.options.length=0;
  select.disabled=false;
  select.options[0]=new Option("Pick Template...", "Pick Template...");
  
  for (var i=0;i<result.templates.length;i++){
    select.options[i+1]=new Option(result.templates[i],result.templates[i]);
  }
}
    
function addFieldMsg(inText) {
  var fieldValue = document.getElementById("statusField").innerHTML;
  if ((fieldValue == "") || (fieldValue == "&nbsp")) {
    fieldValue += inText;
  }else {
    fieldValue += "<br />" + inText;
  }
  
  document.getElementById("statusField").innerHTML = fieldValue;
  //document.getElementById("statusField").value = fieldValue;
}    

function cleanFieldMsg() {
  document.getElementById("statusField").innerHTML = "";
}    

function createNewStudy(originalRequest){
  cleanFieldMsg();
  document.getElementById("newStudyStatus").innerHTML = "IN PROCESS";
  addFieldMsg("<b>In Process...<b/><br />");
  setCursor("wait");
  var selStudy = document.getElementById("studyId");
  var studyId  = selStudy.options[selStudy.selectedIndex].value;
  var selFrom  = document.getElementById("fromStudy");
  var frStudy  = selFrom.options[selFrom.selectedIndex].value;
  if (studyId.indexOf("(") > 1 ) {
    studyId = studyId.substring(0,studyId.indexOf("(")-1);
    //addFieldMsg("studyId=["+studyId+"]");
  } 
  if (frStudy.indexOf("[") == -1 ) {
    copStudy = "";
  } else { 
    copStudy    = frStudy.substring(0,frStudy.indexOf("[")-1);
    copReportTo = frStudy.substring(frStudy.indexOf("[")+1,frStudy.indexOf("-")-1);
    copVersion  = frStudy.substring(frStudy.indexOf("-")+2,frStudy.indexOf("]"));
    //addFieldMsg("fromStudy=["+fromStudy+"]; fromRptTo=["+fromRptTo+"]");
  }
  newStudy = studyId;
  newReportTo  = document.getElementById("newReportTo").value;
  newVersion   = document.getElementById("newVersion").value;
  newReportAs  = document.getElementById("newReportAs").value;
  newMRNInstCD = document.getElementById("newMRNInstCD").value;
  if (document.getElementById("newStudyOverride").checked == true) {
    override = "YES";
  } else {
    override = "NO";
  }
  var failed = false;
  if ((studyId == "" ) || (studyId == "Pick Study...")) {
    addFieldMsg("<b>ERROR:</b> New Study not selected.");
    failed = true;
  } 
  if ((selFrom == "" ) || (selFrom == "Pick Template...")) {
    addFieldMsg("ERROR: Template Study not selected.");
    failed = true;
  } 
  if ((copStudy == "" ) || (copStudy == "Pick Template...")) {
    addFieldMsg("<b>ERROR:</b> Template Study cannot be identified from " + fromStudy);
    failed = true;
  } 
  if (newReportTo == "" ) {
    addFieldMsg("<b>ERROR:</b> Report To of New Study Definition cannot be blank!");
    failed = true;
  } 
  if (newVersion == "" ) {
    addFieldMsg("<b>ERROR:</b> Version of New Study Definition cannot be blank!");
    failed = true;
  } 
  if (newReportAs == "" ) {
    addFieldMsg("<b>ERROR:</b> Report As of New Study Definition cannot be blank!");
    failed = true;
  } 
  if (newMRNInstCD == "" ) {
    addFieldMsg("<b>ERROR:</b> MRN Institution Code of New Study Definition cannot be blank!");
    failed = true;
  } 
  if ((newStudy == copStudy) && (newReportTo == copReportTo) && (override != "YES")) {
    addFieldMsg("<b>ERROR:</b> New Study Definition same as Based on, select 'Override Existing Definition' to continue");
    failed = true;
  }
  if (failed) {
    addFieldMsg("<br /><b>Create Study Definition Failed, see above.</b>");
    document.getElementById("newStudyStatus").innerHTML = "<b>FAILED</b>";
    setCursor("default");
  } else {
    addFieldMsg("Validation success...continuing");
    <s:url id="validateStudyDef" namespace="/" action="/validateStudyDef"/>
    
    var url = '${validateStudyDef}';
    var myAjax = new Ajax.Request(url, {
                 method: 'get',
                 onComplete: setStudyCtrl,
                 parameters: 'newStudy='+newStudy+'&newReportTo='+newReportTo+'&newVersion='+newVersion+
                             '&copStudy='+copStudy+'&copReportTo='+copReportTo+'&copVersion='+copVersion+
                             '&override='+override+'&'+Math.random()});
      
  }
}

function setStudyCtrl(originalRequest){
  var result = originalRequest.responseText.evalJSON();

  var valid = result.valid;
  if (!(valid)) {
    addFieldMsg(result.validateText);
    document.getElementById("newStudyStatus").innerHTML = "<b>FAILED</b>";
    setCursor("default");
  } else {
    
    addFieldMsg("<b> ADD STUDY<b/> BEGINNING...");
    addFieldMsg("...Setting up Extract Account...");
    addFieldMsg(". . . .Study Control Setup...");
  
    <s:url id="setStudyCtrl" namespace="/" action="/setStudyCtrl"/>
    
    var url = '${setStudyCtrl}';
    var myAjax = new Ajax.Request(url, {
                 method: 'get',
                 onComplete: buildExtSchema,
                 parameters: 'newStudy='+newStudy+'&'+Math.random()});
  }
}

function buildExtSchema(originalRequest){
  var result = originalRequest.responseText.evalJSON();

  var valid = result.valid;
  if (!(valid)) {
    addFieldMsg(result.validateText);
    document.getElementById("newStudyStatus").innerHTML = "<b>FAILED</b>";
    setCursor("default");    
  } else {
    addFieldMsg(". . . .Study Control Setup - - Done.");
    addFieldMsg(". . . .Extract Schema Setup...");
  
    <s:url id="buildExtSchema" namespace="/" action="/buildExtSchema"/>
    
    var url = '${buildExtSchema}';
    var myAjax = new Ajax.Request(url, {
                 method: 'get',
                 onComplete: setReportCtrl,
                 parameters: 'newStudy='+newStudy+'&'+Math.random()});
  }
}

function setReportCtrl(originalRequest){
  var result = originalRequest.responseText.evalJSON();

  var valid = result.valid;
  if (!(valid)) {
    addFieldMsg("<u>" + result.validateText + "</u>");
    addFieldMsg("...Setting up Extract Account...<b>FAILED<b/>");
    document.getElementById("newStudyStatus").innerHTML = "<b>FAILED</b>";
    setCursor("default");    
  } else {
    addFieldMsg(". . . .Extract Schema Setup - - Done.");
    addFieldMsg("...Setting up Extract Account...<b>COMPLETE<b/>");
    addFieldMsg("...Setting up Study Reporting...");
  
    <s:url id="setReportCtrl" namespace="/" action="/setReportCtrl"/>
    
    var url = '${setReportCtrl}';
    var myAjax = new Ajax.Request(url, {
                 method: 'get',
                 onComplete: setViewCtrl,
                 parameters: 'newStudy='+newStudy+'&newReportTo='+newReportTo+'&newVersion='+newVersion+
                             '&newReportAs='+newReportAs+'&'+Math.random()});
  }
}

function setViewCtrl(originalRequest){
  var result = originalRequest.responseText.evalJSON();

  var valid = result.valid;
  if (!(valid)) {
    addFieldMsg(result.validateText);
    addFieldMsg("...Setting up Study Reporting...<b>FAILED<b/>");
    document.getElementById("newStudyStatus").innerHTML = "<b>FAILED</b>";
    setCursor("default");
  } else {
    addFieldMsg("...Setting up Study Reporting...<b>COMPLETE<b/>");
    addFieldMsg("...Setting up Study Extract Views...");
  
    <s:url id="setViewCtrl" namespace="/" action="/setViewCtrl"/>
    
    var url = '${setViewCtrl}';
    var myAjax = new Ajax.Request(url, {
                 method: 'get',
                 onComplete: genLabOther,
                 parameters: 'newStudy='+newStudy+'&newMRNInstCD='+newMRNInstCD+'&copStudy='+copStudy});
  }
}

function genLabOther(originalRequest){
  var result = originalRequest.responseText.evalJSON();

  var valid = result.valid;
  if (!(valid)) {
    addFieldMsg(result.validateText);
    addFieldMsg("...Setting up Study Extract Views...<b>FAILED<b/>");
    document.getElementById("newStudyStatus").innerHTML = "<b>FAILED</b>";
    setCursor("default");
  } else {
    addFieldMsg(". . . .Extract Study Views Setup - - Done.");
    addFieldMsg(". . . .Extract Study Lab Views Setup...");
  
    <s:url id="genLabOther" namespace="/" action="/genLabOther"/>
    
    var url = '${genLabOther}';
    var myAjax = new Ajax.Request(url, {
                 method: 'get',
                 onComplete: createStudyVw,
                 parameters: 'newStudy='+newStudy+'&newVersion='+newVersion+'&'+Math.random()});
  }
}

function createStudyVw(originalRequest){
  var result = originalRequest.responseText.evalJSON();

  var valid = result.valid;
  if (!(valid)) {
    addFieldMsg(result.validateText);
    addFieldMsg("...Setting up Study Extract Views...<b>FAILED<b/>");
    document.getElementById("newStudyStatus").innerHTML = "<b>FAILED</b>";
    setCursor("default");
  } else {
    addFieldMsg(". . . .Extract Study Lab Views Setup - - Done.");
    addFieldMsg(". . . .Extract Study Lab Views Creation...");
  
    <s:url id="createStudyVw" namespace="/" action="/createStudyVw"/>
    
    var url = '${createStudyVw}';
    var myAjax = new Ajax.Request(url, {
                 method: 'get',
                 onComplete: createStudyOCSyn,
                 parameters: 'newStudy='+newStudy+'&newVersion='+newVersion+'&'+Math.random()});
  }
}

function createStudyOCSyn(originalRequest){
  var result = originalRequest.responseText.evalJSON();

  var valid = result.valid;
  if (!(valid)) {
    addFieldMsg(result.validateText);
    addFieldMsg("...Setting up Study Extract Views...<b>FAILED<b/>");
    document.getElementById("newStudyStatus").innerHTML = "<b>FAILED</b>";
    setCursor("default");
  } else {
    addFieldMsg(". . . .Extract Study Lab Views Creation - - Done.");
    addFieldMsg("...Setting up Study Extract Views...<b>COMPLETE<b/>");
    addFieldMsg("...Setting up Synonyms...");
  
    <s:url id="createStudyOCSyn" namespace="/" action="/createStudyOCSyn"/>
    
    var url = '${createStudyOCSyn}';
    var myAjax = new Ajax.Request(url, {
                 method: 'get',
                 onComplete: setCrsCtrl,
                 parameters: 'newStudy='+newStudy+'&'+Math.random()});
  }
}

function setCrsCtrl(originalRequest){
  var result = originalRequest.responseText.evalJSON();

  var valid = result.valid;
  if (!(valid)) {
    addFieldMsg(result.validateText);
    addFieldMsg("...Setting up Synonyms...<b>FAILED<b/>");
    document.getElementById("newStudyStatus").innerHTML = "<b>FAILED</b>";
    setCursor("default");
  } else {
    addFieldMsg("...Setting up Synonyms...<b>COMPLETE<b/>");
    addFieldMsg("...Setting up Other Objects...");
    addFieldMsg(". . . .Extract Study Cursors Setup...");
    addFieldMsg("newStudy=["+newStudy+"]; newReportTo=["+newReportTo+"]; newVersion=["+newVersion+
                          "]; copStudy=["+copStudy+"]; copReportTo=["+copReportTo+"]; copVersion=["+copVersion+"]");
  
    <s:url id="setCrsCtrl" namespace="/" action="/setCrsCtrl"/>
    
    var url = '${setCrsCtrl}';
    var myAjax = new Ajax.Request(url, {
                 method: 'get',
                 onComplete: setFileCtrl,
                 parameters: 'newStudy='+newStudy+'&newReportTo='+newReportTo+'&newVersion='+newVersion+
                             '&copStudy='+copStudy+'&copReportTo='+copReportTo+'&copVersion='+copVersion+'&'+Math.random()});
  }
}

function setFileCtrl(originalRequest){
  var result = originalRequest.responseText.evalJSON();

  var valid = result.valid;
  if (!(valid)) {
    addFieldMsg(result.validateText);
    addFieldMsg("...Setting up Other Objects...<b>FAILED<b/>");
    document.getElementById("newStudyStatus").innerHTML = "<b>FAILED</b>";
    setCursor("default");
  } else {
    addFieldMsg(". . . .Extract Study Cursors Setup - - Done.");
    addFieldMsg(". . . .Extract Study File Setup...");
    addFieldMsg("newStudy=["+newStudy+"]; newReportTo=["+newReportTo+"]; newVersion=["+newVersion+
                          "]; copStudy=["+copStudy+"]; copReportTo=["+copReportTo+"]; copVersion=["+copVersion+"]");
  
  
    <s:url id="setFileCtrl" namespace="/" action="/setFileCtrl"/>
    
    var url = '${setFileCtrl}';
    var myAjax = new Ajax.Request(url, {
                 method: 'get',
                 onComplete: completeAddStudy,
                 parameters: 'newStudy='+newStudy+'&newReportTo='+newReportTo+'&newVersion='+newVersion+
                             '&copStudy='+copStudy+'&copReportTo='+copReportTo+'&copVersion='+copVersion+'&'+Math.random()});
  }
}

function completeAddStudy(originalRequest){
  var result = originalRequest.responseText.evalJSON();

  var valid = result.valid;
  if (!(valid)) {
    addFieldMsg(result.validateText);
    addFieldMsg("...Setting up Other Objects...<b>FAILED<b/>");
    document.getElementById("newStudyStatus").innerHTML = "<b>FAILED</b>";
    setCursor("default");
  } else {
    addFieldMsg(". . . .Extract Study File Setup - - Done.");
    addFieldMsg("...Setting up Other Objects...<b>COMPLETE<b/>");
  
    addFieldMsg("<br/><b> ADD STUDY SUCCESS!</b>");
    document.getElementById("newStudyStatus").innerHTML = "<b>SUCCESS</b>";
    setCursor("default");
  }
}

function copyBasedOn(selObject){
  var value = selObject.options[selObject.selectedIndex].value;

  if ((value != "") && (value != "Pick Template..."))  {
    var value = selObject.options[selObject.selectedIndex].value;
    var hReportTo= value.substring(value.indexOf("[")+1,value.indexOf("-")-1);
    var hVersion = value.substring(value.indexOf("-")+2,value.indexOf("]"));   
    document.getElementById("newReportTo").value = hReportTo;
    document.getElementById("newVersion").value = hVersion;
  }
}

function newStudySelected(selObject){
  var value = selObject.options[selObject.selectedIndex].value;
  if (value.indexOf("(") > 1 ) {
    document.getElementById("newStudyOverride").disabled=false; 
  } else {
    document.getElementById("newStudyOverride").disabled=true; 
  }
}

function setCursor(cStatus){
	document.body.style.cursor=cStatus;
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
	          <div>
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
			      <td style="text-align:center; margin-bottom: 9px; color:black; font-size:2em; font-weight:bold">Add New Study</td>
                            </table>
                            <table class="formSimpleBox" summary="" cellpadding="6" cellspacing="0" border="0" align="center">
			      <tr>
			        <td colspan="3">&nbsp;</td>
			        <!--<td>&nbsp;</td>
			        <td>&nbsp;</td>-->
			        <td style="text-align:right;">
			          <label for="studyId" >New Study:</label>
			        </td>
			        <td>
			          <select class="formFieldSizeM"  id="studyId" name="studyId" 
			                  onChange="newStudySelected(this);" title="* denotes already defined">
			    	  </select>
			        </td>
			        <td>&nbsp;</td>
			        <td style="border-left:1px solid #5C5C5C;padding-left:2em;">
			          <label style="text-align:right" for="reportTo">Based on:</label>
			        </td>
			        <td style="padding-right: 0px; padding-left: 0px;">
			          <select class="formFieldSizeM" style="width:19em" id="fromStudy" name="fromStudy"
			                  onChange="copyBasedOn(this);">
			          </select>
			        </td>
		                <td>&nbsp;</td>
	                      </tr>
			      <tr>
			        <td colspan="2" style="padding-top: 3px; padding-bottom: 3px;border-top:1px solid #5C5C5C;">&nbsp;</td>
			        <td colspan="2" style="padding-top: 3px; padding-bottom: 3px;border-top:1px solid #5C5C5C;">New Study Definition</td>
			        <td colspan="5" style="padding-top: 3px; padding-bottom: 3px;border-top:1px solid #5C5C5C;">&nbsp;</td>
	                      </tr>
			      <tr">
			        <td colspan="3" style="padding-top: 3px; padding-bottom: 3px;">&nbsp;</td>
			        <td style="text-align:right; padding-top: 3px; padding-bottom: 3px;">
			          <label for="newReportTo">Report To:</label>
			        </td>
			        <td style="padding-top: 3px; padding-bottom: 3px;">
			          <input type="text" class="formFieldSizeM" id="newReportTo" name="newReportTo"/>
			        </td>
			        <td style="padding-top: 3px; padding-bottom: 3px;">&nbsp;</td>
			        <td style="padding-top: 3px; padding-bottom: 3px;text-align:right;">
				  <label for="newReportAs">Report As:</label>
				</td>
				<td style="padding-top: 3px; padding-bottom: 3px;">
				  <input type="text" class="formFieldSizeM" id="newReportAs" name="newReportAs"/>
			        </td>
	                      </tr>
			      <tr>
			        <td colspan="3" style="padding-top: 3px; padding-bottom: 3px;">&nbsp;</td>
			        <td style="padding-top: 3px; padding-bottom: 3px;text-align:right;">
			          <label for="newVersion">Version:</label>
			        </td>
			        <td style="padding-top: 3px; padding-bottom: 3px;">
			          <input type="text" class="formFieldSizeM" id="newVersion" name="newVersion"/>
			        </td>
			        <td style="padding-top: 3px; padding-bottom: 3px;">&nbsp;</td>
			        <td style="padding-top: 3px; padding-bottom: 3px;text-align:right;">
			          <label for="newMRNInstCD">MRN Inst CD:</label>
			        </td>
			        <td style="padding-top: 3px; padding-bottom: 3px;">
			          <input type="text" class="formFieldSizeM" id="newMRNInstCD" name="newMRNInstCD"/>
			        </td>
	                      </tr>
			      <!--<tr>
			        <td colspan="3" style="padding-top: 3px; padding-bottom: 3px;">&nbsp;</td>
			        <td style="padding-top: 3px; padding-bottom: 3px;text-align:right;">
			          <label for="newReportAs">Report As:</label>
			        </td>
			        <td style="padding-top: 3px; padding-bottom: 3px;">
			          <input type="text" class="formFieldSizeM" id="newReportAs" name="newReportAs"/>
			        </td>
			        <td colspan="3" style="padding-top: 3px; padding-bottom: 3px;">&nbsp;</td>
	                      </tr>-->
			      <!--<tr>
			        <td colspan="3" style="padding-top: 3px; padding-bottom: 3px;">&nbsp;</td>
			        <td style="padding-top: 3px; padding-bottom: 3px;text-align:right;">
			          <label for="newMRNInstCD">MRN Inst CD:</label>
			        </td>
			        <td style="padding-top: 3px; padding-bottom: 3px;">
			          <input type="text" class="formFieldSizeM" id="newMRNInstCD" name="newMRNInstCD"/>
			        </td>
			        <td colspan="3" style="padding-top: 3px; padding-bottom: 3px;">&nbsp;</td>
	                      </tr>-->
			      <tr>
			        <td colspan="9" style="padding:8px;text-align:center">
 			          <input type="checkbox" 
 			            id="newStudyOverride" name="newStudyOverride" value="YES" disabled="true"
 			            value="Create New Study Definition" />Override Existing Definition
 			        </td>
			      <tr>
			        <td colspan="9" style="padding:8px;text-align:center">
 			          <input type="button" class="formFieldSizeM" style="width:14em"
 			            id="createNewStudyId" name="createNewStudyId"
 			            value="Create New Study Definition" onclick="createNewStudy()"/>
 			        </td>
	                      </tr>
			      <tr>
			        <!--<td colspan="9" style="padding:6px;border-top:1px solid #5C5C5C;">Run Status:</td>-->
			        <td style="padding:6px;border-top:1px solid #5C5C5C;border-bottom:1px solid #5C5C5C;">Overall Status:</td>
			        <td colspan="8" style="padding:6px;border-top:1px solid #5C5C5C;border-bottom:1px solid #5C5C5C;">
			           <span id="newStudyStatus">&nbsp;</span>
			        </td>
	                      </tr>
			      <tr>
			        <td colspan="9" >Status Detail:</td>
	                      </tr>
			      <tr>
			        <!-- <td colspan="9" style="padding:0px;padding-bottom:6px;text-align:center">-->
			          <!--<input type=text style="width: 575px; height: 200px;resize:none;" 
			                id="statusField" name="statusField" multiline="true" />-->
			          <!--<p name="statusField" id="statusField" style="height: 200px; overflow: auto;
			             padding: 1em; text-align: left; font-size: 1.1em; max-width: 564px;"/> -->
			          <!--<p name="statusField" id="statusField" style="height: 200px; overflow: auto;
			             text-align: left; max-width: 641px;"/>-->
			        <td colspan="9" style="vertical-align: top; max-height: 200px; height: 200px; padding-left:25px;padding-bottom:6px;">
				  <span name="statusField" id="statusField" style="overflow:auto;text-align: left; width: 604px; height: 200px;display:inline-block; display:-moz-inline-stack;">
		                    &nbsp
			          </span>
			        </td>
	                      </tr>
                            </table>
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
