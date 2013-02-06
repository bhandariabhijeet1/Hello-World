public class ViewModuleUserController
{

       public List<ModuleUser__c> selectedList{get;set;}
       public List<ModuleUser__c> selectedList1{get;set;}   //store the module detail to be viewed
       public List<Module__c> moduleInst{get;set;}     //module to be edited
       public String SelectedName { get; set; } //bind the id of the module to be edited
       public String SelectedName1 { get; set; }
       List<String> myList = new List<String>(); 
       
       public List<ModuleUser__c> moduleUserInst{get;set;}
       public string module;
       public string roleSelected{get;set;}
       public string moduleSelected{get;set;}
       
       public string role{get;set;}
       public boolean bool1{get;set;}
       public boolean bool2{get;set;}

     // public string currentProjectID{get;set;}
      public ModuleUser__c editedModuleUserInst{get;set;}
      public ModuleUser__c ModuleUserInst1{get;set;}
              
       public ViewModuleUserController()
       {
             //currentProjectID=System.currentPagereference().getParameters().get('project');
             moduleInst=new List<Module__c>();
             //mm=[select id from Module__c where projectID__r.id=:currentProjectID];
             selectedList=new List<ModuleUser__c>();
             selectedList1=new List<ModuleUser__c>();             
             ModuleUserInst1=new ModuleUser__c(); 
             editedModuleUserInst=new ModuleUser__c();
             bool1=false;
             bool2=false;
            
        }
              
       public List<ModuleUser__c> getDisplay() //display all the module in a project
       {
       
             SelectedList=[select Name,EmpID__c,EmpID__r.empName__c,EmpID__r.empDesignation__c,EmpID__r.BU__c,ProjectUserRole__r.projectRole__c,user_of_module__r.moduleName__c
             from ModuleUser__c where ProjectID__r.Name='P-0033' order by Name];             
             return SelectedList;
       }
      
        public PageReference callEdit(){ //fetch module detail to be edited
    
        
        ModuleUserInst1=[select EmpID__c,EmpID__r.empName__c,EmpID__r.empDesignation__c,
        EmpID__r.BU__c,ProjectUserRole__r.projectRole__c,user_of_module__r.moduleName__c from ModuleUser__c where id=:SelectedName]; 
       
        roleSelected=ModuleUserInst1.ProjectUserRole__r.projectRole__c;
        moduleSelected=ModuleUserInst1.user_of_module__r.moduleName__c;
         
        //editedModuleUserInst=[select EmpID__c,ProjectUserRole__r.projectRole__c,user_of_module__c from ModuleUser__c
        //where id=:SelectedName limit 1];                 
        bool1=false;
        bool2=false;
        return Page.EditModuleUser;
      }                                
     
     public PageReference updateUser(){ //edit the module and redirect to the previous page
       
         
        
        Module__c moduleObj=[select id from Module__c where moduleName__c=:moduleSelected and projectID__r.Name='P-0033'];
        ProjectRole__c prjObj=[select id from ProjectRole__c where projectRole__c=:roleSelected]; 
        ModuleUserInst1.ProjectUserRole__c=prjObj.id;
        ModuleUserInst1.user_of_module__c=moduleObj.id;  
        
        update ModuleUserInst1;
        // update ModuleUserInst1;
        PageReference oldPage=Page.ViewModuleUserPage;
      
         return oldPage;
                 
     }
     
     public PageReference returnEdit(){ //redirect to the previous page after pressing cancel
         return Page.ViewModuleUserPage;
           
     }
     
     public void deleteUser()   {  
      
      // find the emp record within the collection  
      ModuleUser__c tobeDeleted = null;
      SelectedList1=[select id from ModuleUser__c]; 
      for(ModuleUser__c a : SelectedList1)
      if (a.id == SelectedName1) {
          tobeDeleted = a;
          break;
       }
      //if emp record found delete it
       if (tobeDeleted != null) {
           Delete tobeDeleted;
       }
       //refresh the data
       getDisplay();
    }
    public List<SelectOption> getModules() {
            List<SelectOption> options = new List<SelectOption>();
             for (Module__c a : [select Name,moduleName__c from Module__c where projectID__r.Name='P-0033' order by Name])           
               options.add(new SelectOption(a.moduleName__c,a.moduleName__c));  
            //options.add(new SelectOption('Null','Null'));
            return options;
    }
        
    public List<SelectOption> getRoles()
    {
           List<SelectOption> options1=new List<SelectOption>();
           for(ProjectRole__c roleObj:[select id,Name,projectRole__c from ProjectRole__c where projectRole__c!='Manager' order by projectRole__c])
           
                options1.add(new SelectOption(roleObj.projectRole__c,roleObj.projectRole__c));
           
           //options1.add(new SelectOption('Null','Null'));
           return options1;
    }                     
    public String getmodule() {
        return module;
    }
                    
    public void setmodule(String module) { this.module = module; }
    
    public PageReference moduleShow()
    {
          bool1=true;
          return null;
    }
    public PageReference roleShow()
    {
          bool2=true;
          return null;
    }      
   
 }