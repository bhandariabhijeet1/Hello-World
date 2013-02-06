public class ViewModuleDetail    {
       public List<Module__c> selectedList{get;set;}                         //store the module detail to be viewed
       public Integer i{get;set;}
       public Module__c editedModuleInst{get;set;}                          //module to be edited
       public String SelectedName { get; set; }                             //bind the id of the module to be edited
       public String SelectedName1 { get; set; } 
       public String SelectedName2 { get; set; }
       public List<ModuleUser__c> moduleUserInst{get;set;}
       public string currentProjectID{get;set;}
       public boolean prevDisabled{get;set;}
       public boolean view {get;set;}
       public boolean nextDisabled{get;set;}
       public String selectedModule{get;set;}
       public boolean showEditPanel {get;set;} 
       public boolean showModuleInfo {get;set;}   
       public boolean showEmployee {get;set;}    
       public ViewModuleDetail()       {
        try{
           i=0;
           showEditPanel=false;
           showModuleInfo=true;
           showEmployee=true;
           prevDisabled=true;
           nextDisabled=false;
           currentProjectID=System.currentPagereference().getParameters().get('project');
           selectedList=new List<Module__c>();
           moduleUserInst=new List<ModuleUser__c>();
           editedModuleInst=new Module__c(); 
           if (getDisplay().size()==1)
           nextDisabled=true;
           if (getShowModuleUser().size()==0){
           showEmployee=false;
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No user is added yet for this module. ');
            ApexPages.addMessage(myMsg);
           }
           // projectInstance=new Project__c(); 
           // projectInstance=[select Name,projectTitle__c,projectDescription__c,startDate__c,endDate__c from Project__c where id=:currentProjectID limit 1];   
           }
           
        catch(Exception e){
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error');
            //ApexPages.addMessage(myMsg);
        ApexPages.addMessages(e);
           }
           }
        public PageReference navigateModule()    {
              //this.selectedModule=selectedModule;
              for (i=0;i<selectedList.size();i++)   {
                    if(selectedList[i].moduleName__c.equals(selectedModule))
                       break;               
                    }
            if(i==0){
                    prevDisabled=true;
                    nextDisabled=false;
                    }
            else if(i==selectedList.size()-1){
                     prevDisabled=false;
                     nextdisabled=true;   
                     }
            else      {
                      prevDisabled=false;
                      nextDisabled=false;
                     }
            showEditPanel=false;
            showModuleInfo=true;
           
            if (getShowModuleUser().size()==0){
           showEmployee=false;
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No user is added yet for this module. ');
            ApexPages.addMessage(myMsg);
           }
            return null;
            }
        public void showNext()      {
            i++;
            prevDisabled=false;
            if (i==(selectedList.size()-1))
                        nextDisabled=true;
            }
        public void showPrevious()   {
            i--;
            nextDisabled=false;
            if(i==0)
                prevDisabled=true;
             }
       public List<Module__c> getDisplay(){ //display all the module in a project  
             try{
             selectedList=[select id,Name,moduleName__c,moduleSpecification__c,priority__c,startDate__c,endDate__c from Module__c where projectID__r.id=:currentProjectID order by Name];             
             }
             catch(ListException e)
             { ApexPages.addMessages(e); }
             return selectedList;
             }
       public PageReference callEdit(){ //fetch module detail to be edited
            
            editedModuleInst = [Select id,moduleName__c,moduleSpecification__c,priority__c,startDate__c, endDate__c from Module__c  where id=:SelectedList[i].id limit 1];
            
            showEditPanel=true;
            showModuleInfo=false;
            
            return null;
             //   return Page.EditModule;
              } 
      public List<ModuleUser__c> getshowModuleUser() {              
              if(getDisplay().size()!=0)
              {
                system.debug('checkI'+i);
               moduleUserInst=[select EmpID__c,EmpID__r.Name,user_of_module__c,EmpID__r.empName__c,EmpID__r.empDesignation__c,EmpID__r.managerID__c,ProjectUserRole__r.projectRole__c  from ModuleUser__c where projectID__c=:currentProjectID and user_of_module__c=:selectedList[i].id];
               showModuleInfo=true;
               return moduleUserInst;
               }
              
               else return null;
               }                                
      public PageReference updateModule(){ //edit the module and redirect to the previous page
             try{
             update editedModuleInst;
             
             showEditPanel=false;
             showModuleInfo=true;
             }
             catch(DMLException e)
             { ApexPages.addMessages(e); }
             return null;
            }
      public PageReference returnEdit(){ //redirect to the previous page after pressing cancel
          showEditPanel=false;
          showModuleInfo=true;
          return null;
           }
      public PageReference deleteModule()   {      // find the emp record within the collection  
          Module__c tobeDeleted = null;
          if (SelectedName1!=null)
          {
          tobeDeleted=[Select id from Module__c where id=:SelectedName1];
          i=0;
          delete tobeDeleted;
          }
          if (getDisplay().size()== 0)
          {
          PageReference page= new PageReference('/apex/Blank');    
          return page;
          }
          i=0;              
          getDisplay();
          getshowModuleUser();
               return null;
            }
    public void deleteModuleUser()
    {
         ModuleUser__c tobeDeleted=null;
         for(ModuleUser__c a:moduleUserInst)
         {
              if (a.id == SelectedName2) {
                 tobeDeleted = a;
                break;
         }
         }
      //if emp record found delete it
       if (tobeDeleted != null) {
           Delete tobeDeleted;
       }
       //refresh the data  
       showModuleInfo=false;
       
      
     }
 }