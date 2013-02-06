public class AddModuleController {      
      
       public string userName;//store the empid of emp selected in a module
       public string moduleName{get;set;}
       public string role{get;set;}
       public List<SelectOption> options;  //create selectoptions work as the child of selectcheckboxes in moduledetail vf
       public Employee__c empObject{get;set;}//used to collect information about user details
       public ModuleUser__c moduleUserInstance{get;set;}//child object of the module detail
       public List<SelectOption> options1;
       public List<SelectOption> options2;
       public boolean boolean1{get;set;}
       public boolean boolean2{get;set;}
       public string renderPart{get;set;}
       public Module__c module{get;set;}
       public string param{get;set;} 
       public Module__c moduleObj{get;set;}
       public boolean boolean3{get;set;}  
       
       public String currentProjectID {get;set;} 
       public string user{get;set;} 
       
       public List<ModuleUser__c> empList {get;set;}
       
       public Set<String> empSet {get;set;}
       
       public ModuleUser__c moduleUserInst {get;set;}
       public Module__c moduleInsObj {get;set;}
       
       public AddModuleController()
       {
                empObject=new Employee__c();
                 currentProjectID=System.currentPagereference().getParameters().get('project');
                 user=System.currentPagereference().getParameters().get('user');
                  moduleObj=new Module__c();
               // moduleUserInstance=new ModuleUser__c();
               
               boolean3=false;
               boolean1=false;
              //renderPart='detailPart2';
              GlobalUserExist();
                  
        } 
        ///////////Work in progress///////////
        public boolean GlobalUserExist()
        {
          List  <Module__c> moduleList=new List <Module__c>();
          List  <ModuleUser__c> moduleUser=new List <ModuleUser__c>();
          moduleList= [select Name from Module__c where projectID__c=:currentProjectID];
          List <AggregateResult> aggreList= new List <AggregateResult>();
          aggreList=[select EmpID__c,user_of_module__c,count(ProjectUserRole__c)  from moduleUser__c where user_of_module__c in (select id from Module__c where projectID__c=:currentProjectID) group by EmpID__c,user_of_module__c ];
          return true;
        } 
        //////////work in progress///////////  
        public List<SelectOption> getEmployee()
        {
           
            options = new List<SelectOption>();
            
            for (Employee__c a : [select Name,empName__c from Employee__c where BU__c='cloud' order by Name]) {  //Assign userID as the itemlabel and 
                                                                                                                 //itemvalue to the selectoption object 
            options.add(new SelectOption(a.Name,a.empName__c));
            }
            return options; //return set of selectoption to the selectcheckboxes
        }
        public List<SelectOption> getRoles()
        {
               options2=new List<SelectOption>();
               for(ProjectRole__c cc:[select Name,projectRole__c from ProjectRole__c where projectRole__c!='Manager'])
               {
                    options2.add(new SelectOption(cc.Name,cc.projectRole__c));
                    
               }
               return options2;
        }            
        public List<SelectOption> getAllModule() 
        {
           
           options1 = new List<SelectOption>();
            
            for (Module__c a : [select Name,moduleName__c from Module__c where projectID__r.id=:currentProjectID order by Name]) {  //Assign userID as the itemlabel and 
                                                                                                                             //itemvalue to the selectoption object
            options1.add(new SelectOption(a.Name,a.moduleName__c));
            }
            return options1; //return set of selectoption to the selectcheckboxes
        }
       
        public void addObject() //function to add the module object and module user object
        {
              List<Employee__c> empObj=[select id from Employee__c where Name=:userName limit 1];
              List<Module__c> moduleInst=[select id from Module__c where Name=:moduleName limit 1];
              
              ProjectRole__c roleinst=[select id from ProjectRole__c where Name=:role limit 1];
              //moduleInstance.userRole__c=role; 
               
              Project__c prjInst=[select id from Project__c where id=:currentProjectID];
              moduleUserInstance=new ModuleUser__c(EmpID__c=empObj[0].id,user_of_module__c=moduleInst[0].id,ProjectUserRole__c=roleinst.id,ProjectID__c=prjInst.id);
              insert moduleUserInstance;
                            
        } 
        
     public PageReference showEmpDetail() //retrieve the details of all the users from users detail
     {
         
          empObject=[select Name,empName__c,empDesignation__c,BU__c,managerID__c from Employee__c where Name=:userName limit 1];
          boolean1=true;
          boolean2=false;
          return null;
     }
     public PageReference showModuleDetail()
     {
           module=[select Name,moduleName__c,priority__c,projectID__c from Module__c where Name=:moduleName limit 1];
           boolean1=false;
           boolean2=true;
           return null;
     }      
     public String getuserName() { 
            return userName;
     }
            
     public void setuserName(String userName) {
            this.userName = userName;
     }
    
     public String getmoduleName()
     { 
            return moduleName;
     }
            
     public void setmoduleName(String moduleName) {
            this.moduleName = moduleName;
     }    
     
     public PageReference returnEdit(){//if cancel option is activated
     //return Page.RequirementDetail;
     return null;
     }
     
 
    public void fetchGlobalUser(){
        ModuleUser__c empObj=new ModuleUser__c();
        empList=new List<ModuleUser__c>(); 
        empSet=new Set<String>();  
        
        empList=[select EmpID__r.id,EmpID__r.empName__c,EmpID__r.Name,ProjectID__c,ProjectUserRole__c from ModuleUser__c where projectID__r.id=:currentProjectID and isGlobal__c=true and ProjectUserRole__c='a0G90000002af7n'];
        //System.debug('All testers : ' + emp);
    
        for(ModuleUser__c m:empList){
            empSet.add(m.EmpID__r.Name);
        }
         empList=new List<ModuleUser__c>();
       
       
        insertGlobal();
        return;
    }
     
     
    public void insertGlobal(){
        //moduleInsObj=new Module__c();
        //moduleInsObj=[select id,Name from Module__c where Name='M-0015'];
        
        for(String s:empSet){
            Employee__c empObj=new Employee__c();
            empObj=[select id from Employee__c where Name=:s];
            //insert code
            moduleUserInst=new ModuleUser__c();
            moduleUserInst.EmpID__c=empObj.id;
            moduleUserInst.user_of_module__c=moduleObj.id;
            moduleUserInst.ProjectUserRole__c='a0G90000002af7n';
            moduleUserInst.ProjectID__c=currentProjectID;
            insert moduleUserInst;
        }
    }
    
     public PageReference addModule()
     {
           List<Project__c> projObj=[select id from Project__c where id=:currentProjectID limit 1];
           List<Module__c> moduleList=[select id from Module__c where moduleName__c=:moduleObj.moduleName__c and projectID__c=:currentProjectID limit 1];
           if(moduleList.size()==0)
           {
              moduleObj.projectID__c=projObj[0].id;
              insert moduleObj;
              fetchGlobalUser();
              PageReference newPage=new PageReference('/apex/ViewModuleDetail?project='+currentProjectID);
              
              return newPage;
           }
           else
           {
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Module already exists!'));
           } 
           return null;       
     } 
     public PageReference addManyModule()
     {
           List<Project__c> projObj=[select id from Project__c where id=:currentProjectID limit 1];
           List<Module__c> moduleList=[select id from Module__c where moduleName__c=:moduleObj.moduleName__c and projectID__c=:currentProjectID limit 1];
           if(moduleList.size()==0)
           {
              moduleObj.projectID__c=projObj[0].id;
              insert moduleObj;
              fetchGlobalUser();
              moduleObj=new Module__c();
              boolean1=true;
           }
           else
           {
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Module already exists!'));
           } 
           return null;          
     }     
     public PageReference showEmployee()
     {
           boolean3=true;
           boolean2=false;
           boolean1=true;
           return null;
     }       
  }