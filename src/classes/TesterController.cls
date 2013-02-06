/* Module:Tester module to execute test cases and maintain defect log
   Pages: testerModule,reqDisplayPage,testCaseSelectPage,testCaseDisplayPage,testBuildDisplayPage
   Flow:Control goes to defect controller from testCaseDisplayPage
*/ 

public class TesterController{

   public List<Module__c> projList { get; set; }
   public List<ModuleWrapper> moduleListWrapper { get; set; }
   public List<Requirement__c> reqList { get; set; }
   public List<TestCase__c> TestList { get; set; }
   public List<TestCaseBuild__c> referedTestBuild {get;set;} 
   public List<TestCaseBuild__c> testBuildList {get;set;} 
   public List<TestCaseBuild__c> BuildList {get;set;}
   public String url{get;set;}
   public String prevUrl{get;set;}
   public String SelectedName { get; set; }
   public String SelectedTestName { get; set; }
   public static String SelectedTestFormName { get;set; }
   public boolean booleanTestCaseTable{get;set;}
   public boolean booleanResult{get;set;}
   public boolean booleanFail{get;set;}
   public boolean boolPendingTable{get;set;}
   public boolean testerMod1{get;set;}
   public boolean testerMod2{get;set;}
   public boolean testerReq1{get;set;}
   public boolean testerReq2{get;set;}
   public boolean testBuild1{get;set;}
   public boolean testBuild2{get;set;}
   public boolean showDefectForm{get;set;}
   public boolean showAddDefect{get;set;}
   public boolean showSave{get;set;}
   public String actualOutput{get;set;}
   public String result{get;set;}
   public String user{get;set;}
   public String currentProjectId{get;set;}
   public Requirement__c referedReq{get;set;}
   public TestCase__c referedTestObject{get;set;} 
   public string buildid{get;set;}   
   public TestCaseBuild__c buildObj{get;set;}   
   public Module__c moduleObj {get;set;}
   public Decimal cnt {get;set;}
   public Integer statuscnt {get;set;}
   public string referedTestObjId {get;set;}
   public List<TestCase__c> noBuildList {get;set;}
   public Defect__c defectObj {get;set;}
     //cunstructor that initializes data
     public TesterController() {
        try{
             user=System.currentPagereference().getParameters().get('user');
             currentProjectID=System.currentPagereference().getParameters().get('project');
             LoadData();
             booleanResult=false;
             prevUrl='/apex/testerModule?user='+user+'&project='+currentProjectId;
             }
        catch(Exception e){       
             //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'my error msg');       
             ApexPages.addMessages(e);     
             }
     } 
    
     //function that fetch list of modules in an particular project
     public void LoadData() {
        try{
             projList=[select  id, moduleName__c,moduleSpecification__c,moduleStatus__c,priority__c,startDate__c,endDate__c from Module__c where id in (Select user_of_module__c  from ModuleUser__c where EmpID__c =:user and ProjectID__c =:currentProjectID and ProjectUserRole__c='a0G90000002af7i') ];
             List<Requirement__c> tempreqList=new List<Requirement__c>();
             List<Requirement__c> statusreqList=new List<Requirement__c>();
             moduleListWrapper=new List<ModuleWrapper>();
             showDefectForm=false;
             showSave=true;
             showAddDefect=false;
             //counting no. of requirements in each module
             for(Module__c m:projList){
             moduleListWrapper.add(new ModuleWrapper(m));
             }
             if(moduleListWrapper.size()==0){
                 testerMod1=false;
                 testerMod2=true;
             }
             else{
                 testerMod1=true;
                 testerMod2=false;
             }
             
             for(ModuleWrapper mw:moduleListWrapper){
             tempreqList=[select Name from Requirement__c where moduleID__r.id=:mw.modObj.id];
             statusreqList=[select Name from Requirement__c where moduleID__r.id=:mw.modObj.id and reqStatus__c='complete'];
             cnt=tempreqList.size();
             statuscnt=statusreqList.size();
             if(statuscnt!=0){
              cnt=(statuscnt/cnt)*10000;
             //cnt=cnt.setScale(2);
              cnt=cnt.Divide(100,2);
             }
             else cnt=0;
             mw.width= String.valueOf(cnt);
             tempreqList=new List<Requirement__c>();
             
             }
          }
        catch(Exception e){       
             //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'my error msg');       
             ApexPages.addMessages(e);     
          }
       TestList=null;
       referedReq=new Requirement__c();
       buildObj=new TestCaseBuild__c();
       boolPendingTable=false;
       booleanTestCaseTable=false;
       booleanFail=false;
       actualOutput='';
       result='';
       defectObj=new Defect__c();
       return;
    }
     
     //function to render defect panel
     public PageReference defectForm(){
         //if(showAddDefect==true)
           //  {showDefectForm=true;}
           return Page.defectFormPage;
     }
     public Attachment attachment {
      get {
          if (attachment == null)
          attachment = new Attachment();
          return attachment;
      }
      set;
    }
     
     //function that fetch requirement list of an particular module  
     //testerReq1 and testerReq2 used for rendering apex page messages 
     public PageReference callReq(){
        moduleObj=new Module__c();
        try{
            moduleObj=[select Name,moduleName__c,moduleSpecification__c,moduleStatus__c,priority__c from Module__c where id=:SelectedName];
            reqList= [Select  id,reqName__c ,reqStatus__c,reqPriority__c,reqDescription__c,reqVersion__c,reqType__c from Requirement__c where moduleID__r.id=:SelectedName ];
            if(reqList.size()==0){
                testerReq1=false;
                testerReq2=true;
            }
            else{
                testerReq1=true;
                testerReq2=false;
            }
           }
            catch(Exception e){       
             //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'my error msg');       
             ApexPages.addMessages(e);     
           }
        System.debug(SelectedName);
        return Page.ReqDisplayPage;
       } 
       
       public pagereference callBack()
       {
           boolPendingTable=false;
           //callReq();
           return callReq();
       }
    
     //function that fetch all the test cases of selected requirement
     public PageReference callTestCase(){
      try{
          referedReq=[select id,Name,reqName__c,reqStatus__c,reqPriority__c,reqDescription__c from Requirement__c where id=:SelectedTestName];
          testBuildList=new List<TestCaseBuild__c>();
          noBuildList=new List<TestCase__c>();
          BuildList=new List<TestCaseBuild__c>();
          TestList= [Select  id,Name,testName__c,testDescription__c,expectedOutput__c,prerequisites__c,sampleInputData__c from TestCase__c where reqID__r.id=:SelectedTestName ];
          for(TestCase__c t: TestList){
              testBuildList=[select Name,executedOn__c,result__c,actualOutput__c, testCaseId__r.Name, testCaseId__r.testStatus__c, testCaseId__r.testName__c,testCaseId__r.testDescription__c,testCaseId__r.id from TestCaseBuild__c where testCaseId__r.id=:t.id Order By Name desc];
           if(testBuildList.size()==0){
          noBuildList.add(t);
          boolPendingTable=true;
          continue;
         }
          BuildList.add(testBuildList[0]);
          }
          if(BuildList.size()==0){
              testBuild1=false;
              testBuild2=true;
          }
          else{
              testBuild1=true;
              testBuild2=false;
          }
         }
         catch(Exception e){       
             //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'my error msg');       
             ApexPages.addMessages(e);     
        }
         System.debug(SelectedTestName);
          booleanTestCaseTable=true;
         return Page.TestCaseSelectPage;
      } 
     
      //function that generates selected test case details
     public PageReference callTestCaseForm(){
         referedTestObject=new TestCase__c();
       try{
            referedTestObject= [Select  id,Name,testName__c,testDescription__c,expectedOutput__c,testSteps__c,sampleInputData__c,prerequisites__c,testStatus__c from TestCase__c where id=:SelectedTestFormName ];
            //result=[select result__c from TestCaseBuild__c where testCaseId__r.id=:referedTestObject.id order by Name].result__c;
          }
            catch(Exception e){       
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'my error msg');       
             ApexPages.addMessage(myMsg);     
          }
          System.debug(SelectedTestFormName);
          url='/apex/DefectFormPage?id='+referedTestObject.id+'&reqId='+SelectedTestName; 
          return  Page.TestCaseDisplayPage;
      } 
        
       public pageReference viewHistory(){
          referedTestBuild=new List<TestCaseBuild__c>();
         try{
           referedTestBuild=[Select  id,Name,actualOutput__c,executedOn__c,result__c from TestCaseBuild__c where testCaseId__r.id=:referedTestObjId ];
        if(referedTestBuild.size()==0){
           return null;
           }
        }
        
        catch(Exception e){       
            // ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'my error msg');       
             ApexPages.addMessages(e);     
          }
         return Page.testBuildDisplayPage;
    }
       
             
      //function that adds two input fields for actual result and pass/fail results 
     /* public PageReference callPanel(){
        booleanPanel=true;
        booleanEdit=false;
        booleanCancel=false;   
        return Page.TestCaseDisplayPage;
      }
      */
      
      //function that returns to main page without saving
      public PageReference callCancel(){
        LoadData();
        return Page.testerModule;
      }
       
        
     //function that updates module,requirement and testcase status
      public PageReference updateReqStatus(){
      try{
        referedTestObject.actualOutput__c=actualOutput;
        buildObj.actualOutput__c=actualOutput;
        buildObj.executedOn__c=system.today(); 
        buildObj.executedBy__c=user;
        buildObj.testCaseId__c=referedTestObject.id;
        referedTestObject.testResult__c=result;
        if(result=='pass'){
              referedTestObject.testStatus__c='success';
              buildObj.result__c='pass';
        }
        else if(result=='fail'){
              referedTestObject.testStatus__c='bug';
              buildObj.result__c='fail';
              booleanResult=true;
        }
        else{
              referedTestObject.testStatus__c='pending';
        }
        update referedTestObject;
        insert buildObj;
        if(result=='fail'){
           addDefect(); 
        }
        boolean checkBug=false;
        //referedReq=[select id,reqStatus__c,reqPriority__c,reqDescription__c from Requirement__c where id=:SelectedTestName];
        TestList= [Select  id,testName__c,testStatus__c,testResult__c from TestCase__c where reqID__r.id=:SelectedTestName ];
        for(TestCase__c t:TestList){
             if(!(t.testStatus__c=='success') && !(t.testStatus__c=='bug')){
              referedReq.reqStatus__c='inprogress';
              break;
             }
             else if(t.testStatus__c=='bug'){
              referedReq.reqStatus__c='inprogress';
              checkBug=true;
              continue;
             }
             else if(t.testStatus__c=='success'){
                if(checkBug==false){
                   referedReq.reqStatus__c='complete';
                   continue;
                }
             }
        }
        update referedReq;
        //url='/apex/DefectFormPage?id='+referedTestObject.id+'&reqId='+SelectedTestName+'&buildId='+buildObj.id; 
        reqList= [Select   id,reqName__c ,reqStatus__c,reqPriority__c,reqDescription__c,reqVersion__c,reqType__c from Requirement__c where moduleID__r.id=:SelectedName ];
        Module__c moduleObj=[select  id, moduleName__c from Module__c where id=:SelectedName];
        for(Requirement__c r:reqList){
            if(r.reqStatus__c=='complete'){
                moduleObj.moduleStatus__c='completed';
                continue;
            }
            else{
            moduleObj.moduleStatus__c='inprogress';
            break;
            }
        }
       update moduleObj; 
       if(result=='pass'){
            updateDefect();
           // LoadData();
           // return callTestCase();
       }
       }
       catch(Exception e){       
             //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'my error msg');       
             ApexPages.addMessages(e);     
       } 
       LoadData();
        return callTestCase();
       //return null;
    }
    
    //funtion to close defect it is executed successfully
    public void updateDefect(){
       testBuildList=new List<TestCaseBuild__c>();
       List<Defect__c> tempDefectList=new List<Defect__c>();
       Defect__c defObj=new Defect__c();
       try{
           testBuildList=[Select  id,Name,actualOutput__c,executedOn__c,result__c from TestCaseBuild__c where testCaseId__r.id=:referedTestObject.id  and result__c='fail'];
           for(TestCaseBuild__c t:testBuildList){
               tempDefectList=[select Name from Defect__c where TestCaseBuildID__r.id=:t.id ];
               if(tempDefectList.size()>0){
                   defObj=[select Name,id,defectStatus__c from Defect__c where TestCaseBuildID__r.id=:t.id ];
                   defObj.defectStatus__c='closed';
                   update defObj;
                   defObj=new Defect__c();
               }
            }
       }
       catch(DMLException e){       
           //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'my error msg');       
           ApexPages.addMessages(e);     
       }  
    }
     
    //function to display expected output on click of pass radio button
    public PageReference fetchActualOutput(){
        if(result=='pass'){
            actualOutput=referedTestObject.expectedOutput__c;
            getbooleanFail();   
        }
        else if(result=='fail'){
            showSave=false;
            showAddDefect=true;
        }
        return null;
    }
    
    
     //function to insert defect data
    public void addDefect(){
       
       //testCaseObj=new TestCase__c();
       //buildObj=[Select id from TestCaseBuild__c where id=:buildId];
       //testCaseObj=[Select id,expectedOutput__c,actualOutput__c ,testDescription__c,testSteps__c from TestCase__c where id=:testId];
       //defectObj.testId__c=testCaseObj.id;
       defectObj.TestCaseBuildID__c=buildObj.id;
       insert defectObj;
       if(attachment.body!=null)
       upload();
       } 
    
   //function to insert attachment to the defect
    public void upload() {
        attachment.name=defectObj.defectName__c;
        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = defectObj.id;
        attachment.IsPrivate = true;
 
      try {
        insert attachment;
      }
      catch (DMLException e) {
       // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
        return;
      } 
      finally {
      attachment = new Attachment(); 
      }
     // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
      return ;
    }
    
    
    
    public void getbooleanFail(){
    booleanFail=true;
    }   
  
    public class Modulewrapper{
        public String width{get;set;}
        public Module__c modObj {get;set;}
         
        //wrapper class constructor 
        public Modulewrapper(Module__c m){
            modObj=m;
            width='';
        }
  }//end of moduleWrapper
  
 }//end of testerController