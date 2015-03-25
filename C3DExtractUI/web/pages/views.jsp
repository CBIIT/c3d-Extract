<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>C3D Data Extract - View Manipulator</title>
<link rel="stylesheet" type="text/css" href="styleSheet.css" />
<script src="script.js" type="text/javascript"></script>

<script type="text/javascript" src="prototype.js"></script>
<script type="text/javascript">


var selectedStudy;
var viewRecords;
var curRec = 0;
var lastRec = -1;
var noteShown = false;
var openTrans = false;
var reload = true;
var inboundStudy    = '<s:property value="study" />';
var inboundCurRec   = '<s:property value="cRec" />';

function AutoStart() {
  if (( inboundStudy == null) || ( inboundStudy == "") || 
      ( inboundCurRec == null) || ( inboundCurRec == "") ) {
    reload = false;
  }

  getStudyIds();
}

function setStatus(msg){
  document.getElementById("statusText").innerHTML=msg;
}

function setCursor(cStatus){
	document.body.style.cursor=cStatus;
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
     getViews(select);    
  }
  
}

<s:url id="getViews" namespace="/" action="/getViews"/>

function getViews(selectObject){
  if (selectedStudy != selectObject.options[selectObject.selectedIndex].value) {
    selectedStudy = selectObject.options[selectObject.selectedIndex].value;
    curRec = 0;
    displayClean();
  }
  
  if (selectedStudy != "Pick Study...") {
    setCursor("wait");
    setStatus("<b>Query executing, please wait...</b>");
    var url = '${getViews}';
    // NOTE: Added random number to end of URL to force IE8 to not look at cache
    var myAjax = new Ajax.Request(url, {
                   method: 'get',
                   onComplete: populateViewTable,
                 parameters: 'study='+selectedStudy+'&'+Math.random()});
  } else {
    setStatus("You must select a valid Study.");
  }
}

function trim(stringToTrim) {
	return stringToTrim.replace(/^\s+|\s+$/g,"");
}

<s:url id="getViewJournals" namespace="/" action="viewJournal"/>

function populateViewTable(originalRequest){
  var results = originalRequest.responseText.evalJSON();
  viewRecords=results.ctExtVwCtls;
  setCursor("default");
  clearStatus();
  
  lastRec = viewRecords.length-1;
  if (curRec >= lastRec) {
    curRec = lastRec;
  }
  clearStatus();
  
  if (reload) {
     curRec = parseInt(inboundCurRec);
     var url = '${getViewJournals}';
     var myAjax = new Ajax.Request(url, {
                        method: 'get',
                        onComplete: afterClearJournal,
                        parameters: 'study=null&cRec=0&'+Math.random()});
                   
     reload = false;
  }

  displayRecord(curRec);   // Study Record Display  
}

function afterClearJournal() {
  reload = false;
  displayRecord(curRec);  
  setCursor("default");
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
  displayRecord(curRec);
}

function displayLastRecord(){
  if (curRec >= lastRec) {
    setStatus('<b>NOTE</b>: At last record.');
  }
  curRec = lastRec;
  displayRecord(curRec);
}

function displayBackward(){
  if (curRec <= 0) {
    setStatus('<b>NOTE</b>: At first record.');
    curRec = 0;
  }else{
    curRec -= 1;
  }
  displayRecord(curRec);
}

function displayForward(){
  if (curRec >= lastRec) {
    setStatus('<b>NOTE</b>: At last record.');
    curRec = lastRec;
  }else{
    curRec += 1;
  }
  displayRecord(curRec);
}

function displayCurrentRecord(){
  if (curRec >= lastRec) {
    curRec = lastRec;
  }
  displayRecord(curRec);
}

function setFieldDisplayType(type, field, value) {
  if (value == null) {
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

  setFieldDisplayType("view", document.getElementById("synName"), "");
		      	
  setFieldDisplayType("view", document.getElementById("vwName"), "");

  //Second Row
  setFieldDisplayType("view", document.getElementById("crtSeq"), "");
                        
  setFieldDisplayType("view", document.getElementById("modUser"), "");

  setFieldDisplayType("view", document.getElementById("modDate"), "");

  //View text
  setFieldDisplayType("view", document.getElementById("viewText"), "");

  var field = document.getElementById("action1");
  field.innerHTML='<a href="#" onclick="setViewActions(\'edit\')">Edit</a>';
  var field = document.getElementById("action2");
  field.innerHTML='<a href="#" onclick="setViewActions(\'delete\')">Delete</a>';

  var field = document.getElementById("recOfRecs");
  field.innerHTML= '0 / 0';

  setFieldDisplayType("view", document.getElementById("Note"), "");
  hideNote();

  var field = document.getElementById("noteButton");
  field.disabled=false;
}

function displayRecord(rec){

  setFieldDisplayType("view", document.getElementById("synName"), viewRecords[rec].synonymName);
		      	
  setFieldDisplayType("view", document.getElementById("vwName"), viewRecords[rec].viewName);
   
  //Second Row
  setFieldDisplayType("view", document.getElementById("crtSeq"), viewRecords[rec].crtSeq);
                        
  setFieldDisplayType("view", document.getElementById("modUser"), viewRecords[rec].modifiedBy);

  setFieldDisplayType("view", document.getElementById("modDate"), viewRecords[rec].modifiedDate);

  //View text
  setFieldDisplayType("view", document.getElementById("viewText"), viewRecords[rec].text);

  var field = document.getElementById("action1");
  field.innerHTML='<a href="#" onclick="setViewActions(\'edit\')">Edit</a>';
  var field = document.getElementById("action2");
  field.innerHTML='<a href="#" onclick="setViewActions(\'delete\')">Delete</a>';

  var field = document.getElementById("recOfRecs");
  field.innerHTML= (curRec+1) + ' / ' + (lastRec+1)

  setFieldDisplayType("view", document.getElementById("Note"), viewRecords[rec].note);
  if (noteShown) {
    showNote();
  }else{
    hideNote();
  }

  <s:url id="viewJournalURL" namespace="/" action="/goViewJournalPage"/>

  var field = document.getElementById("journalAction");
  if (viewRecords[rec].hasJournal) {
    field.setAttribute("href",'${viewJournalURL}?study=' + selectedStudy + 
                       '&viewName='+document.getElementById("vwName").value + '&cRec='+curRec);
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

function setViewActions(action){

  if (selectedStudy == null) {
    setStatus('<b>WARNING:</b> You must select a Study, Report To and Version first.');
  }else{
    if (action == "delete") {
      setStatus('Select "Confirm" to Confirm Deletion of ' + selectedStudy + ' Study View Record; select "Cancel" to Cancel Delete.');

      var field = document.getElementById("action1");
      field.innerHTML='<a href="#" onclick="delView(curRec)">Confirm</a>';
      var field = document.getElementById("action2");
      field.innerHTML='<a href="#" onclick="setViewActions(\'normal\')">Cancel</a>';
      
      openTrans = true;
    } 
    if (action == "normal") {
        clearStatus();
  
        openTrans = false;
    
        displayRecord(curRec);

        var field = document.getElementById("action1");
        field.innerHTML='<a href="#" onclick="setViewActions(\'edit\')">Edit</a>';
        var field = document.getElementById("action2");
        field.innerHTML='<a href="#" onclick="setViewActions(\'delete\')">Delete</a>';

    }   
    if (action == "edit") {
      setStatus('Select "Save" to Commit changes for ' + selectedStudy + ' Study View Control Record, "Cancel" to Cancel Edit.');

      //First Row
      setFieldDisplayType("editUC", document.getElementById("synName"), viewRecords[curRec].synonymName);

      setFieldDisplayType("editUC", document.getElementById("vwName"), viewRecords[curRec].viewName);

      //Second Row
      setFieldDisplayType("edit", document.getElementById("crtSeq"), viewRecords[curRec].crtSeq);
                        
      //setFieldDisplayType("edit", document.getElementById("modUser"), viewRecords[curRec].modifiedBy);

      //setFieldDisplayType("edit", document.getElementById("modDate"), viewRecords[curRec].modifiedDate);

      setFieldDisplayType("edit", document.getElementById("viewText"), viewRecords[curRec].text);
      document.getElementById("viewText").rows="17";

      var field = document.getElementById("action1");
      field.innerHTML='<a href="#" onclick="updView()">Save</a>';
      var field = document.getElementById("action2");
      field.innerHTML='<a href="#" onclick="setViewActions(\'normal\')">Cancel</a>';

      setFieldDisplayType("edit", document.getElementById("Note"), viewRecords[curRec].note);
      showNote();
      
      document.getElementById("synName").focus();  

      openTrans = true;

    }
  }
}

function showNote() {
    var field = document.getElementById("viewText");
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
    var field = document.getElementById("viewText");
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

function delView(){
  <s:url id="delView" namespace="/" action="/delView"/>

  var delviewName=viewRecords[curRec].viewName;
  
  var url = '${delView}';
  var myAjax = new Ajax.Request(url, {
                   method: 'post',
                   onComplete: afterdelView,
                   parameters: 'study='+selectedStudy+'&viewName='+delviewName});
}

function afterdelView(){
  openTrans = false;

  getViews(document.getElementById("studyId"));  
}

function updView(){
  <s:url id="updView" namespace="/" action="/updView"/>

  var edtviewName = document.getElementById("vwName").value;
  var edtcrtSeq = document.getElementById("crtSeq").value;
  var edtsynName = document.getElementById("synName").value;
  //Must encode because the SQL Text could contain ("%","+", "&")
  var edtviewText = encodeURIComponent(document.getElementById("viewText").value);
  var edtNote = encodeURIComponent(document.getElementById("Note").value);
  
  var url = '${updView}';
  var myAjax = new Ajax.Request(url, {
                   method: 'post',
                   onComplete: afterupdView,
                   parameters: 'keyStudy='+selectedStudy+'&keyViewName='+viewRecords[curRec].viewName+
                               '&viewName='+edtviewName+'&crtSeq='+edtcrtSeq+'&synonymName='+edtsynName+
                               '&text='+edtviewText+'&note='+edtNote});

}

function afterupdView(){
  openTrans = false;

  getViews(document.getElementById("studyId"));  
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
                              <td style="text-align:center; margin-bottom: 9px; color:black; font-size:2em; font-weight:bold">View Manipulator</td>
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
                                    onChange="getViews(this)">
                            </select>
			  </td>
                          <td>&nbsp;</td>
			  <td width="498px" style="border-right:0px solid #5C5C5C;border-top:0px solid #5C5C5C;border-left:1px solid #5C5C5C;padding-left:2em">
			  </td>
                        </tr>
                      </table>
                      <table class="formSimpleBox"  
                             style="width:700;border:1px solid black; padding: 2px; border-bottom-width:0px; border-top-width:0px; table-layout:fixed;" id="views" >
                        <tr>
                          <td style="width:90px; text-align:right;">Synonym Name:</td>
                          <td style="width:248px;">
		      	    <input type="text" class="formFieldSizeM" style="width:248px; font-size:1em; background-color:transparent;" 
		      	           id="synName" value="&nbsp" readonly="true"/>
		      	  </td>
		      	
                          <td style="width:90px; text-align:right">View Name:</td>
                          <td style="width:248px;">
                            <input type="text" class="formFieldSizeM" style="width:248px; font-size:1em; background-color:transparent;" 
                                   id="vwName" value="&nbsp" readonly="true"/>
		      	  </td>		      	  
                        </tr>
                        
		      </table>	
                      <table class="formSimpleBox" 
                             style="width:700;border:1px solid black; padding: 2px; border-bottom-width:0px; border-top-width:0px; table-layout:fixed;" id="views" >
                        <tr>
                          
                          <td style="width:90px; text-align:right">Create Seq:</td>
                          <td style="width:25px">
                            <input type="text" class="formFieldSizeM" style="width:25px; font-size:1em; background-color:transparent;" 
                                   id="crtSeq" value="&nbsp" readonly="true"/>
                          </td>
                        
                          <td style="width:276px; text-align:right">Mod. User:</td>
                          <td style="width:100px">
                            <input type="text" class="formFieldSizeM" style="width:100px; font-size:1em; background-color:transparent;" 
                                   id="modUser" value="&nbsp" readonly="true"/>
                          </td>

                          <td style="width:77px; text-align:right">Mod. Date:</td>
                          <td style="width:100px;">
                            <input type="text" class="formFieldSizeM" style="width:100px; font-size:1em; background-color:transparent;" 
                                   id="modDate" value="&nbsp" readonly="true"/>
		      	  </td>

                        </tr>
                      </table>
                      <table class="formSimpleBox" 
                             style="width:700;border:1px solid black; border-bottom-width:0px; border-top-width:0px; table-layout:fixed;" id="views" >
                        <tr>
                          <td style="border-spacing: 0; padding: 2px; text-align:center">
                            <textarea  class="dataCell2Text" id="viewText" 
                                       style="border-spacing: 0; border-style: inset; border-width: 1px; font-size:1.25em; 
                                              width:658; background-color:transparent"
		                       cols="80" rows="19"  readonly="true" id="viewText">&nbsp</textarea>
                          </td>
                        </tr>
                    </table>
                      <table class="formSimpleBox" 
                             style="width:700;border:1px solid black; border-top-width:0px; table-layout:fixed;" id="views" >
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
                          <td style="width:40px; text-align:center" id="action1">
                            <a href="#" onclick="displayRecord(lastRec)">Edit</a>
                          </td>
                          <td style="width:40px; text-align:center" id="action2" >
                            <a href="#" onclick="setViewActions('delete')">Delete</a>
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
