public class TesterAccountPageController    {
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
    public TesterAccountPageController()    {
      try{
        user=System.currentPagereference().getParameters().get('user');
        //user='a0890000003tSFPAA2';
        currentProjectID=System.currentPagereference().getParameters().get('project');
        selectedrole='a0G90000002af7i';
        frameSource='/apex/testerModule?user='+user+'&project='+currentProjectId;
        showDetail=false;
        more=true;
        less=false;
        projObj=new Project__c();
        
        currentUser=getUserName();
        projObj=[select Name,id, projectTitle__c,projectVersion__c,status__c, budget__c,startDate__c,endDate__c,Technology__c, projectDescription__c from Project__c where id=:currentProjectID];
        }
      catch(Exception e){       
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error In Loading Page');       
         ApexPages.addMessage(myMsg);     
       }

        }
        
    public String getUserName()     {
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
    public Integer getModuleCount ()   {
       try{
        modList=new List<Module__c>();
        modlist=[select Name from Module__c where projectID__C=:currentProjectID];
        }
        catch(Exception e){       
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error In Fetching List');       
          ApexPages.addMessage(myMsg);     
        }
        return modlist.size();
        }
    public void viewModule()
    {
         frameSource='/apex/ViewModuleDetail1?project='+currentProjectID; 
    }
    public void viewRequirement()
    {
         frameSource='/apex/RequirementView?user='+user+'&project='+currentProjectId+'&role='+selectedrole; 
    }
    public void addModule()    {
        frameSource='/apex/moduleDetail?project='+currentProjectID;
        }
    /*public void viewModule()
    {
         frameSource='/apex/testerModule?user='+user+'&project='+currentProjectId;    
         //frameSource='/apex/ViewModuleDetail?project='+currentProjectID; 
    }        
    */
    public PageReference logout(){
    PageReference newPage=Page.homePage;
    user='';
    currentProjectID='';
    newPage.setRedirect(true);
    return newPage;
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
         
         public void executeTestCases()    {
        frameSource='/apex/testerModule?user='+user+'&project='+currentProjectID;
        }
         
         public void viewAllTestCases()    {
        frameSource='/apex/viewAllTestCasesPage?user='+user+'&project='+currentProjectID;
        }
         public PageReference backToHomePage()    {
        //frameSource='/apex/showmodulereq?user='+user+'&project='+currentProjectID;
        //return Page.'/apex/projectPage?user='+user;
        PageReference page = new PageReference('/apex/projectPage?user='+user);
        return page;
        
        }  
    }