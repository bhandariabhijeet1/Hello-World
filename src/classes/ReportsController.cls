public class ReportsController{

    public Project__c projectObj{get;set;}
    public List<Requirement__c> reqList1{get;set;}
    public List<TestCase__c> testCaseList1{get;set;}
    public List<TestCaseBuild__c> testName{get;}
    public List<Defect__c> defectList1{get;set;}
    public List<TestCaseBuild__c> testcaseBuildList1{get;set;}
   
   // public List<Defect__c> defectList{get;set;}
    public List<TestCase__c> testCaseName{get;set;}
    public List<Module__c> moduleList{get;set;}
    public boolean bool1{get;set;}
    public boolean bool2{get;set;}
    public boolean bool3{get;set;}
    public string currentProjectID{get;set;}
    
    public ReportsController()
    {
          
           moduleList=new List<Module__c>();
           projectObj=new Project__c();
           currentProjectID=System.currentPagereference().getParameters().get('project');
           projectObj=[select Name,projectTitle__c,projectVersion__c,startDate__c,endDate__c from Project__c where id=:currentProjectID]; 
           moduleList=[select Name,id from Module__c where projectID__r.id=:currentProjectID];
           bool1=false;
           bool2=false;
           //bool2=false;
    }       
    public PageReference reqReports()
    {
           //Module__c[] cc=[select Name from Module__c where projectID__r.Name='P-0033'];
           List<Requirement__c> reqList=new List<Requirement__c>();
           reqList1=new List<Requirement__c>();
           for(Module__c cc:moduleList){
              
              reqList=[select CreatedDate, Name,reqName__c,reqDescription__c,reqPriority__c,reqProposedBy__c,reqStatus__c,reqVersion__c,moduleID__r.moduleName__c from Requirement__c where moduleID__r.Name=:cc.Name order by Name];
              reqList1.addAll(reqList);
             
           }
           bool1=true;
           bool2=false;
           bool3=false;
           return null;
    }
    public PageReference showReq()
    {
          return Page.showReports;
    } 
    
    public PageReference testcaseReports()
    {
           reqReports();
           List<TestCase__c> testCaseList=new List<TestCase__c>();
           testCaseList1=new List<TestCase__c>();
           for(Requirement__c cc:reqList1){
             
                 testCaseList=[select Name,testName__c,testDescription__c,reqID__r.reqName__c,reqID__r.moduleID__r.moduleName__c,testAssignTo__c,expectedOutput__c,actualOutput__c,
                               testResult__c,testStatus__c from TestCase__c where reqID__r.Name=:cc.Name];
                 testCaseList1.addAll(testCaseList);  
           }                      
           bool2=true;
           bool1=false;
           bool3=false;
           return null;
    } 
    public PageReference testCaseBuildReports()
    {
          testcaseReports();
          List<TestCaseBuild__c> testcaseBuildList=new List<TestCaseBuild__c>();
          testcaseBuildList1=new List<TestCaseBuild__c>();
          for(TestCase__c cc:testCaseList1){
             
             testcaseBuildList=[select Name,actualOutput__c,executedBy__c,executedOn__c,result__c,testCaseId__r.testName__c from
             TestCaseBuild__c where testCaseId__r.Name=:cc.Name];
             
             testcaseBuildList1.addAll(testcaseBuildList);
          }
          return null;
    }          
                             
         
   
                
    public PageReference defectReports()
    { 
           //testcaseReports();
           testCaseBuildReports();
           List<Defect__c> defectList=new List<Defect__c>();
           defectList1=new List<Defect__c>(); 
           for(TestCaseBuild__c cc:testcaseBuildList1){
           
                 defectList=[select Name,defectName__c,defectDescription__c,defectType__c,defectSeverity__c,TestCaseBuildID__c,defectStatus__c,
                             TestCaseBuildID__r.testCaseId__r.testName__c from Defect__c where TestCaseBuildID__r.Name=:cc.Name];
                             
                             
                 defectList1.addAll(defectList);
            } 
            
           /*for(Defect__c cc:defectList1){ 
           testCaseName.add([select testName__c from TestCase__c where id=:cc.TestCaseBuildID__c]); 
           }*/
           bool3=true;
           bool1=false;
           bool2=false;
           return null;                
      }
    public PageReference showdefects()
    {
          return Page.showReports2;
    }  
    public PageReference showTestCase()
    {
          return Page.showReports1;
    }     
}