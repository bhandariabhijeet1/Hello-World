public class ProjectCon
{
    public String currentUser{get;set;} //currentUser stores the userEmailID who logged in. 
    public Client__c clientIns{get;set;}  
    public Project__c projIns{get;set;}
    public loginController loginObject {get;set;} //controller to control Employee login process
    public String mySelectedTab{get;set;} //show which tab to show in project create wizard
    public boolean distab1{get;set;} 
    public boolean distab2{get;set;}
    public boolean distab3{get;set;} //distab1,distab2,distab3 are used to enable and disable tabs while creating 
    public List <SelectOption> allClients {get;set;}
    public String selectedClient{get;set;}
    public boolean showTopPanel{get;set;} 
    public boolean showMiddlePanel{get;set;}
    public boolean showLastPanel{get;set;}
    public employee__c eobj{get;set;}
    public ProjectAccount__c prjAcc {get;set;}  
    public ProjectAccount__c prjAccount {get;set;} 
    public boolean showlogin{get;set;}
    public boolean showWizard{get;set;}
    public  ProjectCon()
        {
        showlogin=true;
        showWizard=false;
        prjAcc=new ProjectAccount__c();
        clientIns = new Client__c();
        eobj=new employee__C();
        loginObject = new loginController();
        showTopPanel=true;
        showMiddlePanel=false;
        showLastPanel=true;
        projIns = new Project__c(); 
        allclients=new List<SelectOption>(); 
        distab1=false;
        distab2=true;
         distab3=true;
         mySelectedTab='step1';           
        }
    public PageReference performLogin()
        {
        loginObject.name=currentUser;
        PageReference page= loginObject.login();
        return page;
        }
    public String getUserID()
        {
        eobj=[select Name from Employee__c where empEmail__c=:currentUser ];
        return eobj.Name;
         }      
    public List<SelectOption> getItems()
        {
        allclients=new List<SelectOption>(); 
        for(List<Client__c> clientList: [select  clientCompany__c from Client__c ])
                {
                for(Client__c c: clientList)
                    {
                     allClients.add(new SelectOption(c.clientCompany__c,c.clientCompany__c));
                    }  
                return allClients;
                }   
         return allClients;
        }
    public String getselectedClient() {
        return selectedClient;
    }
      public void setselectedClient(String client) {
        this.selectedClient = client;
    } 
    public PageReference checkAvailability()
    {
    List  <ProjectAccount__c> prjList=new list <ProjectAccount__c>();
    prjList=[Select ProjectLoginID__c from ProjectAccount__c where ProjectLoginID__c=:prjAcc.ProjectLoginID__c ];
    if (prjList.size()!=0)
    {
     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'This Id is already occupied and cannot be taken'));
    }
    else
    {
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'This Id is available'));
    }
    PageReference page = new PageReference('/apex/Project');
    return page;
    }
    public PageReference moveToStep2 ()
    {
    distab1=true;
    distab2=false;
    distab3=true;
    mySelectedTab='step2';
    PageReference page = new PageReference('/apex/Project');
    return page;
    }
    
    public PageReference moveToStep3 ()
    {
    distab1=true;
    distab3=false;
    distab2=true;
    mySelectedTab='step3';
    PageReference page = new PageReference('/apex/Project');
    return page;
    }
     public PageReference moveToStep1 ()
    {
    distab1=false;
    distab2=true;
    distab3=true;
    mySelectedTab='step1';
    PageReference page = new PageReference('/apex/Project');
    return page;
    }
    public PageReference showOption()
    {
     showTopPanel=false;
     showMiddlePanel=true;
     showLastPanel=false;  
     PageReference page = new PageReference('/apex/Project');
     return page;
    }
    
    public PageReference addItems()
    {
        insert projIns;
        Project__c prj=new Project__c();
        prj=[select Name from Project__c where projectTitle__c=:projIns.projectTitle__c and projectVersion__c=:projIns.projectVersion__c ];
       
        prjAccount=new ProjectAccount__c(ProjectID__c=prj.id,ProjectLoginID__c=prjAcc.ProjectLoginID__c,ProjectPassword__c=prjAcc.ProjectPassword__c);
      //  .ProjectId__c=prj.Name;
        insert prjAccount;
        
        PageReference page=new PageReference('/apex/directingPage');
        return page;
    }
     public PageReference addClientItems()    
    {        
        insert clientIns; 
         showTopPanel=true;
         showMiddlePanel=false;
         showLastPanel=true;
        PageReference page = new PageReference('/apex/Project');
         return page;   
    }
}