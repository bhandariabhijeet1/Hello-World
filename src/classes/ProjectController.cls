public class ProjectController
{
    public Project__c projIns{get;set;} //store project information
    
    public ClientController clientControlObject {get;set;}//controller to control operations related to client  
    public OrganizationLoginController orgLoginObj {get;set;}
    public String mySelectedTab{get;set;} //show which tab to show in project create wizard
    public boolean distab1{get;set;} 
    public boolean distab2{get;set;}
    public boolean distab3{get;set;} //distab1,distab2,distab3 are used to enable and disable tabs while creating project
     
    public string user{get;set;} 
    public string currentUser{get;set;}
    public  ProjectController()
    {
        user=System.currentPagereference().getParameters().get('user');
        orgLoginObj =new OrganizationLoginController();
        clientControlObject=new ClientController();
        user=System.currentPagereference().getParameters().get('user');
        currentUser=getUserName();
        projIns = new Project__c(); 
        distab1=false;
        distab2=true;
        distab3=true;
        mySelectedTab='step1'; 
    }
    public String getUserName()     
    {
        Employee__c emp=new Employee__c();
        try{
              emp=[select empName__c from Employee__c where id=:user];
           }
         catch (Exception e)
         {
              //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error In Loading Page'));
              ApexPages.addMessages(e);
          }
        return emp.empName__c;
     }      
    public PageReference moveToStep2 ()
    {
           distab1=true;
           distab2=false;
           distab3=true;
           mySelectedTab='step2';
           PageReference page = new PageReference('/apex/createProjectPage');
           return page;
    }
    public PageReference moveToStep3 ()
    {
        distab1=true;
        distab3=false;
        distab2=true;
        mySelectedTab='step3';
        PageReference page = new PageReference('/apex/createProjectPage');
        return page;
    }
    public PageReference moveToStep1 ()
    {
        distab1=false;
        distab2=true;
        distab3=true;
        mySelectedTab='step1';
        PageReference page = new PageReference('/apex/createProjectPage');
        return page;
     }    
    public PageReference addItems()/*inserting project details*/
    {    
        String tempVar=clientControlObject.SelectedClientID();
        Project__c temp=new Project__c(budget__C=projIns.budget__c,clientID__c=tempVar,projectManagerID__c=user,startDate__c=projIns.startDate__c,endDate__c=projIns.endDate__c,projectTitle__c=projIns.projectTitle__c,projectDescription__c=projIns.projectDescription__c,projectVersion__c=projIns.projectVersion__c,status__c='Initiated',technology__c=projIns.technology__c);
        try{
        insert temp;  
        }
        catch(Exception e){
        //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error In Fetching List');
        //ApexPages.addMessage(myMsg);
        ApexPages.addMessages(e);
        }      
        //Project__c prj=new Project__c();
       // prj=[select Name from Project__c where projectTitle__c=:projIns.projectTitle__c and projectVersion__c=:projIns.projectVersion__c ];
        PageReference page=new PageReference('/apex/projectPage?user='+user+'');
        return page;
      }
     public PageReference backToHomePage()    
     {
        PageReference page = new PageReference('/apex/projectPage?user='+user);
        return page;
        
      }   
 }