<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>C3D Data Extract - Control Tables</title>
<link rel="stylesheet" type="text/css" href="styleSheet.css" />
<script src="script.js" type="text/javascript"></script>

<script type="text/javascript" src="prototype.js"></script>
<script type="text/javascript">

var selectedStudy;
var studyRecord;
var reportRecords;
var objectRecords;
var fileRecords;
var reportTrans=false;
var objectTrans=false;
var fileTrans=false;
var refreshWhat="ALL";
  
function AutoStart() {
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
}

function newControlData(studySelectObject){
  if (studySelectObject.options[studySelectObject.selectedIndex].value       != "Pick Study...") {
    refreshWhat="ALL";
    getControlData(document.getElementById("studyId"));
  } else {
    setStatus("You must select a valid study.");
  }
}

<s:url id="getControlData" namespace="/" action="/getControlData"/>

function getControlData(studySelectObject){
  if (studySelectObject.options[studySelectObject.selectedIndex].value       != "Pick Study...") {
    var studyId = studySelectObject.options[studySelectObject.selectedIndex].value;
    selectedStudy=studyId;
    var url = '${getControlData}';
    var myAjax = new Ajax.Request(url, {
                   method: 'get',
                   onComplete: populateControlTables,
                 parameters: 'study='+studyId+'&'+Math.random()});
  } else {
    setStatus("You must select a valid study.");
  }
}

function trim(stringToTrim) {
  return stringToTrim.replace(/^\s+|\s+$/g,"");
}

function populateControlTables(originalRequest){
  var results = originalRequest.responseText.evalJSON();
  studyRecord=results.ctExtStudyCtl;
  reportRecords=results.ctExtStudyRptCtls;
  objectRecords=results.ctExtOcObjCtls;
  fileRecords=results.ctExtFileCtls;
  
  clearStatus();
  if ((refreshWhat=="ALL") || (refreshWhat=="STUDY")) {
  displayStudyRecord();   // Study Record Display
  }
  if ((refreshWhat=="ALL") || (refreshWhat=="REPORT")) {
  displayReportRecords(); // Report Records Display
  }
  if ((refreshWhat=="ALL") || (refreshWhat=="OBJECT")) {
  displayObjectRecords(); // Object Records Display
  }
  if ((refreshWhat=="ALL") || (refreshWhat=="FILE")) {
  displayFileRecords();   // File Records Display
  }
  
}

function displayStudyRecord(){
  // Study Control Table Build (1 Record)
  var dataTable1=document.getElementById("studyControl");
  while (dataTable1.rows.length>2) //deletes all rows of a table
    dataTable1.deleteRow(2);

  var newRow=dataTable1.insertRow(-1); //add new row to end of table
  newRow.className="dataRowLight";

  var newCell=newRow.insertCell(0); //insert new cell to row
  newCell.innerHTML="&nbsp";
  newCell.style.textAlign="center";
  newCell.style.fontSize="0.7em";
  newCell.style.backgroundColor="#CCCCCC";

  var newCell=newRow.insertCell(1); //insert new cell to row
  newCell.innerHTML=studyRecord.ocObjectOwner;
  newCell.style.width="260px";
  newCell.className="dataCell2Text";
  newCell.style.fontSize="0.7em";
  newCell.style.textAlign="left";

  var newCell=newRow.insertCell(2); //insert new cell to row
  newCell.innerHTML=studyRecord.extObjectOwner;
  newCell.style.width="218px";
  newCell.className="dataCell2Text";
  newCell.style.fontSize="0.7em";
  newCell.style.textAlign="left";
    
  var newCell=newRow.insertCell(3); //insert new cell to row
  if ((studyRecord.specialLiteral == "") || (studyRecord.specialLiteral == null)) {
    newCell.innerHTML="&nbsp";
  }else{
    newCell.innerHTML=studyRecord.specialLiteral;
  }
  newCell.style.width="50px";
  newCell.className="dataCell2Text";
  newCell.style.fontSize="0.7em";
  newCell.style.textAlign="left";

  var newCell=newRow.insertCell(4); //editing fields
  newCell.innerHTML='<a href="#" onclick="setStudyActions(\'edit\')">Edt</a>';
  newCell.style.width="47px";
  newCell.style.textAlign="center";
  newCell.style.fontSize="0.7em";
  newCell.style.backgroundColor="#CCCCCC";

  var newCell=newRow.insertCell(5); //editing fields
  newCell.innerHTML='<a href="#" onclick="setStudyActions(\'delete\')">Del</a>';
  newCell.style.width="46px";
  newCell.style.textAlign="center";
  newCell.style.fontSize="0.7em";
  newCell.style.backgroundColor="#CCCCCC";

 // var newRow=dataTable1.insertRow(-1); //add new row to end of table
 // newRow.className="dataTableHeaderNoBorder";
 // var newCell=newRow.insertCell(0); //insert new cell to row
 // newCell.innerHTML="&nbsp";
 // newCell.style.textAlign="center";
 // newCell.style.fontSize="0.7em";
}

function displayReportRecords() {
  // Report Control Table Build (2 Rececords, possible more)
  var dataTable1=document.getElementById("reportTable");
  while (dataTable1.rows.length>0) //deletes all rows of a table
    dataTable1.deleteRow(0);

  var flag=true;
  for (var i=0;i<reportRecords.length;i++){
    var newRow=dataTable1.insertRow(-1); //add new row to end of table
    if(flag){
      newRow.className="dataRowLight";
    }else{
      newRow.className="dataRowDarker";
    }
    flag=!flag;

    var newCell=newRow.insertCell(0); //insert new cell to row
    newCell.innerHTML="&nbsp";
    newCell.style.textAlign="center";
    newCell.style.fontSize="0.7em";
    newCell.style.backgroundColor="#CCCCCC";
    newCell.style.width="7px";

    var newCell=newRow.insertCell(1); //insert new cell to row
    newCell.innerHTML=reportRecords[i].reportTo;
    newCell.className="dataCell2Text";
    newCell.style.fontSize="0.7em";
    newCell.style.textAlign="left";
    newCell.style.width="100px";

    var newCell=newRow.insertCell(2); //insert new cell to row
    newCell.innerHTML=reportRecords[i].version;
    newCell.className="dataCell2Text";
    newCell.style.fontSize="0.7em";
    newCell.style.textAlign="left";
    newCell.style.width="100px";
    
    var newCell=newRow.insertCell(3); //insert new cell to row
    newCell.innerHTML=reportRecords[i].reportAs;
    newCell.className="dataCell2Text";
    newCell.style.fontSize="0.7em";
    newCell.style.textAlign="left";
    newCell.style.width="100px";

    var newCell=newRow.insertCell(4); //insert new cell to row
    if (reportRecords[i].note == null) {
      newCell.innerHTML="&nbsp";
    }else{
      newCell.innerHTML=reportRecords[i].note;
    }
    newCell.className="dataCell2Text";
    newCell.style.fontSize="0.7em";
    newCell.style.textAlign="left";
    newCell.style.width="205px";

    var newCell=newRow.insertCell(5); //editing fields
    newCell.innerHTML='<a href="#" onclick="setReportActions(\'edit\',' + i +')">Edt</a>';
    newCell.style.textAlign="center";
    newCell.style.fontSize="0.7em";
    newCell.style.backgroundColor="#CCCCCC";
    newCell.style.width="80px";

    var newCell=newRow.insertCell(6); //editing fields
    newCell.innerHTML='<a href="#" onclick="setReportActions(\'delete\',' + i +')">Del</a>';
    newCell.style.textAlign="center";
    newCell.style.fontSize="0.7em";
    newCell.style.backgroundColor="#CCCCCC";
    newCell.style.width="80px";
  }
}

function setStudyActions(action){
  var dataTable1=document.getElementById("studyControl");
  var newRow=dataTable1.rows[2]; //add new row to end of table

  if (action == "delete") {
    setStatus('Select "Conf" to Confirm Delete of ' + studyRecord.ocStudy + ' Study Control Record, "Cncl" to Cancel Delete.');

    newRow.cells[4].innerHTML='<a href="#" onclick="delStudy()">Conf</a>';
    newRow.cells[5].innerHTML='<a href="#" onclick="setStudyActions(\'normal\')">Cncl</a>';
  } 
  if (action == "normal") {
      clearStatus();
  
      displayStudyRecord();
  }   
  if (action == "edit") {
    setStatus('Select "Save" to Commit changes for ' + studyRecord.ocStudy + ' Report Control Record, "Cncl" to Cancel Update.');

    newRow.cells[1].innerHTML='<input type="text" id="edtOcObjectOwner" value="'+studyRecord.ocObjectOwner+
                              '" maxlength="30" class="formFieldSizeM" style="width:260px;text-transform:uppercase;"/>';

    newRow.cells[2].innerHTML='<input type="text" id="edtExtObjectOwner" value="'+studyRecord.extObjectOwner+
                              '" maxlength="30" class="formFieldSizeM" style="width:218px;text-transform:uppercase;"/>';
      
    if (studyRecord.specialLiteral == "") {
      newRow.cells[3].innerHTML='<input type="text" id="edtSpecialLiteral" value="&nbsp" maxlength="1" ' + 
                                'class="formFieldSizeM" style="width:50px;text-transform:uppercase;"/> ';
    }else{
      newRow.cells[3].innerHTML='<input type="text" id="edtSpecialLiteral" value="'+studyRecord.specialLiteral+
                                '" maxlength="1" class="formFieldSizeM" style="width:50px;text-transform:uppercase;"/>';
    }
    newRow.cells[4].innerHTML='<a href="#" onclick="updStudy()">Save</a>';
    newRow.cells[5].innerHTML='<a href="#" onclick="setStudyActions(\'normal\')">Cncl</a>';
    document.getElementById("edtOcObjectOwner").focus();  

  }
}

function delStudy(){
  <s:url id="delStudy" namespace="/" action="/delStudy"/>

  var url = '${delStudy}';
  var myAjax = new Ajax.Request(url, {
                   method: 'get',
                   onComplete: afterDelStudy,
                   parameters: 'study='+selectedStudy+'&'+Math.random()});
}

function afterDelStudy() {

  refreshWhat="STUDY";
  getControlData(document.getElementById("studyId"));
}

function updStudy(){
  <s:url id="updStudy" namespace="/" action="/updStudy"/>

  //var select=document.getElementById("studyId");
  //var studyId = select.options[select.selectedIndex].value;
  var ocOwner=document.getElementById("edtOcObjectOwner");
  var extOwner=document.getElementById("edtExtObjectOwner");
  var spcLiteral=document.getElementById("edtSpecialLiteral");
 
  var url = '${updStudy}';
  var myAjax = new Ajax.Request(url, {
                   method: 'get',
                   onComplete: afterUpdStudy,
                   parameters: 'study='+selectedStudy+'&ocOwner='+ocOwner.value.toUpperCase()+
                               '&extOwner='+extOwner.value.toUpperCase()+
                               '&spcLiteral='+spcLiteral.value.toUpperCase()+'&'+Math.random()});
}

function afterUpdStudy(){

  refreshWhat="STUDY";
  getControlData(document.getElementById("studyId"));
  
}

//reportRecords
function setReportActions(action, record){
  var dataTable1=document.getElementById("reportTable");
  var newRow=dataTable1.rows[record]; //add new row to end of table

  if (action == "delete") {
    if (reportTrans) {
      setStatus('<b>WARNING</b>: You must complete previous Transaction first.');

    } else {
      reportTrans=true;
      setStatus('Select "Conf" to Confirm Delete of ' + selectedStudy + ' Report Control Record, "Cncl" to Cancel Delete.');

      newRow.cells[5].innerHTML='<a href="#" onclick="delReport(' + record +')">Conf</a>';
      newRow.cells[6].innerHTML='<a href="#" onclick="setReportActions(\'normal\')">Cncl</a>';
    }
  } 
  if (action == "normal") {
      clearStatus();
  
      reportTrans=false;
      displayReportRecords();
  }   
  if (action == "edit") {
    if (reportTrans) {
      setStatus('<b>WARNING</b>: You must complete previous Transaction first.');

    } else {
      reportTrans=true;
      setStatus('Select "Save" to Commit changes for ' + selectedStudy + ' Study Control Record, "Cncl" to Cancel Update.');
  
      newRow.cells[1].innerHTML='<input type="text" id="edtReportTo" value="'+reportRecords[record].reportTo +
                                '" maxlength="30" class="formFieldSizeM" style="width:100px;text-transform:uppercase;"/>';
  
      newRow.cells[2].innerHTML='<input type="text" id="edtVersion" value="'+reportRecords[record].version +
                                '" maxlength="8" class="formFieldSizeM" style="width:100px;text-transform:uppercase;"/>';
        
      newRow.cells[3].innerHTML='<input type="text" id="edtReportAs" value="'+reportRecords[record].reportAs +
                                '" maxlength="30" class="formFieldSizeM" style="width:100px;text-transform:uppercase;"/>';
        
      if ((reportRecords[record].note == "") || (reportRecords[record].note == null))  {
        newRow.cells[4].innerHTML='<input type="text" id="edtNote" value="&nbsp" maxlength="240" ' + 
                                  'class="formFieldSizeM" style="width:205px"/> ';
      }else{
        newRow.cells[4].innerHTML='<input type="text" id="edtNote" value="'+reportRecords[record].note+
                                    '" maxlength="240" class="formFieldSizeM" style="width:205px"/>';
      }
      newRow.cells[5].innerHTML='<a href="#" onclick="updReport(' + record +')">Save</a>';
      newRow.cells[6].innerHTML='<a href="#" onclick="setReportActions(\'normal\')">Cncl</a>';
      document.getElementById("edtReportTo").focus();  
    }
  }
}

function delReport(record){
  <s:url id="delReport" namespace="/" action="/delReport"/>
  reportTrans=false;

  //var select=document.getElementById("studyId");
  //var studyId = select.options[select.selectedIndex].value;
  var delReportTo=reportRecords[record].reportTo;
  var delVersion =reportRecords[record].version;
  
  var url = '${delReport}';
  var myAjax = new Ajax.Request(url, {
                   method: 'get',
                   onComplete: afterDelReport,
                   parameters: 'study='+selectedStudy+
                               '&reportTo='+reportRecords[record].reportTo+'&version='+reportRecords[record].version+'&'+Math.random()});
}

function afterDelReport() {
  refreshWhat="REPORT";
  getControlData(document.getElementById("studyId"));  
}

function updReport(record){
  <s:url id="updReport" namespace="/" action="/updReport"/>
  reportTrans=false;

  var edtReportTo= document.getElementById("edtReportTo");
  var edtVersion = document.getElementById("edtVersion");
  var edtReportAs= document.getElementById("edtReportAs");
  var edtNote    = document.getElementById("edtNote");

  var url = '${updReport}';
  var myAjax = new Ajax.Request(url, {
                   method: 'get',
                   onComplete: afterUpdReport,
                   parameters: 'study='+selectedStudy+'&reportTo='+edtReportTo.value.toUpperCase()+
                               '&version='+edtVersion.value.toUpperCase()+
                               '&reportAs='+edtReportAs.value.toUpperCase()+'&note='+edtNote.value+
                               '&keyReportTo='+reportRecords[record].reportTo+'&keyVersion='+reportRecords[record].version+'&'+Math.random()});
}

function afterUpdReport(){
  refreshWhat="REPORT";
  getControlData(document.getElementById("studyId"));
}

//objectRecords
function displayObjectRecords() {
  //
  // Object Control Table Build (5 Records, possibly more)
  var dataTable1=document.getElementById("objectsTable");
  while (dataTable1.rows.length>0) //deletes all rows of a table
    dataTable1.deleteRow(0);

  var flag=true;
  for (var i=0;i<objectRecords.length;i++){
    var newRow=dataTable1.insertRow(-1); //add new row to end of table
    if(flag){
      newRow.className="dataRowLight";
    }else{
      newRow.className="dataRowDarker";
    }
    flag=!flag;

    var newCell=newRow.insertCell(0); //insert new cell to row
    newCell.innerHTML="&nbsp";
    newCell.style.textAlign="center";
    newCell.style.fontSize="0.7em";
    newCell.style.backgroundColor="#CCCCCC";
    newCell.style.width="7px";

    var newCell=newRow.insertCell(1); //insert new cell to row
    newCell.innerHTML=objectRecords[i].synonymName;
    newCell.className="dataCell2Text";
    newCell.style.fontSize="0.7em";
    newCell.style.textAlign="left";
    newCell.style.width="175px";

    var newCell=newRow.insertCell(2); //insert new cell to row
    newCell.innerHTML=objectRecords[i].objectName;
    newCell.className="dataCell2Text";
    newCell.style.fontSize="0.7em";
    newCell.style.textAlign="left";
    newCell.style.width="175px";
    
    var newCell=newRow.insertCell(3); //insert new cell to row
    newCell.innerHTML=objectRecords[i].objectOwner;
    newCell.className="dataCell2Text";
    newCell.style.fontSize="0.7em";
    newCell.style.textAlign="left";
    newCell.style.width="90px";

    var newCell=newRow.insertCell(4); //insert new cell to row
    newCell.innerHTML=objectRecords[i].crtSeq;
    newCell.className="dataCell2Text";
    newCell.style.fontSize="0.7em";
    newCell.style.textAlign="left";
    newCell.style.width="65px";

    var newCell=newRow.insertCell(5); //editing fields
    newCell.innerHTML='<a href="#" onclick="setObjectActions(\'edit\',' + i +')">Edt</a>';
    newCell.style.textAlign="center";
    newCell.style.fontSize="0.7em";
    newCell.style.backgroundColor="#CCCCCC";
    newCell.style.width="73px";

    var newCell=newRow.insertCell(6); //editing fields
    newCell.innerHTML='<a href="#" onclick="setObjectActions(\'delete\',' + i +')">Del</a>';
    newCell.style.textAlign="center";
    newCell.style.fontSize="0.7em";
    newCell.style.backgroundColor="#CCCCCC";
    newCell.style.width="72px";
  }
}

function setObjectActions(action, record){
  var dataTable1=document.getElementById("objectsTable");
  var newRow=dataTable1.rows[record]; //add new row to end of table

  if (action == "delete") {
    if (objectTrans) {
      setStatus('<b>WARNING</b>: You must complete previous OBJECT Transaction first!');

    } else {
      objectTrans=true;
      setStatus('Select "Conf" to Confirm Delete of ' + selectedStudy + ' Object Control Record, "Cncl" to Cancel Delete.');

      newRow.cells[5].innerHTML='<a href="#" onclick="delObject(' + record +')">Conf</a>';
      newRow.cells[6].innerHTML='<a href="#" onclick="setObjectActions(\'normal\')">Cncl</a>';
    }
  } 
  if (action == "normal") {
    clearStatus();
  
    objectTrans=false;
    displayObjectRecords();
  }   
  if (action == "edit") {
    if (objectTrans) {
      setStatus('<b>WARNING</b>: You must complete previous OBJECT Transaction first!');
    } else {
      objectTrans=true;
      setStatus('Select "Save" to Commit changes for ' + selectedStudy + ' Object Control Record, "Cncl" to Cancel Update.');
  
      newRow.cells[1].innerHTML='<input type="text" id="edtSynName" value="'+objectRecords[record].synonymName +
                                '" maxlength="30" class="formFieldSizeM" style="width:175px;text-transform:uppercase;"/>';
  
      newRow.cells[2].innerHTML='<input type="text" id="edtObjectName" value="'+objectRecords[record].objectName +
                                '" maxlength="30" class="formFieldSizeM" style="width:175px;text-transform:uppercase;"/>';
        
      newRow.cells[3].innerHTML='<input type="text" id="edtObjectOwner" value="'+objectRecords[record].objectOwner +
                                '" maxlength="30" class="formFieldSizeM" style="width:90px;text-transform:uppercase;"/>';
        
      newRow.cells[4].innerHTML='<input type="text" id="edtCrtSeq" value="'+objectRecords[record].crtSeq+
                                  '" maxlength="8" class="formFieldSizeM" style="width:65px"/>';

      newRow.cells[5].innerHTML='<a href="#" onclick="updObject(' + record +')">Save</a>';
      newRow.cells[6].innerHTML='<a href="#" onclick="setObjectActions(\'normal\')">Cncl</a>';
      document.getElementById("edtSynName").focus();  
    }
  }
}

function delObject(record){
  <s:url id="delObject" namespace="/" action="/delObject"/>
  objectTrans=false;

  var url = '${delObject}';
  var myAjax = new Ajax.Request(url, {
                   method: 'get',
                   onComplete: afterDelObject,
                   parameters: 'study='+selectedStudy+
                               '&synonymName='+objectRecords[record].synonymName+'&'+Math.random()});

}

function afterDelObject() {
  refreshWhat="OBJECT";
  getControlData(document.getElementById("studyId")); 
}

function updObject(record){
  <s:url id="updObject" namespace="/" action="/updObject"/>
  objectTrans=false;

  var edtSynName=document.getElementById("edtSynName");
  var edtObjectName =document.getElementById("edtObjectName");
  var edtObjectOwner=document.getElementById("edtObjectOwner");
  var edtCrtSeq =document.getElementById("edtCrtSeq");
  
  var url = '${updObject}';
  var myAjax = new Ajax.Request(url, {
                   method: 'get',
                   onComplete: afterUpdObject,
                   parameters: 'study='+selectedStudy+'&synonymName='+edtSynName.value.toUpperCase()+
                               '&objectName='+edtObjectName.value.toUpperCase()+
                               '&objectOwner='+edtObjectOwner.value.toUpperCase()+'&crtSeq='+edtCrtSeq.value+
                               '&keySynName='+objectRecords[record].synonymName+'&'+Math.random()});

}

function afterUpdObject() {
  refreshWhat="OBJECT";
  getControlData(document.getElementById("studyId"));
  
}

//fileRecords
function displayFileRecords() {
  //
  // Files Control Table Build (5 Rececords, possibly more)
  var dataTable1=document.getElementById("filesTable");
  while (dataTable1.rows.length>0) //deletes all rows of a table
    dataTable1.deleteRow(0);

  var flag=true;
  for (var i=0;i<fileRecords.length;i++){
    var newRow=dataTable1.insertRow(-1); //add new row to end of table
    if(flag){
      newRow.className="dataRowLight";
    }else{
      newRow.className="dataRowDarker";
    }
    flag=!flag;

    var newCell=newRow.insertCell(0); //insert new cell to row
    newCell.innerHTML="&nbsp";
    newCell.style.textAlign="center";
    newCell.style.fontSize="0.7em";
    newCell.style.backgroundColor="#CCCCCC";
    newCell.style.width="7px";

    var newCell=newRow.insertCell(1); //insert new cell to row
    newCell.innerHTML=fileRecords[i].fileId;
    newCell.className="dataCell2Text";
    newCell.style.fontSize="0.7em";
    newCell.style.textAlign="left";
    newCell.style.width="140px";

    var newCell=newRow.insertCell(2); //insert new cell to row
    newCell.innerHTML=fileRecords[i].instId;
    newCell.className="dataCell2Text";
    newCell.style.fontSize="0.7em";
    newCell.style.textAlign="left";
    newCell.style.width="40px";
    
    var newCell=newRow.insertCell(3); //insert new cell to row
    newCell.innerHTML=fileRecords[i].extInd;
    newCell.className="dataCell2Text";
    newCell.style.fontSize="0.7em";
    newCell.style.textAlign="left";
    newCell.style.width="25px";

    var newCell=newRow.insertCell(4); //insert new cell to row
    newCell.innerHTML=fileRecords[i].reportTo;
    newCell.className="dataCell2Text";
    newCell.style.fontSize="0.7em";
    newCell.style.textAlign="left";
    newCell.style.width="60px";

    var newCell=newRow.insertCell(5); //insert new cell to row
    newCell.innerHTML=fileRecords[i].version;
    newCell.className="dataCell2Text";
    newCell.style.fontSize="0.7em";
    newCell.style.textAlign="left";
    newCell.style.width="50px";
    
    var newCell=newRow.insertCell(6); //insert new cell to row
    newCell.innerHTML=fileRecords[i].updLastExtDate;
    newCell.className="dataCell2Text";
    newCell.style.fontSize="0.7em";
    newCell.style.textAlign="left";
    newCell.style.width="45px";
    
    var newCell=newRow.insertCell(7); //insert new cell to row
    newCell.innerHTML=fileRecords[i].lastExtDate;
    newCell.className="dataCell2Text";
    newCell.style.fontSize="0.7em";
    newCell.style.textAlign="left";
    newCell.style.width="90px";

    var newCell=newRow.insertCell(8); //insert new cell to row
    newCell.innerHTML=fileRecords[i].currentExtDate;
    newCell.className="dataCell2Text";
    newCell.style.fontSize="0.7em";
    newCell.style.textAlign="left";
    newCell.style.width="90px";
    
    var newCell=newRow.insertCell(9); //editing fields
    newCell.innerHTML='<a href="#" onclick="setFileActions(\'edit\',' + i +')">Edt</a>';
    newCell.style.textAlign="center";
    newCell.style.fontSize="0.7em";
    newCell.style.backgroundColor="#CCCCCC";
    newCell.style.width="43px";
    
    var newCell=newRow.insertCell(10); //editing fields
    newCell.innerHTML='<a href="#" onclick="setFileActions(\'delete\',' + i +')">Del</a>';
    newCell.style.textAlign="center";
    newCell.style.fontSize="0.7em";
    newCell.style.backgroundColor="#CCCCCC";       
    newCell.style.width="44px";
        
  }
}

function setFileActions(action, record){
  var dataTable1=document.getElementById("filesTable");
  var newRow=dataTable1.rows[record]; //add new row to end of table

  if (action == "delete") {
    if (fileTrans) {
      setStatus('<b>WARNING</b>: You must complete previous FILE Transaction first!');

    } else {
      fileTrans=true;
      setStatus('Select "Conf" to Confirm Delete of ' + selectedStudy + ' File Control Record, "Cncl" to Cancel Delete.');

      newRow.cells[9].innerHTML='<a href="#" onclick="delFile(' + record +')">Conf</a>';
      newRow.cells[10].innerHTML='<a href="#" onclick="setFileActions(\'normal\')">Cncl</a>';
    }
  } 
  if (action == "normal") {
    clearStatus();
  
    displayFileRecords();
    fileTrans=false;
  }   
  if (action == "edit") {
    if (fileTrans) {
      setStatus('<b>WARNING</b>: You must complete previous FILE Transaction first!');
    } else {
      fileTrans=true;
      setStatus('Select "Save" to Commit changes for ' + selectedStudy + ' Object Control Record, "Cncl" to Cancel Update.');
  
      newRow.cells[1].innerHTML='<input type="text" id="edtFileId" value="'+fileRecords[record].fileId +
                                '" maxlength="30" class="formFieldSizeM" style="width:140px;text-transform:uppercase;"/>';
  
      newRow.cells[2].innerHTML='<input type="text" id="edtInstId" value="'+fileRecords[record].instId +
                                '" maxlength="8" class="formFieldSizeM" style="width:40px;text-transform:uppercase;"/>';
        
      newRow.cells[3].innerHTML='<input type="text" id="edtExtInd" value="'+fileRecords[record].extInd +
                                '" maxlength="1" class="formFieldSizeM" style="width:25px;text-transform:uppercase;"/>';
        
      newRow.cells[4].innerHTML='<input type="text" id="edtReporTo" value="'+fileRecords[record].reportTo+
                                  '" maxlength="30" class="formFieldSizeM" style="width:60px;text-transform:uppercase;"/>';

      newRow.cells[5].innerHTML='<input type="text" id="edtVersion" value="'+fileRecords[record].version+
                                  '" maxlength="8" class="formFieldSizeM" style="width:50px;text-transform:uppercase;"/>';

      newRow.cells[6].innerHTML='<input type="text" id="edtupdLastExtDate" value="'+fileRecords[record].updLastExtDate+
                                  '" maxlength="1" class="formFieldSizeM" style="width:45px"/>';

      newRow.cells[9].innerHTML='<a href="#" onclick="updFile(' + record +')">Save</a>';
      newRow.cells[10].innerHTML='<a href="#" onclick="setFileActions(\'normal\')">Cncl</a>';
      document.getElementById("edtSynName").focus();  
    }  
  }
}

function delFile(record){
  <s:url id="delFile" namespace="/" action="/delFile"/>
  fileTrans=false;

  var url = '${delFile}';
  var myAjax = new Ajax.Request(url, {
                   method: 'get',
                   onComplete: afterDelFile,
                   parameters: 'study='+selectedStudy+
                               '&fileId='+fileRecords[record].fileId+'&'+Math.random()});

}

function afterDelFile() {
  refreshWhat="FILE";
  getControlData(document.getElementById("studyId")); 
}

function updFile(record){
  <s:url id="updFile" namespace="/" action="/updFile"/>
  fileTrans=false;

  var edtFileId=document.getElementById("edtFileId");
  var edtInstId =document.getElementById("edtInstId");
  var edtExtInd=document.getElementById("edtExtInd");
  var edtReporTo =document.getElementById("edtReporTo");
  var edtVersion=document.getElementById("edtVersion");
  var edtupdLastExtDate =document.getElementById("edtupdLastExtDate");
  
  var url = '${updFile}';
  var myAjax = new Ajax.Request(url, {
                   method: 'get',
                   onComplete: afterUpdFile,
                   parameters: 'study='+selectedStudy+'&fileId='+edtFileId.value.toUpperCase()+
                               '&instId='+edtInstId.value.toUpperCase()+
                               '&extInd='+edtExtInd.value.toUpperCase()+'&reportTo='+edtReporTo.value.toUpperCase()+
                               '&version='+edtVersion.value.toUpperCase()+'&updLastExtDate='+edtupdLastExtDate.value+
                               '&keyFileId='+fileRecords[record].fileId+'&'+Math.random()});

}

function afterUpdFile() {
  refreshWhat="FILE";
  getControlData(document.getElementById("studyId"));
}

//

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
	        <!--  <table summary="" cellpadding="0" cellspacing="0" border="0" height="20">-->
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
                              <td style="text-align:center; margin-bottom: 9px; color:black; font-size:2em; font-weight:bold">Control Tables</td>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <!-- Study Selector -->
                      <table class="formSimpleBox" cellpadding="6" cellspacing="0" border="0" 
                             style=" width:706;border:1px solid black; border-bottom: 0px; margin-left: 5px;">
		        <tr>
		          <td width=20pt style="text-align:right;" >
			    <label  for="studyId">Study</label>
			  </td>
		          <td>
                            <select class="formFieldSizeM"  id="studyId" name="studyId" 
                                    onChange="newControlData(this)">
                            </select>
			  </td>
                        </tr>
		        <tr>
		        </tr>
                       </table>
                      <!-- Study Control -->
                      <table id="studyControl" style=" width:706;border:1px solid black; border-bottom: 0px;
		      		 border-collapse:collapse; background-color:#CCCCCC;margin-left: 5px;">
		        <tr class="dataTableHeaderNoBorder">
		          <th colspan="6" style="padding-left:10; padding-bottom: 6px;text-align:left;" >Extract Study Control [CT_EXT_STUDY_CTL]</th>
                        </tr>
                        <tr class="dataTableHeaderNoBorder">
		          <th style="width:10;padding: 0px;text-align:left;" >&nbsp</th>
		          <th style="width:260;padding: 0px;text-align:left;" >Object Owner</th>
		          <th style="width:218;padding: 0px;text-align:left;" >EXT Object Owner</th>
		          <th style="width:50;padding: 0px;text-align:left;" >Literal</th>
		          <th colspan="2" style="padding: 0px;text-align:center;" >Actions</th>
		          <!--<th style="width:60;padding: 0px;text-align:left;" >&nbsp</th>-->
                        </tr>
                        <tr class="dataRowLight">
		          <th style="width:10;padding: 0px;text-align:left;" >&nbsp</th>
                          <td style="width:260;text-align:left;  font-size:0.7em;">&nbsp</td>
                          <td style="width:218;text-align:left;  font-size:0.7em;">&nbsp</td>
                          <td style="width:50;text-align:left;  font-size:0.7em;">&nbsp</td>
                          <td style="width:47;text-align:left;  font-size:0.7em;">&nbsp</td>
                          <td style="width:46;text-align:left;  font-size:0.7em;">&nbsp</td>
	                 </tr>
                       </table>
		       <!-- REPORT TABLE-->
                       <div style="width:770px;overflow:auto;">
		         <table class="dataTable" style=" width:700;border:1px solid black; border-bottom: 0px;
		      		             background-color:#CCCCCC;margin-left:5px;">
		           <tr>
		             <td class="dataTableHeader" style="border-bottom-width: 0px; border-right-width: 0px; padding: 0px;">
		      	      <table style="width: 700px;">
		                <tr class="dataTableHeaderNoBorder">
                                  <th colspan="6" style="padding-left:7; padding-bottom:6px; text-align:left;" >Report Control [CT_EXT_STUDY_RPT_CTL]</th>
                                </tr>
		                <tr class="dataTableHeaderNoBorder">
                                  <th style="width:7;padding: 0px;text-align:left;" >&nbsp</th>
                                  <th style="padding: 0px;text-align:left;width:103px;" >Report To</th>
                                  <th style="padding: 0px;text-align:left;width:103px;" >Version</th>
                                  <th style="padding: 0px;text-align:left;width:103px;" >Report As</th>
                                  <th style="padding: 0px;text-align:left;width:210px;" >Note</th>
                                  <th colspan="2" style="padding: 0px;text-align:center;" >Actions</th>
                                </tr>
                              </table>
                            </td>
                          </tr>
                          <tr>
		            <td style="padding: 0px">
		              <div style="width:700px; min-height:30px; max-height:50px; overflow:auto; border-width: 0px; border-style: solid;">
		                <table id="reportTable" 
		                    style="width: 700px; border-width: 0px; border-style: solid; border-spacing: 1pt; border-color:black;
		                           table-layout:fixed; white-space:nowrap; overflow:hidden; border-collapse:collapse;">
		                  <tr class="dataRowLight">
                                    <!--<td style="padding: 0px;text-align:left;" >&nbsp</td>-->
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
		                  </tr>
		                  <tr class="dataRowDarker">
                                    <!--<td style="padding: 0px;text-align:left;" >&nbsp</td>-->
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
		                  </tr>
		      		</table>
		      	      </div>
		            </td>  
		      	  </tr>
		                        
		        </table>
		                            
                    </div>
		       <!-- OBJECTS TABLE-->
                       <div style="width:770px;overflow:auto;">
		         <table class="dataTable" style=" width:706px;border:1px solid black; border-bottom: 0px;
		      		             background-color:#CCCCCC;margin-left: 5px;">
		           <tr>
		             <td class="dataTableHeader" style="border-bottom-width: 0px; border-right-width: 0px; padding: 0px;">
		      	      <table style="width: 698px;">
		                <tr class="dataTableHeaderNoBorder">
                                  <th colspan="7" style="padding-left:7px; padding-bottom:6px; text-align:left;">Object Control [CT_EXT_OC_OBJ_CTL]</th>
                                </tr>
		                <tr class="dataTableHeaderNoBorder">
                                  <th style="width:7px; padding: 0px;text-align:left;" >&nbsp</th>
                                  <th style="width:178px; padding: 0px;text-align:left;" >Synonym Name</th>
                                  <th style="width:178px; padding: 0px;text-align:left;" >Object Name</th>
                                  <th style="width:93px; padding: 0px;text-align:left;" >Object Owner</th>
                                  <th style="width:68px; padding: 0px;text-align:left;" >Create Seq</th>
                                  <th colspan="2" style="padding: 0px;text-align:center;" >Actions</th>
                                </tr>
                              </table>
                            </td>
                          </tr>
                          <tr>
		            <td style="padding: 0px; padding-bottom:5px;">
		              <div style="width:698px;height:60px; min-height:30px; max-height:60px; overflow-y:auto; border-width: 1px; 
		                          border-style:solid; padding-bottom:2px; padding-top:2px;">
		                <table id="objectsTable" 
		                    style="width: 674px; border-width: 0px; border-style: solid; border-spacing: 1pt; border-color:black; 
		                           table-layout:fixed; white-space:nowrap; overflow:hidden; border-collapse:collapse;">
		                  <tr class="dataRowLight">
                                    <td style="padding: 0px;text-align:left;" >&nbsp</th>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</th>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</th>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</th>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</th>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</th>
		                  </tr>
		                  <tr class="dataRowDarker">
                                    <td style="padding: 0px;text-align:left;" >&nbsp</th>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</th>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</th>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</th>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</th>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</th>
		                  </tr>
		                  <tr class="dataRowLight">
                                    <td style="padding: 0px;text-align:left;" >&nbsp</th>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</th>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</th>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</th>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</th>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</th>
		                  </tr>
		      		</table>
		      	      </div>
		            </td>  
		      	  </tr>
		        </table>
		                            
                    </div>
		       <!-- FILES TABLE-->
                       <div style="width:770px;overflow:auto;">
		         <table class="dataTable" style="width:706; border:1px solid black; background-color:#CCCCCC; margin-left:5px;">
		           <tr>
		             <td class="dataTableHeader" style="border-width: 0px; padding: 0px;">
		      	      <table style="width: 696px;">
		                <tr class="dataTableHeaderNoBorder">
                                  <th colspan="7" style="padding-left:7px;padding-bottom:6px; text-align:left;">File Control [CT_EXT_FILE_CTL]</th>
                                </tr>
		                <tr class="dataTableHeaderNoBorder">
                                  <th style="width:7px;padding: 0px;text-align:left;" >&nbsp</th>
                                  <th style="width:143px;padding: 0px;text-align:left;" >&nbsp</th>
                                  <th style="width:43px;padding: 0px;text-align:left;" >&nbsp</th>
                                  <th style="width:28px;padding: 0px;text-align:center;" >Extr</th>
                                  <th style="width:63px;padding: 0px;text-align:left;" >&nbsp</th>
                                  <th style="width:53px;padding: 0px;text-align:left;" >&nbsp</th>
                                  <th style="width:48px;padding: 0px;text-align:center;" >Upd Last</th>
                                  <th style="width:98px;padding: 0px;text-align:center;" >Last Extract</th>
                                  <th style="width:93px;padding: 0px;text-align:center;" >Current Extract</th>
                                  <th colspan="2" style="width:98; padding: 0px;text-align:center;" >&nbsp</th>
                                </tr>
		                <tr class="dataTableHeaderNoBorder">
                                  <th style="width:7px;padding: 0px;text-align:left;" >&nbsp</th>
                                  <th style="width:143px;padding: 0px;text-align:left;" >File ID</th>
                                  <th style="width:43px;padding: 0px;text-align:left;" >Inst ID</th>
                                  <th style="width:28px;padding: 0px;text-align:center;" >Ind</th>
                                  <th style="width:63px;padding: 0px;text-align:left;" >Report To</th>
                                  <th style="width:53px;padding: 0px;text-align:left;" >Version</th>
                                  <th style="width:48px;padding: 0px;text-align:center;" >Ext Date</th>
                                  <th style="width:98px;padding: 0px;text-align:center;" >Date</th>
                                  <th style="width:93px;padding: 0px;text-align:center;" >Date</th>
                                  <th colspan="2" style="width:98; padding: 0px;text-align:center;" >Actions</th>
                                </tr>
                              </table>
                            </td>
                          </tr>
                          <tr>
		            <td style="padding-bottom: 5px;">
		              <div style="width:696px; height:130px; min-height:30px;max-height:130px; overflow:auto; border-width: 1px; 
		                          border-style: solid;padding-top:2px; padding-bottom:2px">
		                <table id="filesTable" 
		                    style="width: 674px; border-width: 0px; border-style: solid; border-spacing: 1pt; border-collapse:collapse;
		                           table-layout:fixed; white-space:nowrap; overflow:hidden; border-color:black" >
		                  <tr class="dataRowLight">
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
		                  </tr>
		                  <tr class="dataRowDarker">
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
		                  </tr>
		                  <tr class="dataRowLight">
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
		                  </tr>
		                  <tr class="dataRowDarker">
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
		                  </tr>
		                  <tr class="dataRowLight">
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
		                  </tr>
		                  <tr class="dataRowDarker">
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
                                    <td style="padding: 0px;text-align:left;" >&nbsp</td>
		                  </tr>
		      		</table>
		      	      </div>
		            </td>  
		      	  </tr>
		        </table>
		                            
                    </div>
                    <table style="width: 700px;">
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
