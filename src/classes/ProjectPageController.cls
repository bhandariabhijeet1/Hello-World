public class ProjectPageController{
    public Project__c projObj {get;set;}
    public List<ModuleUser__c> rolesObj {get;set;}
    public ModuleUser__c roleobj {get;set;}
    public List<Module__c> moduleList{get;set;}
    public boolean showDetail{get;set;}
    public boolean createProj{get;set;}
    public boolean editDetail{get;set;}
    public boolean booleanEdit{get;set;}
    public boolean booleanDelete{get;set;}
    public boolean booleanOpen{get;set;}
    public boolean booleanOpenPanel{get;set;}
    public String user {get;set;}
    public String selectRole {get;set;}
    public String selectedProjId {get;set;}
    public Set <Project__c> projList {get;set;}
    public List <Project__c> prjList {get;set;}
    
    public List<SelectOption> options {get;set;}
    public String currentUserName {get;set;}
    public Employee__c empobj{get;set;}
    public String role{get;set;}
    public String[] rolearray {get;set;}
    public Project__c tobeEdited{get;set;}
    public set<String> myString{get;set;}
    public String msg{get;set;}// used to show a message on screen if there are no projects
    //constructor
    pubLic ProjectPageController(){
     try{
        showDetail=true;
        editDetail=false;
        createProj=false;
        booleanEdit=false;
        booleanOpen=true;
        booleanOpenPanel=false;
        booleanDelete=false;
        msg='';
        user=System.currentPagereference().getParameters().get('user');
        myString=new Set<String>();
        projList=new Set <Project__c> ();
        prjList=new List <Project__c> ();
        projObj=new Project__c();
        rolesObj=new List<ModuleUser__c>();
        roleobj=new ModuleUser__c();
        empobj=[select empName__c , empDesignation__c from Employee__c where id=:user];
        currentUserName=empobj.empName__c;
        prjList=[select id,Name,projectTitle__c,projectVersion__c,status__c, budget__c,startDate__c,endDate__c,Technology__c, 
                       projectDescription__c from Project__c where projectManagerID__c=:user order by  projectTitle__c asc];
         
       // prjList=[select ProjectID__c,Name,ProjectID__r.projectTitle__c from ModuleUser__c where EmpID__c=:user and ProjectUserRole__r.projectRole__c='Manager' order by  ProjectID__r.projectTitle__c asc];
        
       //prjList=[select id,Name,projectTitle__c,projectVersion__c,status__c,budget__c,startDate__c,endDate__c,Technology__c,projectDescription__c
              //  from Project__c where id in(select projectID__c from ModuleUser__c where EmpID__c=:user and ProjectUserRole__r.projectRole__c='Manager') order by projectTitle__c asc];      
        
        if (prjList.size()!=0){
            role='Manager';
            createProj=true;
            booleanEdit=true;
            booleanDelete=true;
            projObj=[select Name, projectTitle__c,projectVersion__c,status__c, budget__c,startDate__c,endDate__c,Technology__c, projectDescription__c from Project__c where projectManagerID__c=:user order by  projectTitle__c asc limit 1];
            selectedProjId=prjList[0].id;
         }
         else if( (empObj.empDesignation__c).equals('Manager'))
         {
         createProj=true;
         showDetail=false;
         msg='No Projects created yet.Click \'Start New Project\' to create a new Project.';
         }
         else
         {
              createProjectList();
              rolesObj=[select ProjectUserRole__r.projectRole__c from ModuleUser__c where EmpID__c=:user];
              options = new List<SelectOption>();  
                
               for(ModuleUser__c cc:rolesObj)
               {
                       myString.add(cc.ProjectUserRole__r.projectRole__c);
               }
               if(myString.size()>1){  
                  booleanOpenPanel=true;
                  booleanOpen=false; 
                  for(String a:myString)   
                     options.add(new SelectOption(a,a));
                }
               else 
                  role=rolesObj[0].ProjectUserRole__r.projectRole__c;      
          }
        }
        catch(Exception e){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error In Loading Page');
        ApexPages.addMessage(myMsg);
        }
    }//end of constructor
    public List<Project__c> getProjectList(){
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
    }
    public PageReference showWizard()
    {
       PageReference page = new PageReference('/apex/createProjectPage?user='+user);
       return page;
    }     
    
    public void createProjectList(){
    try{
       moduleList=[select  id, projectID__c from Module__c where id in (Select user_of_module__c  from ModuleUser__c where EmpID__c =:user) order by projectID__c];
      
    for(Module__c m:moduleList)
    {
        Project__c prjInst=new Project__c();
        prjInst=[select id,Name, projectTitle__c,projectVersion__c,status__c, budget__c,startDate__c,endDate__c,Technology__c, projectDescription__c from Project__c where id=:m.projectID__c];
        projList.add(prjInst);
        prjList=new List<Project__c>(projList);
    //prjList=projList;
    
    }
     
     projObj=[select Name, projectTitle__c,projectVersion__c,status__c, budget__c,startDate__c,endDate__c,Technology__c, projectDescription__c from Project__c where projectTitle__c=:prjList[0].projectTitle__c  order by  projectTitle__c asc limit 1];
     selectedProjId=prjList[0].id;
    }
    catch(Exception e){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'my error msg');
        ApexPages.addMessage(myMsg);
    }
  }
   
   //function to edit selected project from project Page    
   public PageReference editProject()   {
   
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
       Return Page.ProjectPage;
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
       /* PageReference newPage;
        newPage=new PageReference('/apex/projectPage?user='+user+''); 
        return newPage;*/
   }
    
    public void projData(){
        showDetail=true;
        try{
        projObj=new Project__c();
        projObj=[select Name, projectTitle__c,projectVersion__c,status__c, budget__c,startDate__c,endDate__c,Technology__c, projectDescription__c from Project__c where id=:selectedProjId];
        }
        catch(Exception e){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'my error msg');
        ApexPages.addMessage(myMsg);
        }
    }
   
}//end of class
    
    
    
    
/*if (prjList.size()==0)     {
         checkUserRole();
            ModuleUser__c roleObj=new ModuleUser__c(); 
            roleObj=[select userRole__c from ModuleUser__c where EmpID__c =:user limit 1];
            role=roleObj.userRole__c;
            createProjectList();
           
            }
        moduleList=new List<Module__c>();*/
        
//user role checking
  /* public void checkUserRole(){
  
    roleObj=[select userRole__c from ModuleUser__c where EmpID__c =:user limit 1];
    rolearray=roleObj.userRole__c.split(',',0);
    if(rolearray.size()>1){
    booleanOpenPanel=true;
    booleanOpen=false;
    //return;
    integer len=rolearray[0].length();
    rolearray[0]=rolearray[0].substring(1,len);
    rolearray[rolearray.size()-1]=rolearray[rolearray.size()-1].substring(0,rolearray[rolearray.size()-1].length()-1);
    options = new List<SelectOption>(); 
        for(integer i=0;i<rolearray.size();i++)
        {
        
        options.add(new SelectOption(rolearray[i],rolearray[i])); 
        }
    
    }
    
    
    }
    public void checkUserRole(){
    
       rolesObj=[select ProjectUserRole__r.projectRole__c from ModuleUser__c where EmpID__c=:user];
       options = new List<SelectOption>();
       if(rolesObj.size()>1)
       {
            booleanOpenPanel=true;
            booleanOpen=false;
            for(ModuleUser__c cc:rolesObj){
              options.add(new SelectOption(cc.ProjectUserRole__r.projectRole__c,cc.ProjectUserRole__r.projectRole__c));
            }  
        }
    }
    public PageReference fetchRoleModule(){
    PageReference page;
     if (selectRole=='tester')     {
             page = new PageReference('/apex/TesterAccountPage?user='+user+'&project='+selectedProjId);
            }
        if (selectRole=='testCaseWriter')        {
             page = new PageReference('/apex/TestCaseWriterPage?user='+user+'&project='+selectedProjId);
            }
        if (selectRole=='reqWriter')     {
             page = new PageReference('/apex/RequirementWriterPage?user='+user+'&project='+selectedProjId);
            }
        return page;
    }*/