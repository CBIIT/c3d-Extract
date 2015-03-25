<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<title>Home</title>
<link rel="stylesheet" type="text/css" href="styleSheet.css" />
<script src="script.js" type="text/javascript"></script>
</head>
<body>
<table summary="" cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">

	<!-- nci hdr begins -->
  <tr>
    <td>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="hdrBG">
        <tr>
          <td width="283" height="37" align="left"><a href="http://www.cancer.gov"><img alt="National Cancer Institute" src="images/logotype.gif" width="283" height="37" border="0"></a></td>
          <td>&nbsp;</td>
          <td width="295" height="37" align="right"><a href="http://www.cancer.gov"><img alt="U.S. National Institutes of Health | www.cancer.gov" src="images/tagline.gif" width="295" height="37" border="0"></a></td>
        </tr>
      </table>
    </td>
  </tr>
  <!-- nci hdr ends -->
	
  <tr>
    <td height="100%" align="center" valign="top">
      <table summary="" cellpadding="0" cellspacing="0" border="0" height="100%" width="771">
      <!-- application hdr begins -->
        <!-- REMOVED AppLogo Header
        <tr>
	  <td height="50">
	    <table width="100%" height="50" border="0" cellspacing="0" cellpadding="0" class="subhdrBG">
	      <tr>
	        <td height="50" align="left">
	          <a href="#">
	            <img src="images/AppLogo.jpeg" alt="Application Logo" hspace="10" border="0">
	          </a>
	        </td>
	      </tr>
	    </table>
	  </td>
	</tr>
	REMOVED AppLogo Header -->
	<!-- application hdr ends -->
        <tr>
          <td valign="top">
            <table summary="" cellpadding="0" cellspacing="0" border="0" height="100%" width="100%">
              <!-- Removed LINKS Section, NOT NEEDED on LOGIN PAGE -->
              
              <!--_____ main content begins _____-->
              <tr>
                <td valign="top">
                  <!-- target of anchor to skip menus -->
                  <a name="content"> </a>
                  <table summary="" cellpadding="0" cellspacing="0" border="0" class="contentPage" width="100%" height="100%">
                    <!-- banner begins -->
                    <tr>
                      <td class="bannerHome"><img src="images/LogonBanner.jpeg" height="140" width="100%"></td>
                    </tr>
                    <!-- banner begins -->
                    <tr>
                      <td height="100%">
                  	<!-- target of anchor to skip menus -->
			<a name="content"> </a>
                        <table summary="" cellpadding="0" cellspacing="0" border="0" height="100%">
                          <tr>
                            <td width="70%">
                              <!-- welcome begins -->
                              <table summary="" cellpadding="0" cellspacing="0" border="0" height="100%">
                                <tr>
                                   <td class="welcomeTitle" height="20">WELCOME TO C3D CTMS/CDUS DATA EXTRACTOR</td>
                                </tr>
                                <tr>
                                  <td class="welcomeContent" valign="top">
                                    The Data Extract Application is used to pull data out of Oracle Clinical and prepare it 
                                    for reporting in either THERADEX or CDUS formats.  The application allows for the creation,
                                    maintenance and execution of Study specific objects, views and cursors based upon a template 
                                    structure.<br /><br />
                                    Before running the Data Extract Application, make sure the last Oracle Clinical Batch 
                                    Validation for the study is successful, and then generate snapshot views.<br /><br />
				    
				    To generate snapshot views, login to OPA and traverse the process tree to:<br />
				    Conduct->Data Extract->Study Access Account<br />
				    When generating the Snapshot views, make sure to use the last BV timestamp for both 
				    Last Batch TS and RDCM Accessible TD End Date. Once the Snapshot views are generated,  log in 
				    to Data Extract Application.<br /><br />
				    You must have a valid Oracle Clinical (C3D) account that has been granted the ability to perform Data Extracts.
                                  </td>
                                </tr>
                              </table>
                              <!-- welcome ends -->
                            </td>
                            <td valign="top" width="30%">
                              <!-- sidebar begins -->
                              <table summary="" cellpadding="0" cellspacing="0" border="0" height="100%">
                                <!-- login begins -->
                                <tr>
                                  <td valign="top">
                                    <table summary="" cellpadding="2" cellspacing="0" border="0" width="100%" class="sidebarSection">
                                      <tr>
                                        <td class="sidebarTitle" height="20">LOGIN TO DATA EXTRACTOR</td>
                                      </tr>
                                      <tr>
                                        <td class="sidebarContent">
                                        <!--<form id="loginForm" name="loginForm" method="post" action="Login" >-->
                                          <!--<table cellpadding="2" cellspacing="0" border="0">-->
                                            <!--<tr>
                                              <td class="sidebarLogin" align="right"><label for="userName">LOGIN ID</label></td>
                                              <td class="formFieldLogin"><input class="formField" type="text" name="userName" size="14" /></td>
                                            </tr>
                                            <tr>
                                              <td class="sidebarLogin" align="right"><label for="password">PASSWORD</label></td>
                                              <td class="formFieldLogin"><input class="formField" type="password" name="password" size="14" /></td>
                                            </tr>
                                            <tr>
                                              <td class="sidebarLogin" align="right"><label for="dbsid">DB SID</label></td>
                                              <td class="formFieldLogin"><input class="formField" type="dbsid" name="dbsid" size="14" /></td>
                                            </tr>
                                            <tr>
                                              <td>&nbsp;</td>
                                              <td><input type="submit" value="Login" /></td>
                                            </tr> -->
                                          <!--</table>-->
                                        <!--</form>-->
                                        <s:form action="Login">
                                              <s:textfield name="userName" label="LOGIN ID" cssClass="formField" required="true" size="14"/>
                                              <s:password name="password" label="PASSWORD"  cssClass="formField" required="true" size="14"/>
                                              <s:textfield name="dbSid" label="DB SID" cssClass="formField" required="true" size="14"/>
                                              <s:submit value="Login" />                                              
                                        </s:form>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                                <!-- login ends -->
                                
                                <!-- what's new REMOVED -->
                                
                                <!-- did you know? REMOVED -->
                                
                                <!-- spacer cell begins (keep for dynamic expanding) -->
                                <tr><td valign="top" height="100%">
                                    <table summary="" cellpadding="0" cellspacing="0" border="0" width="100%" height="100%" class="sidebarSection">
                                    <tr>
                                      <td class="sidebarContent" valign="top">&nbsp;</td>
                                    </tr>
                                    </table>
																</td></tr>
                                <!-- spacer cell ends -->
																
                              </table>
                              <!-- sidebar ends -->
                              
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
                <td height="20" class="footerMenu">
                
                  <!-- application ftr begins -->
                  <table summary="" cellpadding="0" cellspacing="0" border="0" width="100%">
                    <tr>
                      <td align="center" height="20" class="footerMenuItem" onmouseover="changeMenuStyle(this,'footerMenuItemOver'),showCursor()" onmouseout="changeMenuStyle(this,'footerMenuItem'),hideCursor()" onclick="document.location.href='#'">
                        &nbsp;&nbsp;<a class="footerMenuLink" href="#">CONTACT US</a>&nbsp;&nbsp;
                      </td>
                      <td><img src="images/ftrMenuSeparator.gif" width="1" height="16" alt="" /></td>
                      <td align="center" height="20" class="footerMenuItem" onmouseover="changeMenuStyle(this,'footerMenuItemOver'),showCursor()" onmouseout="changeMenuStyle(this,'footerMenuItem'),hideCursor()" onclick="document.location.href='#'">
                        &nbsp;&nbsp;<a class="footerMenuLink" href="#">PRIVACY NOTICE</a>&nbsp;&nbsp;
                      </td>
                      <td><img src="images/ftrMenuSeparator.gif" width="1" height="16" alt="" /></td>
                      <td align="center" height="20" class="footerMenuItem" onmouseover="changeMenuStyle(this,'footerMenuItemOver'),showCursor()" onmouseout="changeMenuStyle(this,'footerMenuItem'),hideCursor()" onclick="document.location.href='#'">
                        &nbsp;&nbsp;<a class="footerMenuLink" href="#">DISCLAIMER</a>&nbsp;&nbsp;
                      </td>
                      <td><img src="images/ftrMenuSeparator.gif" width="1" height="16" alt="" /></td>
                      <td align="center" height="20" class="footerMenuItem" onmouseover="changeMenuStyle(this,'footerMenuItemOver'),showCursor()" onmouseout="changeMenuStyle(this,'footerMenuItem'),hideCursor()" onclick="document.location.href='#'">
                        &nbsp;&nbsp;<a class="footerMenuLink" href="#">ACCESSIBILITY</a>&nbsp;&nbsp;
                      </td>
                      <td><img src="images/ftrMenuSeparator.gif" width="1" height="16" alt="" /></td>
                      <td align="center" height="20" class="footerMenuItem" onmouseover="changeMenuStyle(this,'footerMenuItemOver'),showCursor()" onmouseout="changeMenuStyle(this,'footerMenuItem'),hideCursor()" onclick="document.location.href='#'">
                        &nbsp;&nbsp;<a class="footerMenuLink" href="#">APPLICATION SUPPORT</a>&nbsp;&nbsp;
                      </td>
                    </tr>
                  </table>
                  <!-- application ftr ends -->
                  
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td>
    
      <!-- footer begins -->
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="ftrTable">
        <tr>
          <td valign="top">
            <div align="center">
              <a href="http://www.cancer.gov/"><img src="images/footer_nci.gif" width="63" height="31" alt="National Cancer Institute" border="0"></a>
              <a href="http://www.dhhs.gov/"><img src="images/footer_hhs.gif" width="39" height="31" alt="Department of Health and Human Services" border="0"></a>
              <a href="http://www.nih.gov/"><img src="images/footer_nih.gif" width="46" height="31" alt="National Institutes of Health" border="0"></a>
              <a href="http://www.firstgov.gov/"><img src="images/footer_firstgov.gif" width="91" height="31" alt="FirstGov.gov" border="0"></a>
            </div>
          </td>
        </tr>
      </table>
      <!-- footer ends -->
    
    </td>
  </tr>
</table>
</body>
</html>
