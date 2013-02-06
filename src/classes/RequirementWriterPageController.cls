public class RequirementWriterPageController    {
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
    public RequirementWriterPageController()    {
        
        user=System.currentPagereference().getParameters().get('user');
        currentProjectID=System.currentPagereference().getParameters().get('project');
        selectedrole='a0G90000002af7d';
        frameSource='/apex/ReqAddPage?user='+user+'&project='+currentProjectId;
        showDetail=false;
        more=true;
        less=false;
        projObj=new Project__c();
       // user=System.currentPagereference().getParameters().get('user');
       // currentProjectID=System.currentPagereference().getParameters().get('project');
        currentUser=getUserName();
        projObj=[select Name,id, projectTitle__c,projectVersion__c,status__c, budget__c,startDate__c,endDate__c,Technology__c, projectDescription__c from Project__c where id=:currentProjectID];
        }
    public String getUserName()     {
        Employee__c emp=new Employee__c();
        emp=[select empName__c from Employee__c where id=:user];
        return emp.empName__c;
        }
    public Integer getModuleCount ()    {
        modList=new List<Module__c>();
        modlist=[select Name from Module__c where projectID__C=:currentProjectID];
        return modlist.size();
        }
    public void addModule()    {
        frameSource='/apex/moduleDetail1?project='+currentProjectID;
        }
    public void viewModule()
    {
         frameSource='/apex/ViewModuleDetail1?project='+currentProjectID; 
    }
    public void viewRequirement()
    {
         frameSource='/apex/RequirementView?user='+user+'&project='+currentProjectID+'&role='+selectedrole; 
    }
    public void addRequirement()
    {
         frameSource='/apex/ReqAddPage?user='+user+'&project='+currentProjectId+'&role='+selectedrole;
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
        //frameSource='/apex/showmodulereq?user='+user+'&project='+currentProjectID;
        //return Page.'/apex/projectPage?user='+user;
        PageReference page = new PageReference('/apex/projectPage?user='+user);
        return page;       
    }
    }