public class ProjectAccountController    {
    public Project__c projObj {get;set;}
    public String user {get;set;}
    public String currentUser{get;set;}
    public string currentProjectID{get;set;}
    public boolean more{get;set;}
    public boolean less{get;set;}
    public boolean showDetail{get;set;}
    public String frameSource{get;set;}
    public List <Module__c> modlist{get;set;}
    public  List <Requirement__c> reqList {get;set;}
    public boolean disableViewModule{get;set;}
    public ProjectAccountController()    {
     try{
        
        showDetail=false;
        more=true;
        less=false;
        projObj=new Project__c();
        user=System.currentPagereference().getParameters().get('user');
        currentProjectID=System.currentPagereference().getParameters().get('project');
        currentUser=getUserName();
        projObj=[select Name,id, projectTitle__c,projectVersion__c,status__c, budget__c,startDate__c,endDate__c,Technology__c, projectDescription__c from Project__c where id=:currentProjectID];
        getTestCaseCount();
         disableViewModule=false;      
        }
     catch (Exception e) {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error'));
        }
        }
    public String getUserName()     {
        Employee__c emp=new Employee__c();
     try{
        emp=[select empName__c from Employee__c where id=:user];
        }
     catch (Exception e) {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error'));
        }
        return emp.empName__c;
        }
   
    public Integer getModuleCount ()    {
        modList=new List<Module__c>();
     try{
        modlist=[select Name from Module__c where projectID__C=:currentProjectID];
        }
     catch (Exception e) {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error'));
        }
        return modlist.size();
        }
    public Integer getRequirementCount ()    {
        reqList=new List <Requirement__c>();
     try{
        reqList=[Select Name from Requirement__c where moduleID__c in (select id from Module__c where projectID__c=:CurrentProjectID) ];
        }
        catch (Exception e) {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error'));
        }
        return reqList.size(); 
        }
    public Integer getTeamCount()        {
        List<ModuleUser__c> userList=new List<ModuleUser__c>();
        List<ModuleUser__c> refinedList=new List<ModuleUser__c>();
        //Set<ModuleUser__c> userSet=new Set<ModuleUser__c>();
     try{
        userList=[select EmpID__c from ModuleUser__c where projectID__c=:currentProjectID];
        for(ModuleUser__c m:userList)
            {
            Boolean addItem=true;
            for(ModuleUser__c temp:refinedList)
                {
                 String s=temp.EmpID__c;
                if(s.equals(m.EmpID__c))
                     addItem=false;
                }
                 if(addItem)
                 refinedList.add(m);
             }
         }
         catch (ListException e) {
             ApexPages.addMessages(e);
         }          
        return refinedList.size();
        }
    
    
     
     public integer getTestCaseCount(){
     return [select Count() from TestCase__c where reqID__r.moduleID__r.projectID__c=:currentProjectID];
     }
     
     public integer getDefectCount(){
     return [select Count() from Defect__c where TestCaseBuildID__r.testCaseId__r.reqID__r.moduleID__r.projectID__c=:currentProjectID and defectStatus__c <>'closed'];
     }
     
    
    public void viewRequirement()
    {
        frameSource='/apex/RequirementView?user='+user+'&project='+currentProjectID+'&role=admin';
    }
    public void addRequirement()
    {
        frameSource='/apex/ReqAddPage?user='+user+'&project='+currentProjectID+'&role=admin';
    }
    public void addModule()    {
        frameSource='/apex/moduleDetail?project='+currentProjectID;
        }
    public void viewModule()
    {
          if(getModuleCount()!=0)
         frameSource='/apex/ViewModuleDetail?project='+currentProjectID; 
         else    {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No modules created yet.Click on \'Add Module\' to insert new module.'));
        frameSource='';
        }
    } 
    public void teamManage()
    {
           frameSource='/apex/Account?user='+user+'&project='+currentProjectID; 
    }       
   /* public void viewMembers()
    {
         frameSource='/apex/ViewModuleUserPage?project='+currentProjectID; 
    }      
    public void addUser()
    {
         frameSource='/apex/AdduserModulePage?project='+currentProjectID; 
    } */ 
    public void viewAllTestCases()    {
    frameSource='/apex/viewAllTestCasesPage?user='+user+'&project='+currentProjectID+'&role=admin';
    }
    public void viewModules()    {
    frameSource='/apex/showmodulereq?user='+user+'&project='+currentProjectID+'&role=admin';
    }  
    public void viewRequirementReports()
    {
        frameSource='/apex/RequirementReportsPage?project='+currentProjectID; 
    }      
    public void viewTestcaseReports()
    {
        frameSource='/apex/TestcaseReportsPage?project='+currentProjectID; 
    }
    public void viewDefectReports()
    {
        
        //frameSource='/apex/ReportsPage?project='+currentProjectID; 
        
    }
    public void showProjectDetail()    {
        if (more)    {
           more=false;
           less=true; 
           showDetail=true;
           }
         else if (less)    {
             less=false;
             more=true;
             showDetail=false;
             }
         }
        public PageReference backToHomePage()    {
        PageReference page = new PageReference('/apex/projectPage?user='+user);
        return page;
        
        }   
    
    }