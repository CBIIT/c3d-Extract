<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>C3D Data Extract - Refresh Views</title>
<link rel="stylesheet" type="text/css" href="styleSheet.css" />
<script src="script.js" type="text/javascript"></script>

<script type="text/javascript" src="prototype.js"></script>
<script type="text/javascript">


var studyId;

function AutoStart() {
    getStudyIds();
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
    fieldValue += "<br>" + inText;
  }
  
  cleanFieldMsg();
  document.getElementById("statusField").innerHTML = fieldValue;
  //document.getElementById("statusField").value = fieldValue;
}    

function cleanFieldMsg() {
  document.getElementById("statusField").innerHTML="&nbsp";
}    

function refreshStudyViews(){
  cleanFieldMsg();
  document.getElementById("newStudyStatus").innerHTML = "<b>IN PROCESS</b>";
  addFieldMsg("<b>In Process...</b><br>");
  setCursor("wait");
  var selStudy = document.getElementById("studyId");
  var studyId  = selStudy.options[selStudy.selectedIndex].value;
  var version = "null";
  var failed = false;
  if ((studyId == "" ) || (studyId == "Pick Study...")) {
    addFieldMsg("<b>ERROR:</b> A Study must be selected.");
    failed = true;
  } 
  if (failed) {
    addFieldMsg("<br><b>Refresh Study Views Failed, see above.</b>");
    document.getElementById("newStudyStatus").innerHTML = "<b>FAILED</b>";
    setCursor("default");
  } else {
    addFieldMsg("Setting up Study Extract Views...");

    <s:url id="createStudyVw" namespace="/" action="/createStudyVw"/>
    
    var url = '${createStudyVw}';
    var myAjax = new Ajax.Request(url, {
                 method: 'get',
                 onComplete: completeStudyRefresh,
                 parameters: 'newStudy='+studyId+'&newVersion='+version+'&'+Math.random()});
      
  }
}

function completeStudyRefresh(originalRequest){
  var result = originalRequest.responseText.evalJSON();

  var valid = result.valid;
  if (!(valid)) {
    addFieldMsg(result.validateText);
    addFieldMsg("Setting up Study Extract Views...<b>FAILED<b/>");
    document.getElementById("newStudyStatus").innerHTML = "FAILED";

  } else {
    addFieldMsg("Setting up Study Extract Views...<b>COMPLETE<b/>");
  
    addFieldMsg("<br/>Refresh Study Views <b>SUCCESS<b/>!");
    document.getElementById("newStudyStatus").innerHTML = "SUCCESS";
  }
  setCursor("default");
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
                              <td style="text-align:center; margin-bottom: 9px; color:black; font-size:2em; font-weight:bold">Refresh Extract Views</td>
                            </table>
                            <table class="formSimpleBox" summary="" cellpadding="6" cellspacing="0" border="0" align="center"
                                width="100%" height="100%">
			      <tr>
			        <td colspan="4" style="text-align:center">Study:
			          <select class="formFieldSizeM"  id="studyId" name="studyId">
			    	  </select>
			        </td>
	                      </tr>
			      <tr>
			        <td colspan="4" style="padding:8px;text-align:center">
 			          <input type="button" class="formFieldSizeM" style="width:14em"
 			            id="createNewStudyId" name="createNewStudyId"
 			            value="Refresh Study Views" onclick="refreshStudyViews()"/>
 			        </td>
	                      </tr>
			      <tr>
			        <td style="padding:6px;border-top:1px solid #5C5C5C;border-bottom:1px solid #5C5C5C;">Overall Status:</td>
			        <td colspan="3" style="padding:6px;border-top:1px solid #5C5C5C;border-bottom:1px solid #5C5C5C; width:564px;">
			           <span id="newStudyStatus">&nbsp;</span>
			        </td>
	                      </tr>
			      <tr>
			        <td colspan="4" >Status Detail:</td>
	                      </tr>
			      <tr>
			        <td colspan="4" style="vertical-align: top; max-height: 200px; height: 200px; padding-left:25px;padding-bottom:6px;">
                                  <span name="statusField" id="statusField" style="overflow: auto;text-align: left; max-width: 564px;">
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
