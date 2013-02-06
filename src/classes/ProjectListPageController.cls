public class ProjectListPageController{
    public boolean showDetail{get;set;}     // Controls weather to show project detail panel or not
    public boolean createProj{get;set;}     // controls visibility of 'create new project' button
    public boolean editDetail{get;set;}     // Controls weather to show edit panel of project or not
    public String currentUserName {get;set;}     //Name of person logging in. Used to show welcome message to user
    public String selectedProjId {get;set;}     // stores id send as parameter, that represents currently selected project. 
    public boolean booleanEdit{get;set;}     // Edit button visibility controller
    public boolean booleanDelete{get;set;}     // Date Button visibility controller
    public boolean booleanOpen{get;set;}      // Open button visibility controller
    public boolean booleanOpenPanel{get;set;}    // Open as panel visibility controller
    public String user {get;set;}     // stores id of user passed from previous page
    public String selectRole {get;set;}     // The Role with which project need to be opened
    public Project__c projObj {get;set;}    // represents One of the projects under current selection
    public List<ModuleUser__c> rolesObj {get;set;}
    public ModuleUser__c roleobj {get;set;}
    public List<Module__c> moduleList{get;set;} 
    public Set <Project__c> projList {get;set;}
    public List <Project__c> prjList {get;set;}       //List of Projects 
    public List<SelectOption> options {get;set;}     // list of role options with which project can be opened   
    public String role{get;set;}
    public String[] rolearray {get;set;}
    public Project__c tobeEdited{get;set;}
    public set<String> myString{get;set;}
    public String msg{get;set;}// used to show a message on screen if there are no projects
    public ProjectListPageController(){   //constructor     
        user=System.currentPagereference().getParameters().get('user');//gets the parameter passed from previous page
        myString=new Set<String>();
        projList=new Set <Project__c> ();
        prjList=new List <Project__c> ();
        projObj=new Project__c();
        rolesObj=new List<ModuleUser__c>();
        roleobj=new ModuleUser__c();
        preparePage();       
        }//end of constructor
    public void preparePage()     {    // prepares page for user logging in
        Employee__c empobj; // local employee variable
        try{
            showDetail=true; //show project detail is true initially
            booleanOpen=true;  // Open button shown
            msg='';// There is no msg to show
            empobj=[select empName__c , empDesignation__c from Employee__c where id=:user];
            currentUserName=empobj.empName__c;
            prjList=[select id,Name,projectTitle__c,projectVersion__c,status__c, budget__c,startDate__c,endDate__c,Technology__c, 
                       projectDescription__c from Project__c where projectManagerID__c=:user order by  projectTitle__c asc];
            if (prjList.size()!=0){// There are some projects whose manager is logging in person
                role='Manager';
                createProj=true;// allow him to create more project
                booleanEdit=true;// show edit button
                booleanDelete=true; //show delete button
                projObj=[select Name, projectTitle__c,projectVersion__c,status__c, budget__c,startDate__c,endDate__c,Technology__c, projectDescription__c from Project__c where projectManagerID__c=:user order by  projectTitle__c asc limit 1];
                selectedProjId=prjList[0].id;// set first project in the list as default
                 }
             else if((empObj.empDesignation__c).equals('Manager')) {// there are no projects but still logging person is Manager
                 createProj=true;// allow to create project
                 showDetail=false;// show project detail
                 msg='No Projects created yet.Click \'Start New Project\' to create a new Project.';// message shown to him at the place of list
                 }
             else {// logging person is not Manager
                  /*
                  createProjectList();// prepare a list of project for user
                  rolesObj=[select ProjectUserRole__r.projectRole__c from ModuleUser__c where EmpID__c=:user and projectID__c=:selectedProjId];// fetch all roles of user
                  options = new List<SelectOption>();               
                   for(ModuleUser__c cc:rolesObj)  {
                       myString.add(cc.ProjectUserRole__r.projectRole__c);
                       }
                   if(myString.size()>1){  // user have more than one role to work with
                      booleanOpenPanel=true; // allow him to chose one role to work with
                      booleanOpen=false; // hide normal open button
                      for(String a:myString)   
                         options.add(new SelectOption(a,a));// prepare options with which he can log in
                      }
                   else 
                      role=rolesObj[0].ProjectUserRole__r.projectRole__c; // allocate default role */
                       createProjectList();
                       ProjectRoles();    
                  }
                 
               }
                catch(Exception e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error In Loading Page');
                    ApexPages.addMessage(myMsg);
                    }
          }//End of preparePage()
          
        public void ProjectRoles()
        {
             
                  //createProjectList();// prepare a list of project for user
                  rolesObj=[select ProjectUserRole__r.projectRole__c from ModuleUser__c where EmpID__c=:user and projectID__c=:selectedProjId];// fetch all roles of user
                  options = new List<SelectOption>();               
                   for(ModuleUser__c cc:rolesObj)  {
                       myString.add(cc.ProjectUserRole__r.projectRole__c);
                       }
                   if(myString.size()>1){  // user have more than one role to work with
                      booleanOpenPanel=true; // allow him to chose one role to work with
                      booleanOpen=false; // hide normal open button
                      for(String a:myString)   
                         options.add(new SelectOption(a,a));// prepare options with which he can log in
                      }
                   else 
                      role=rolesObj[0].ProjectUserRole__r.projectRole__c; // allocate default role        
             
        }     
        public void projData(){  //called when user clicke on on of the project in list
            showDetail=true; // render detail panel
            editDetail=false; // if edit panel is active hide it
            try{
                projObj=new Project__c();
                projObj=[select Name, projectTitle__c,projectVersion__c,status__c, budget__c,startDate__c,endDate__c,Technology__c, projectDescription__c from Project__c where id=:selectedProjId];
                }
                catch(Exception e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'my error msg');
                    ApexPages.addMessage(myMsg);
                    }
             if(role!='Manager')       
                    ProjectRoles();       
            }//End of projData()
        public PageReference showWizard() {// forwards to create project page when user clicks on 'Create Project button'
            PageReference page = new PageReference('/apex/createProjectPage?user='+user);
            return page;
            }     
        public List<Project__c> getProjectList(){// returns a list of all projects that logging person can work on 
            return prjList;
            }
        public PageReference openProject(){
            PageReference page;
            try{
                if(booleanOpenPanel==true)
                     role=selectRole;
                if (role=='Manager')    {
                    page = new PageReference('/apex/ProjectAccount?user='+user+'&project='+selectedProjId);
                    }
                if (role=='Tester')     {
                     page = new PageReference('/apex/TesterAccountPage?user='+user+'&project='+selectedProjId);
                    }
                if (role=='TestCaseWriter')        {
                     page = new PageReference('/apex/TestCaseWriterPage?user='+user+'&project='+selectedProjId);
                    }
                if (role=='RequirementWriter')     {
                     page = new PageReference('/apex/RequirementWriterPage?user='+user+'&project='+selectedProjId);
                    }    
                }
                catch(Exception e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'my error msg');
                    ApexPages.addMessage(myMsg);
                    }
                return page;
            }// end of openProject()
        public void createProjectList(){
             try{
                  moduleList=[select  id, projectID__c from Module__c where id in (Select user_of_module__c  from ModuleUser__c where EmpID__c =:user) order by projectID__c];
                  for(Module__c m:moduleList)       {
                        Project__c prjInst=new Project__c();
                        prjInst=[select id,Name, projectTitle__c,projectVersion__c,status__c, budget__c,startDate__c,endDate__c,Technology__c, projectDescription__c from Project__c where id=:m.projectID__c];
                        projList.add(prjInst);
                        prjList=new List<Project__c>(projList);
                        }
                  projObj=[select Name, projectTitle__c,projectVersion__c,status__c, budget__c,startDate__c,endDate__c,Technology__c, projectDescription__c from Project__c where projectTitle__c=:prjList[0].projectTitle__c  order by  projectTitle__c asc limit 1];
                  selectedProjId=prjList[0].id;
                }
                catch(Exception e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'my error msg');
                    ApexPages.addMessage(myMsg);
                    }
             }// end of createProjectList()
        public PageReference editProject()   {   //function to edit selected project from project Page    
           editDetail=true;
           showDetail=false;      
           if (SelectedProjId == null) {
              return null;
               }
           PageReference newPage=Page.projectPage;
               return newPage;
            }   
       public PageReference updateProject(){
            try{
               update projObj;
              }
            catch(Exception e){
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'my error msg');
               ApexPages.addMessage(myMsg);
              }
           editDetail=false;
           showDetail=true;
           return Page.ProjectPage;
           }   
       public PageReference cancelProject(){   
            editDetail=false;
            showDetail=true;
            return Page.projectPage;
           }   
       public void deleteProject() {
           try{
               Project__c temp=new Project__c();
               temp=[select Name, projectTitle__c,projectVersion__c,status__c, budget__c,startDate__c,endDate__c,Technology__c, projectDescription__c from Project__c where id=:selectedProjId];
               delete temp;
               prjList=new List<Project__c>();
               prjList=[select Name, projectTitle__c,projectVersion__c,status__c, budget__c,startDate__c,endDate__c,Technology__c, projectDescription__c from Project__c where projectManagerID__c=:user];
               projObj=[select Name, projectTitle__c,projectVersion__c,status__c, budget__c,startDate__c,endDate__c,Technology__c, projectDescription__c from Project__c where id=:prjList[0].id];
               selectedProjID=prjList[0].id;
               }
                catch(Exception e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'my error msg');
                    ApexPages.addMessage(myMsg);
                   }    
           }   
}//end of class