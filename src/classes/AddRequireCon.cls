public class AddRequireCon{

     //public string selected{get;set;}

     public string moduleParam{get;set;}
     public string reqParam{get;set;}
     public List<moduleWrap> moduleList {get; set;}
     public List<Module__c> modList {get; set;}
     public List<reqWrap> reqList{get;set;}
     public List<testCaseWrap> testcaseList{get;set;}
     public Requirement__c editedReqInst{get;set;}
     public Module__c moduleInstance{get;set;}
     public Requirement__c reqInstance{get;set;}
     public TestCase__c testCaseInstance{get;set;}
     public boolean checkbool{get;set;}
     public boolean addModuleBool{get;set;}
     public boolean addReqBool{get;set;}
     public boolean addTestcaseBool{get;set;}
     public boolean showTestcaseBool{get;set;}
     public String user{get;set;}
     public String currentProjectId{get;set;}
     public String description{get;set;}
     public String name{get;set;}
     public String priority{get;set;}
     public String propby{get;set;}
     public String status{get;set;}
     public String reqtype{get;set;}
     public String ver{get;set;}
     public String reqId{get;set;}
     public string check{get;set;}
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
                
     public AddRequireCon()
     {  
            user=System.currentPagereference().getParameters().get('user');
            currentProjectID=System.currentPagereference().getParameters().get('project');
            modList=[select  id, moduleName__c from Module__c where id in (Select user_of_module__c  from ModuleUser__c where EmpID__c =:user) ];
            moduleInstance=new Module__c();
            reqInstance=new Requirement__c();
            //reqInstance=new Requirement__c();
            checkbool=false;
            addModuleBool=false;
            addReqBool=false;
            addTestcaseBool=false;
            showTestcaseBool=false;
            //editedReqInst=new Requirement__c();
            getModules();
            
     }       
                 
     public List<moduleWrap> getModules(){
       
       //if(moduleList==null){
            moduleList=new List<moduleWrap>();
            for(Module__c c:[select  id, moduleName__c,Name from Module__c where id in (Select user_of_module__c  from ModuleUser__c where EmpID__c =:user) ])
            {
                   moduleList.add(new moduleWrap(c,c.Name));
            }
       // }            
        return moduleList;
    } 
    public PageReference Requirements(){
       
            reqList=new List<reqWrap>();
            for(Requirement__c r:[select id,Name,reqName__c,moduleID__r.Name,moduleID__r.moduleSpecification__c,
            moduleID__r.moduleName__c,moduleId__r.priority__c,moduleID__r.startDate__c,moduleID__r.endDate__c from Requirement__c where moduleID__r.id=:moduleParam])
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
    public PageReference insertRequirement()             
    {
        reqInstance=new Requirement__c(reqName__c=name,reqDescription__c=description,reqPriority__c=priority,reqProposedBy__c=propby,reqType__c=reqtype,reqStatus__c=status,moduleID__c=moduleParam);
        insert reqInstance;
        addReqBool=false;
        return null;
    }
    public void savenNew()
    {
        reqInstance=new Requirement__c(reqName__c=name,reqDescription__c=description,reqPriority__c=priority,reqProposedBy__c=propby,reqType__c=reqtype,reqStatus__c=status,moduleID__c=moduleParam);
        insert reqInstance;
       
    }
     
    /* public PageReference linkToEditPage(){
     PageReference newPage=new PageReference('/apex/EditRequirement?reqId='+reqId);
     return newPage;
     } */ 
     public PageReference showSelectedReq()
     {
           //editedReqInst=new Requirement__c();
          editedReqInst=[select Name,reqType__c,reqDescription__c,reqName__c,reqPriority__c,reqProposedBy__c,reqStatus__c,reqVersion__c
                         from Requirement__c where Name=:reqId limit 1];  
          //return Page.EditRequirement;
          check=reqId;
          return null;
     }                       
     public PageReference updateRequirement(){ //function to update the requirement
       
         update editedReqInst;
         //PageReference oldPage=Page.RequirementDetail;
         //oldPage.setRedirect(true);
         return Page.RequirementDetail;                //redirect to the previous page after edit operation
         //return null;
     }
    public PageReference cancelReq()
    {
        addReqBool=false;
        return null;
    }
    
     public PageReference returnEdit(){   //redirect to the previous page after pressing cancel button
     return Page.RequirementDetail;
     }         
          
}