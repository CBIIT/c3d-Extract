<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>C3D Data Extract - Application Security</title>
<link rel="stylesheet" type="text/css" href="styleSheet.css" />
<script src="script.js" type="text/javascript"></script>

<script type="text/javascript" src="prototype.js"></script>
<script type="text/javascript">


var isAdding;
var delUsers;
function AutoStart() {
    getSecurity();
}

function setStatus(msg){
  document.getElementById("statusText").innerHTML=msg;
}

function clearStatus(){
  document.getElementById("statusText").innerHTML="&nbsp";
}


function getSecurity(){
  <s:url id="querySecurity" namespace="/" action="/getValidUsers"/>
  var url = '${querySecurity}';
  var myAjax = new Ajax.Request(url, {
               method: 'get',
               onComplete: populateSecurityTable,
               parameters: '?'+Math.random()});
}

function populateSecurityTable(originalRequest){
  //setStatus("Starting LOV Populate for Study");
  //clearStatus();
  isAdding=false;
  var results = originalRequest.responseText.evalJSON();
  
  var dataTable1=document.getElementById("securityTable");
  while (dataTable1.rows.length>0) //deletes all rows of a table
    dataTable1.deleteRow(0);
    
  var flag=true;
  for (var i=0;i<results.users.length;i++){
    var newRow=dataTable1.insertRow(-1); //add new row to end of table
    if(flag){
      newRow.className="dataRowLight";
    }else{
      newRow.className="dataRowDarker";
    }
    flag=!flag;
    
    var newCell=newRow.insertCell(0); //insert new cell to row
    newCell.innerHTML='<input type="checkbox" id="selectedId" name="selectedId" />';
    newCell.style.width="60px";
    newCell.style.fontSize="0.7em";
    newCell.style.textAlign="center"
      
    var newCell=newRow.insertCell(1); //insert new cell to row
    newCell.innerHTML=results.users[i];
    newCell.colSpan="5";
    newCell.style.textSlign="left";
    newCell.style.fontSize="0.7em";
  }
  dataTable1.scrollIntoView(true);  
}


function addUser(){
  //setStatus("Starting LOV Populate for Study");
  //var results = originalRequest.responseText.evalJSON();
  clearStatus();
  
  if (isAdding) {
     setStatus("<b>WARNING: Complete previous 'Add New' first.</b>");
  }else{
  
    var dataTable1=document.getElementById("securityTable");
    
    isAdding=true;
    var newRow=dataTable1.insertRow(0); //add new row to end of table
    newRow.className="dataRowDarker";
    
    var newCell=newRow.insertCell(0); //insert new cell to row
    newCell.innerHTML='<input type="checkbox" id="selectedId" name="selectedId" disabled="true" />';
    newCell.style.width="60px";
    newCell.style.fontSize="0.7em";
    newCell.style.textAlign="center"
      
    var newCell=newRow.insertCell(1); //insert new cell to row
    newCell.innerHTML='<input style=text-transform:uppercase;" type="text" id="userId" name="userId" />';
    newCell.colSpan="3";    
    newCell.style.textSlign="left";
    newCell.style.fontSize="0.7em";

    var newCell=newRow.insertCell(2); //insert new cell to row
    newCell.innerHTML='<a href="#" onclick="commitUser()">Save</a>';
    newCell.style.textSlign="rigth";
    newCell.style.fontSize="0.7em";
    
    var newCell=newRow.insertCell(3); //insert new cell to row
    newCell.innerHTML='<a href="#" onclick="getSecurity()">Cancel</a>';
    newCell.style.textSlign="right";
    newCell.style.fontSize="0.7em";
  
    document.getElementById("userId").focus();  
    }
}

<s:url id="addUserUrl" namespace="/" action="/addValidUser"/>

function commitUser(){
  var url = '${addUserUrl}';

  var vUser=document.getElementById("userId").value;
  
  vUser = vUser.toUpperCase();
  setStatus("Adding user " + vUser);

  var myAjax = new Ajax.Request(url, {
               method: 'get',
               onComplete: userActionResults,
               parameters: 'username='+vUser+'&'+Math.random()});
               
}

<s:url id="deleteUserUrl" namespace="/" action="/deleteValidUser"/>

function deleteUser(){
  var url = '${deleteUserUrl}';
  delUsers = "";
  var foundOne = false;

  var dataTable1=document.getElementById("securityTable");
  for (var i=0; i < dataTable1.rows.length; i++) { //check rows for checkbox
    var row   = dataTable1.rows[i];
    var elemt = row.cells[0];
    if (elemt.childNodes[0].type == "checkbox") {
      if (elemt.childNodes[0].checked) {
        foundOne = true;
        var elemt2 = row.cells[1].childNodes[0].data;
        elemt2 = elemt2.toUpperCase();
        var myAjax = new Ajax.Request(url, {
            method: 'post',
            onComplete: deleteActionResults(elemt2),
            parameters: 'username='+elemt2+'&'+Math.random()});

      }
    }
  }
  if (!(foundOne)) {
    setStatus("<b>No users deleted, nothing selected.</b>");
  }else{
    setStatus("<b>Success: Deleted the following User IDs: " + delUsers + ".</b>");
  }
  getSecurity();               
}

function userActionResults(originalRequest){
  //setStatus("Starting LOV Populate for Study");
  clearStatus();
  isAdding=false;
  var results = originalRequest.responseText.evalJSON();
  
  setStatus("<b>" + results.statusText + "</b>");
  if (results.status) {
    isAdding = false;
    getSecurity();
  }
}

function deleteActionResults(user){
  //setStatus("Starting LOV Populate for Study");
  if (delUsers == "") {
    delUsers = user;  
  }else{
    delUsers = delUsers + ', ' + user;
  }

}
  
function doRefresh() {
  clearStatus();
  getSecurity();
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
                              <td style="text-align:center; margin-bottom: 9px; color:black; font-size:2em; font-weight:bold">Application Security</td>
                            </table>
                          </td>
                        </tr>
                      </table>
                       <div style="width:770px;overflow:auto;">
		       <!-- LEFT TABLE-->
		         <table class="dataTable" style=" width:380;border:1px solid black;
		      		             background-color:#CCCCCC;margin-left: 5px;">
		           <tr>
		             <td class="dataTableHeader" style="border-bottom-width: 0px; border-right-width: 0px; padding: 0px;">
		      	      <table style="width: 354px;">
		                <tr>
		                  <td style="font-size:0.7em;padding:0px;text-align:left;padding-left: 6px;">
		                    <a href="#" onclick="deleteUser()">Delete</a>
		                  </td>
		                  <td style="padding: 6px;text-align:right;">&nbsp</td>
		                  <td style="padding: 6px;text-align:right;">&nbsp</td>
		                  <td style="padding: 6px;text-align:right;">&nbsp</td>
		                  <td style="padding: 6px;text-align:right;">&nbsp</td>
		                  <td  style="font-size:0.7em;padding:0px;text-align:right;padding-left: 6px;">
		                    <a href="#" onclick="addUser()">Add New<a/>
		                  </td>
		                </tr>
                                <tr class="dataTableHeaderNoBorder">
                                  <th style="width:60;padding: 0px;text-align:left;" ></th>
                                  <th colspan="5" style=" padding: 0px;text-align:left;">User ID</th>
                                </tr>
                              </table>
                            </td>
                          </tr>
                          <tr>
		            <td style="padding: 0px">
		              <div style="width:380px; height:350px; overflow:auto; border-width: 1px; border-style: solid;">
		                <table id="securityTable" 
		                    style="width: 354px; border-width: 1px; border-style: solid; border-spacing: 0pt; 
		                           table-layout:fixed; white-space:nowrap; overflow:hidden">
		                  <tr class="dataRowLight">
		                    <td style="width:60;text-align:left;  font-size:0.7em;">
		                      <input type="checkbox" id="selectedId" name="selectedId" />
		                    </td>
		                    <td class="dataCell2Text" >&nbsp</td>
		                  </tr>
		      		</table>
		      	      </div>
		            </td>  
		      	  </tr>
		          <tr>
		            <td class="dataTableHeader" style="border-bottom-width: 0px; border-right-width: 0px; padding: 0px;">
		      	      <table style="width: 354px;">
		      	        <tr>
		      	          <td style="font-size:0.7em;padding:0px;text-align:center;padding-left: 6px;">
		      	            <a href="#" id="overallExtStatId" onclick="doRefresh()">Refresh<a/>
		      	          </td>
		      	        </tr>
		      	      </table>
		      	    </td>
	                  </tr>
                 
		        </table>
		                            
                    </div>
                    <table style="width: 354px;">
                      <tr>
		        <td colspan="5" style="text-align:left">
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
