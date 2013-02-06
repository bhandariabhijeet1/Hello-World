public class AddRequirementController{

     //public string selected{get;set;}
     public string moduleParam{get;set;}
     public string reqParam{get;set;}
     public List<moduleWrap> moduleList {get; set;}
      public List<Module__c> modList {get; set;}
     public List<reqWrap> reqList{get;set;}
     public List<testCaseWrap> testcaseList{get;set;}
     public Module__c moduleInstance{get;set;}
     public Requirement__c reqInstance{get;set;}
     public TestCase__c testCaseInstance{get;set;}
     public boolean checkbool{get;set;}
     public boolean addModuleBool{get;set;}
     public boolean addReqBool{get;set;}
     public boolean addTestcaseBool{get;set;}
     public boolean showTestcaseBool{get;set;}
     
     public string user{get;set;}
     public string currentProjectID{get;set;}
     public string reqid{get;set;}
     public Requirement__c req{get;set;}
     public class moduleWrap{
     
       public boolean selected{get;set;}
       public Module__c moduleObj{get;set;}
       public string selectedModule{get;set;}
       public moduleWrap(Module__c con,string name){
             moduleObj=con;
             selected=false;
             selectedModule=name;
       }       
     }
     public class reqWrap{
       public boolean selected{get;set;}
       public Requirement__c reqObject{get;set;}
       public string selectedReq{get;set;}
       public reqWrap(Requirement__c con,string name){
       
             reqObject=con;
             selected=false;
             selectedReq=name;
       }
     } 
     public class testcaseWrap{
       public boolean selected{get;set;}
       public TestCase__c testcaseObject{get;set;}
       public string selectedTestcase{get;set;}
       public testcaseWrap(TestCase__c con,string name){
             
             testcaseObject=con;
             selected=false;
             selectedTestcase=name;
       }
     }  
                
     public AddRequirementController()
     {  
            moduleInstance=new Module__c();
            checkbool=false;
            addModuleBool=false;
            addReqBool=false;
            addTestcaseBool=false;
            showTestcaseBool=false;
            user='abc';
           // user=System.currentPagereference().getParameters().get('user');
            currentProjectID=System.currentPagereference().getParameters().get('project');
            getModules();
            
     }       
                 
     public List<moduleWrap> getModules(){
       
       //if(moduleList==null){
            moduleList=new List<moduleWrap>();
            //modList=new List<module__c>();
           // modList=[select  id, moduleName__c,Name from Module__c where id in (Select user_of_module__c  from ModuleUser__c where EmpID__c =:user) ];      
            
            //for(Module__c c:[select  id, moduleName__c,Name from Module__c where id in (Select user_of_module__c  from ModuleUser__c where EmpID__c =:user) ])
            for(Module__c c:[select id,moduleName__c,Name from Module__c where projectID__r.Name='P-0033' ])
            {
                   moduleList.add(new moduleWrap(c,c.Name));
            }
       // }            
        return moduleList;
    } 
    
    
    public PageReference Requirements(){
       
            reqList=new List<reqWrap>();
            for(Requirement__c r:[select id,Name,reqName__c,moduleID__r.Name,moduleID__r.moduleSpecification__c,
            moduleID__r.moduleName__c,moduleId__r.priority__c,moduleID__r.startDate__c,moduleID__r.endDate__c from Requirement__c where moduleID__r.Name=:moduleParam])
            {
                 reqList.add(new reqWrap(r,r.Name));
            }
            checkbool=true;
          return null;  
       
    }
    public PageReference getTestcases(){
       
            testCaseList=new List<testCaseWrap>();
           /* for(TestCase__c r:[select id,Name,reqName__c,moduleID__r.Name,moduleID__r.moduleSpecification__c,
            moduleID__r.moduleName__c,moduleId__r.priority__c,moduleID__r.startDate__c,moduleID__r.endDate__c from Requirement__c where moduleID__r.Name=:moduleParam])
            {
                 reqList.add(new reqWrap(r,r.Name));
            }
            checkbool=true;*/
          return null;  
       
    }  
    public PageReference showAddModule()
    {
            addModuleBool=true;
            addReqBool=false;
            addTestcaseBool=false;
            return null;
    } 
    public PageReference showAddRequiement()
    {
            addReqBool=true;
            addModuleBool=false;
            addTestcaseBool=false;
            return null;
    }                 
    public void addModule()
    {
           
           //string projectid=[select Name from Project__c where id=:currentProjectID limit 1].Name;
           List<Project__c> projObj=[select id from Project__c where Name='P-0033' limit 1];
           moduleInstance.projectID__c=projObj[0].id;
          // moduleObj=new Module__c(moduleName__c=mname,moduleSpecification__c=modulespecf,
           //priority__c=priority,startDate__c=startdate,endDate__c=enddate,projectID__c=projectid);
           insert moduleInstance;
     } 
    public PageReference showid()
    {
                      
            req=[select Name,reqName__c from Requirement__c where Name=:reqid limit 1];
            PageReference newPage=Page.EditRequirement;
        //newPage.setRedirect(true);
           //SelectedreqName1=editedReqInst.Name;
            return newPage;
            
    }            
          
}