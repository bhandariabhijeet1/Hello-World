public class RequirementController{ 
    
    public Module__c modname{get;set;}
    public Defect__c defectname{get;set;}
    public TestCase__c testcaseInstance{get;set;}
    public TestCase__c tobeEdited2{get;set;}
    public Requirement__c reqIns1{get;set;}  
    
    public string currentProjectID{get;set;}
    public string url {get;set;}//for defectsattachment
    public string defectAttachId {get;set;}
    public string selectedAttachmentId{get;set;}//for defectsattachment
    public string referedTestObjId{get;set;}
    public string referedTestBuildObjId{get;set;}
    public String SelectedModuleName{get;set;}
    public String SelectedReqName{get;set;}
    public static String SelectedTestName{get;set;}
    public String selectedreqid{get;set;}
    public String deleteSelectedTest{get;set;} 
    public String user {get;set;}
    public String role {get;set;}
    
    public boolean testMod1{get;set;}
    public boolean testMod2{get;set;}
    public boolean testReq1{get;set;}
    public boolean testCount1{get;set;}
    public boolean testCount2{get;set;}
    public boolean viewTC1{get;set;}
    public boolean viewTC2{get;set;}
    public boolean var1{get;set;}
    public boolean atmt{get;set;}
    public boolean booleanAttach{get;set;}
    public boolean booleanAttachjs{get;set;}
    public boolean booleanAttachList{get;set;} 
    public boolean showtable{get;set;}  
    public boolean showform{get;set;}
    public boolean showreqtable{get;set;}
    public boolean showTestBuildTable{get;set;}
    public boolean showDefectsTable{get;set;}
    public boolean boolRenderBack1{get;set;}
    public boolean boolRenderBack2{get;set;}
    public boolean statusNull{get;set;}
    public boolean resultNull{get;set;}
    public boolean showBack{get;set;}
   
    public List<Module__c> modulelist{get;set;}
    public List<Requirement__c> reqlist{get;set;}
    public List<TestCase__c> testlist{get;set;}
    public List<Attachment> defectAttachList{get;set;}
    public List<TestCase__c> viewAllTestCaseList{get;set;}
    public List<Requirement__c> viewAllTestCaseRequirementList{get;set;}
    public List<Module__c> viewAllTestCaseModuleList{get;set;}
    public List<ModuleWrapper> moduleListWrapper{get;set;} 
    public List<ModuleUser__c>nonUniqueList{get;set;}
    public Set<String>globalSet{get;set;}
    public List<ModuleUser__c>uniqueList{get;set;}
    
    public Decimal cnt {get;set;}
    public Integer statuscnt {get;set;}
  
    public  RequirementController(){
     try{
           referedTestObjId=' ';
           showtable=false;     
           showform=false; 
           showreqtable=false;
           showTestBuildTable=false;
           showDefectsTable=false;
           var1=false;
           atmt=false; 
           booleanAttach=false;     
           booleanAttachjs=false; 
           user=System.currentPagereference().getParameters().get('user');
           currentProjectID=System.currentPagereference().getParameters().get('project');
           role=System.currentPagereference().getParameters().get('role');
           checkTestCase();
           reqIns1 = new Requirement__c();
           testcaseInstance= new TestCase__c();
           tobeEdited2=new TestCase__c();
           
           modulelist = new List<Module__c>(); 
           reqlist = new List<Requirement__c>(); 
           testlist = new List<TestCase__c>();
           nonUniqueList=new List<ModuleUser__c>();
           uniqueList=new List<ModuleUser__c>();
           globalSet=new Set<String>();
           showmodulelist();
        }
     catch(Exception e){
           //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error');
           //ApexPages.addMessage(myMsg);
           ApexPages.addMessages(e);
        }
}  

    public class rTestCase{
           public TestCase__c tCase {get;set;}
           public Boolean haveTestCase {get;set;}
           public boolean message{get;set;}
           public boolean nullCheck1{get;set;}
           public boolean nullCheck2{get;set;}
           public boolean nullCheck11{get;set;}
           public boolean nullCheck21{get;set;}
           //This is the contructor method. When we create a new rTestCase object we pass a TestCase that is set to the tCase property. We also set the selected value to false
           public rTestCase(TestCase__c r){
              nullCheck1=true;
              nullCheck11=false;
              nullCheck2=true;
              nullCheck21=false;
              tCase = r;
              haveTestCase = false;
              message=true;
           }
}   
    public List<rTestCase> testCaseWrapperList{get;set;}
    public PageReference checkTestCase(){
     try{
           if(role=='admin'){
              //roleVal='admin';
              /*viewAllTestCaseModuleList=[select id,Name,projectID__c from Module__c where projectID__c=:currentProjectID];
              viewAllTestCaseRequirementList=[select id,Name,moduleID__c from Requirement__c where moduleID__c in :viewAllTestCaseModuleList];
              viewAllTestCaseList=[select id,Name,testName__c,testDescription__c,testAssignTo__c,sampleInputData__c,testStatus__c,testResult__c,reqID__c from TestCase__c where reqID__c in :viewAllTestCaseRequirementList];
              */
              viewAllTestCaseList=[select id,Name,testName__c,testDescription__c,testAssignTo__c,sampleInputData__c,testStatus__c,testResult__c,reqID__c from TestCase__c where reqID__r.moduleID__r.projectID__c=:currentProjectID];
           }
           else{
              viewAllTestCaseModuleList=[select  id, moduleName__c,projectID__c from Module__c where id in (Select user_of_module__c  from ModuleUser__c where EmpID__c =:user) and projectID__c=:currentProjectID];
              viewAllTestCaseRequirementList=[select id,Name,moduleID__c from Requirement__c where moduleID__c in :viewAllTestCaseModuleList];
              viewAllTestCaseList=[select id,Name,testName__c,testDescription__c,testAssignTo__c,sampleInputData__c,testStatus__c,testResult__c,reqID__c from TestCase__c where reqID__c in :viewAllTestCaseRequirementList];
              
              //viewAllTestCaseList=[select id,Name,testName__c,testDescription__c,testAssignTo__c,sampleInputData__c,testStatus__c,testResult__c,reqID__c from TestCase__c where reqID__r.moduleID__c in (Select user_of_module__c  from ModuleUser__c where EmpID__c =:user) and reqID__r.moduleID__r.projectID__c=:currentProjectID];
           }
           testCaseWrapperList = new List<rTestCase>();
           for(TestCase__c r : viewAllTestCaseList) 
           { 
              testCaseWrapperList.add(new rTestCase(r));
           }
           if(testCaseWrapperList.size()==0)
           {
              viewTC1=false;
              viewTC2=true;
           }
           else
           {
              viewTC1=true;
              viewTC2=false;
           }
        
           for(rTestCase r:testCaseWrapperList)
           {
             if(r.tCase.testStatus__c != Null)
             {
                 r.nullCheck1=false;
                 r.nullCheck11=true;
             }
             if(r.tCase.testResult__c != Null)
             {
                 r.nullCheck2=false;
                 r.nullCheck21=true;
             }
           }
           
           for(rTestCase r:testCaseWrapperList)
           {
              for(TestCaseBuild__c t:[select testCaseId__c from TestCaseBuild__c])
              {
                  if(t.testCaseId__c==r.tCase.id)
                  {
                      r.haveTestCase=true;
                      r.message=false;
                  }
              }
           }
        }
     catch(ListException e){
           //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error In Fetching List');
           //ApexPages.addMessage(myMsg);
           ApexPages.addMessages(e);
        }
           return Page.viewAllTestCasesPage;
}
    public void showmodulelist(){
           showreqtable=false;  
     try{     
           if(role=='admin'){
              modulelist=[select  id, moduleName__c,moduleSpecification__c,moduleStatus__c,priority__c,startDate__c,endDate__c,projectID__c from Module__c where projectID__c =: currentProjectID ];
           }
           else{
              modulelist=[select  id, moduleName__c,moduleSpecification__c,moduleStatus__c,priority__c,startDate__c,endDate__c,projectID__c from Module__c where id in (Select user_of_module__c  from ModuleUser__c where EmpID__c =:user and ProjectUserRole__c='a0G90000002af7n') and projectID__c =: currentProjectID ];
           }
           List<Requirement__c> tempreqList=new List<Requirement__c>();
           List<Requirement__c> statusreqList=new List<Requirement__c>();
           moduleListWrapper=new List<ModuleWrapper>();
           //counting no. of requirements in each module
             
           for(Module__c m:modulelist)
           {
              moduleListWrapper.add(new ModuleWrapper(m));
           }
           if(moduleListWrapper.size()==0)
           {
              testMod1=false;
              testMod2=true;
           }
           else
           {
              testMod1=true;
              testMod2=false;
           }
             
           for(ModuleWrapper mw:moduleListWrapper){
              tempreqList=[select Name from Requirement__c where moduleID__r.id=:mw.modObj.id];
              statusreqList=[select Name from Requirement__c where moduleID__r.id=:mw.modObj.id and reqStatus__c='complete'];
              cnt=tempreqList.size();
              statuscnt=statusreqList.size();
              if(statuscnt!=0)
              {
                 cnt=(statuscnt/cnt)*10000;
                 cnt=cnt.Divide(100,2);
              }
              else cnt=0;
              mw.width= String.valueOf(cnt);
              tempreqList=new List<Requirement__c>();
           }
        }
     catch(ListException e){
           //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error In Fetching List');
           //ApexPages.addMessage(myMsg);
           ApexPages.addMessages(e);
        }
}
  
    public void showreq(){  
           showreqtable=true; 
     try{  
           modname=new Module__c();
           modname=[select moduleName__c from Module__c where id=:SelectedModuleName];     
           reqlist=[select id,Name,reqName__c,reqDescription__c,reqPriority__c,reqProposedBy__c,reqStatus__c,reqType__c,reqVersion__c from Requirement__c where moduleID__r.id=:SelectedModuleName];  
           if(reqList.size()==0)
           {    
              testReq1=false;
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No Requirements Added yet for this module...');
              ApexPages.addMessage(myMsg);
           }
           else
           {
              testReq1=true;
           }
        }
     catch(ListException e){
           //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error In Fetching List');
           ApexPages.addMessages(e);
        }
}
    public PageReference calltestcases(){        
           showtable=false;
           showform=false;  
     try{ 
           system.debug('-----------------req-------------?------' + SelectedReqName);      
           reqIns1=[select id,Name,reqName__c,reqDescription__c,reqPriority__c,reqProposedBy__c,reqStatus__c,reqType__c,reqVersion__c from Requirement__c where Name =: SelectedReqName];  
        }
     catch(DMLException e){
           //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error In Fetching List');
           ApexPages.addMessages(e);
        }
           return Page.displaytestcases;    
}
    
    public void viewtestcases(){               
           showtable=true;      
           showform=false; 
           showBack=false; 
     try{     
           testlist=[select Name,testName__c,testDescription__c,testAssignTo__c,sampleInputData__c,lastExecuted__c,lastModified__r.empName__c,actualOutput__c,expectedOutput__c,testStatus__c,testResult__c,reqID__c,userID__r.empName__c from TestCase__c where reqID__r.Name =: SelectedReqName];
           
           if(testList.size()==0)
           {
              testCount1=false;
              testCount2=true;
           }
           else
           {
              testCount1=true;
              testCount2=false;
           }
        }
     catch(ListException e){
           //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error In Fetching List');
           ApexPages.addMessages(e);
        }
}
    
    public void viewForm(){            
           showtable=false;      
           showform=true;
           showBack=true;   
}
    public PageReference callEdit(){   
     try{      
           system.debug('-----------------sel-------------?------' + SelectedTestName); 
           tobeEdited2 = [Select  Name,testName__c,testDescription__c,testSteps__c,testAssignTo__c,sampleInputData__c,lastExecuted__c,lastModified__c,actualOutput__c,expectedOutput__c,testResult__c,reqID__c from TestCase__c  where Name=:SelectedTestName limit 1]; 
           System.debug(SelectedTestName);    
           //SelectedreqName1=tobeEdited2.Name;
        }
     catch(ListException e){
           //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error In Fetching List');
           ApexPages.addMessages(e);
        }
           return Page.testcaseEditPage;
} 
    public PageReference DeleteAccount(){ 
     try{           
           system.debug('-----------------selected-------------?------' + deleteSelectedTest);   
           // if for any reason we are missing the reference  
           if (deleteSelectedTest == null){ return page.displaytestcases;}         
           // find the emp record within the collection         
           TestCase__c tobeDeleted = null;       
           for(TestCase__c a : testlist)   
           if (a.Name == deleteSelectedTest){            
           tobeDeleted = a;      
           break;         
           }        
           //if emp record found delete it    
           if (tobeDeleted != null){Delete tobeDeleted;}
           //testlist=[select Name,testName__c,testDescription__c,testAssignTo__c,sampleInputData__c,lastExecuted__c,actualOutput__c,expectedOutput__c,testStatus__c,testResult__c,reqID__c from TestCase__c where reqID__r.Name =: SelectedReqName];
           viewtestcases();//new1
        }
     catch(DMLException e){
           //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error In Fetching List');
           ApexPages.addMessages(e);
        }
           return null;
}
    public void addtestcaseObject(){  
     try{       
           system.debug('-----------------req1-------------?------' + selectedreqid); 
           testcaseInstance.reqID__c=reqIns1.id;
           testcaseInstance.userID__c=user;
           testcaseInstance.lastModified__c=user;
           ////testcaseInstance.testAssignTo__c=testAssignTo; 
           insert testcaseInstance;    
           testcaseInstance = new TestCase__c();//after inserting this object will clean the form
           viewtestcases();//new1
        }
     catch(DMLException e){
           //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error In Fetching List');
           ApexPages.addMessages(e);
        }
}     
    public PageReference previous(){   
           showtable=false;  
           testlist = new List<TestCase__c>();            
           return Page.showmodulereq;
} 
    public PageReference updatetestcase(){  
     try{   
           tobeEdited2.lastModified__c=user;       
           update tobeEdited2; 
           tobeEdited2= new TestCase__c();//after inserting this object will clean the form new1
           viewtestcases();//new1
        }
     catch(DMLException e){
           //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error In Updation');
           ApexPages.addMessages(e);
        }
           return Page.displaytestcases;//old
}
    public PageReference returnEdit(){        
           return Page.displaytestcases;
} 
    public PageReference backToHomePage(){   
           return Page.projectPage;
}     
    public PageReference backToTestCases(){
           showTestBuildTable=false;
           showDefectsTable=false;
           return Page.viewAllTestCasesPage;
}
  
    public Attachment attachment1 {
     get{
           if (attachment1 == null)
           attachment1 = new Attachment();
           return attachment1;
        }
     set;
}
    //requirement wrapper class list
    public List<rDefect> defectWrapperList{get;set;}
    public PageReference checkAttachment() {
     try{
           booleanAttachjs=false;
           booleanAttach=false;  
           defectWrapperList = new List<rDefect>();
           for(Defect__c r : [Select  id,Name,defectName__c,defectDescription__c,defectSeverity__c,defectStatus__c from Defect__c where TestCaseBuildID__r.id=:referedTestBuildObjId]) 
           { 
              defectWrapperList.add(new rDefect(r));
           }
           for(rDefect r:defectWrapperList)
           {
              for(Attachment a:[select ParentId from Attachment])
              {
                if(a.ParentId==r.defect.id)
                {
                    r.haveAttachment=true;
                    r.message2=false;
                }
              }
           }
        }
     catch(ListException e){
           //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error In Fetching List');
           ApexPages.addMessages(e);
        }
           var1=true;  
           showDefectsTable=true;
           boolRenderBack1=false;
           boolRenderBack2=true;
           return null;
}

    public PageReference selectAttach(){
    try{
           atmt=true;
           booleanAttachList=true;
           defectname=new Defect__c();
           defectname=[select defectName__c from Defect__c where id=:defectAttachId];
           defectAttachList=new List<Attachment>();
           Defect__c defectAttach=new Defect__c();
           defectAttach=[select id,Name from Defect__c where id=:defectAttachId];

        
           defectAttachList=[SELECT Id, Name,ParentId FROM Attachment WHERE ParentId=:defectAttach.id];
           if(defectAttachList.size()==1)
           {
              atmt=false;
              selectedAttachmentId=defectAttachList[0].id;
              viewAttach();
              booleanAttachList=false;
           }
        }
     catch(ListException e){
           //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error In Fetching List');
           ApexPages.addMessages(e);
        }
           return null;
}

    public PageReference viewAttach(){
           booleanAttachjs=true;
           url='https://c.ap1.content.force.com/servlet/servlet.FileDownload?file='+selectedAttachmentId;
           booleanAttach=false; 
           return null;
}
 
    public class rDefect{
           public Defect__c defect {get; set;}
           public Boolean haveAttachment {get; set;}
           public boolean message2{get;set;}
           //This is the contructor method. When we create a new cContact object we pass a Contact that is set to the con property. We also set the selected value to false
           public rDefect(Defect__c r){
              defect = r;
              haveAttachment = false;
              message2=true;
           }
}
    
    //new code
    public List<rTestCaseBuild> buildWrapperList{get;set;}
     
    public PageReference checkBuild(){
     try{
           buildWrapperList = new List<rTestCaseBuild>();
             
           for(TestCaseBuild__c r : [Select  id,Name,actualOutput__c,executedOn__c,result__c from TestCaseBuild__c where testCaseId__r.id=:referedTestObjId]) 
           { 
              buildWrapperList.add(new rTestCaseBuild(r));
           }
           for(rTestCaseBuild r:buildWrapperList)
           {
              for(Defect__c d:[select TestCaseBuildID__c from Defect__c])
              {
                if(d.TestCaseBuildID__c==r.build.id)
                {
                   r.haveBuild=true;
                   r.message1=false;
                }
              }
           }
        }
     catch(ListException e){
           //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error In Fetching List');
           ApexPages.addMessages(e);
        }
           showTestBuildTable=true;
           boolRenderBack1=true;
           boolRenderBack2=false;
           return Page.viewTestCaseBuildsPage;
}
    
    public class rTestCaseBuild{
           public TestCaseBuild__c build {get; set;}
           public Boolean haveBuild {get; set;}
           public boolean message1{get;set;}
           //This is the contructor method. When we create a new cContact object we pass a Contact that is set to the con property. We also set the selected value to false
           public rTestCaseBuild(TestCaseBuild__c r){
              build = r;
              haveBuild = false;
              message1=true;
           }
}
    
    public class Modulewrapper{
           public String width{get;set;}
           public Module__c modObj {get;set;}
           public Modulewrapper(Module__c m){
              modObj=m;
              width='';
           }
}//end of moduleWrapper
}