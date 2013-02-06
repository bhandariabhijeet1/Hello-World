public class TestCaseWriterPageController{
    public Project__c projObj {get;set;}
    public String user {get;set;}
    public String currentUser{get;set;}
    public string currentProjectID{get;set;}
    public String selectedrole{get;set;}
    public boolean more{get;set;}
    public boolean less{get;set;}
    public boolean showDetail{get;set;}
    public String frameSource{get;set;}
    public List <Module__c> modlist{get;set;}
    public TestCaseWriterPageController(){
    
    try{
        currentProjectID=System.currentPagereference().getParameters().get('project');
        user=System.currentPagereference().getParameters().get('user');
        selectedrole='a0G90000002af7n';
        frameSource='/apex/showmodulereq?user='+user+'&project='+currentProjectID+'&role=test';
        showDetail=false;
        more=true;
        less=false;
        projObj=new Project__c();
        //user=System.currentPagereference().getParameters().get('user');
        //currentProjectID=System.currentPagereference().getParameters().get('project');
        currentUser=getUserName();
        projObj=[select Name,id, projectTitle__c,projectVersion__c,status__c, budget__c,startDate__c,endDate__c,Technology__c, projectDescription__c from Project__c where id=:currentProjectID];
       }
    catch(Exception e){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error In Loading Page');
        ApexPages.addMessage(myMsg);
       }
        
  }
    public String getUserName(){
        Employee__c emp=new Employee__c();
    try{
        emp=[select empName__c from Employee__c where id=:user];
       }
    catch(Exception e){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error In Fetching List');
        ApexPages.addMessage(myMsg);
       }
        return emp.empName__c;
  }
    public Integer getModuleCount (){
        modList=new List<Module__c>();
    try{
        modlist=[select Name from Module__c where projectID__C=:currentProjectID];
       }
    catch(Exception e){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error In Fetching List');
        ApexPages.addMessage(myMsg);
       }
        return modlist.size();
  }
    public void addModule(){
        frameSource='/apex/moduleDetail?project='+currentProjectID;
  }
    public void viewModule(){
         frameSource='/apex/ViewModuleDetail1?project='+currentProjectID; 
         //frameSource='/apex/showmodulereq?project='+currentProjectID;
  }        
    public void viewRequirement(){
         frameSource='/apex/RequirementView?user='+user+'&project='+currentProjectId+'&role='+selectedrole; 
  }
    public void showProjectDetail(){
         if (more)    {
           more=false;
           less=true; 
           showDetail=true;
         }
         else if (less){
             less=false;
             more=true;
             showDetail=false;
         }
  }
           
    public void viewAllTestCases(){
        frameSource='/apex/viewAllTestCasesPage?user='+user+'&project='+currentProjectID+'&role=test';
  }
    public void viewModules(){
        frameSource='/apex/showmodulereq?user='+user+'&project='+currentProjectID+'&role=test';
  }
    public void globalTestcases(){
    frameSource='/apex/showmodulereq?user=admin&project='+currentProjectID;
  }
    public PageReference backToHomePage(){
        PageReference page = new PageReference('/apex/projectPage?user='+user);
        return page;
  }
}