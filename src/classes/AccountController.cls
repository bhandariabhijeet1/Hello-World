global class AccountController implements al.ObjectPaginatorListener{

     public boolean bool1{get;set;}
     public boolean bool2{get;set;}
     public boolean bool3{get;set;}
     public boolean bool4{get;set;}
     public boolean bool5{get;set;}
     public boolean bool6{get;set;}
     public boolean bool7{get;set;}
     public boolean bool8{get;set;}
     public boolean queryResults{get;set;}
     public boolean userDelete{get;set;}
     public boolean roleDelete{get;set;}
     public boolean saveEnabled{get;set;}
     public boolean nextEnabled{get;set;}
     public boolean insertResult1{get;set;}
     public boolean insertResult2{get;set;}
     public boolean showBack{get;set;}
     public boolean isGlobal;
     
     public string selectRadioOption{get;set;}
     public string selectRadio2{get;set;}
     public List<ModuleUser__c> selectedList{get;set;}
     public List<ModuleUser__c> selectedList1{get;set;}
     public string currrenProjectID{get;set;}
     public string user{get;set;}
     //public List<wrapperUser> userList {get; set;}
     
     public List<Employee__c> empList{get;set;}
     public List<wrapperRoles> roleList {get; set;}
     public string currentProjectID{get;set;}
     public string selectedTech{get;set;}
     public string condition{get;set;}
     public string conditionvalue{get;set;}
     public ProjectRole__c prjRoleObj{get;set;}
     public string changeColor{get;set;}
   
     public boolean bool11{get;set;}
     public boolean bool12{get;set;}
     public List<ProjectRole__c> projRoleList{get;set;}
     public String[] roles1 = new String[]{};      
     public List<Module__c> modList{get;set;}
     public List<String>  modules;
     public Integer count1{get;set;}
     public Integer count2{get;set;}
     public Integer count3{get;set;}
     public boolean var1{get;set;}
     public String empID{get;set;}
     public ModuleUser__c rolesnModEnter{get;set;}
     public Project__c projObj{get;set;}
     
     
     public List<ModuleUser__c> setExample1{get;set;}
     public List<ModuleUser__c> setExample2{get;set;}
     public List<ModuleUser__c> checkInst;
    //------Variables to implement salesforce pagination-------
    global List<wrapperUser> accounts {get;private set;}
    global al.ObjectPaginator paginator {get;private set;}
    global List<wrapperUser> all{get;private set;}
    //---------------------------------------------------------
    //------variables to implement edit Panel---------------------------------
    public string SelectedName{get;set;}
    public ModuleUser__c ModuleUserInst{get;set;}
    public string roleSelected{get;set;}
    public string moduleSelected{get;set;}
    public boolean showEditPanel{get;set;}
    public string selectedRole{get;set;}
    public string selectedModule{get;set;}
    public boolean priviledgeSelected{get;set;}
    //public string Selectedpriviledge{get;set;}
    public List<ModuleUser__c> isAllModule{get;set;}
    //---------------------------------------------------------
    public boolean bool{get;set;}
    public string  prevUrl{get;set;}
     
     public AccountController(){
     
    
        bool1=false;
        bool2=false;
        bool3=false;
        bool4=false;
        bool5=false;
        bool6=false;
        bool7=false;
        bool8=false;
        
        isGlobal=false;
        userDelete=false;
        roleDelete=false;
        queryResults=false;
        saveEnabled=true;
        nextEnabled=true;
        insertResult1=false;
        insertResult2=false;
        showBack=false;
        showEditPanel=false;
        currentProjectID=System.currentPagereference().getParameters().get('project');/* getting project id through url*/
        user=System.currentPagereference().getParameters().get('user');               /*getting userid through url*/   
        
       // prjRoleObj=new ProjectRole__c();
        changeColor='background-color:#E0FFFF';
        selectedList=new List<ModuleUser__c>();
        selectedList1=new List<ModuleUser__c>(); 
        ModuleUserInst=new ModuleUser__c();            
        modules=new List<string>();
        bool12=false;
        projRoleList=new List<ProjectRole__c>();
        
        modList=new List<Module__c>();
        modList=[select id, Name,moduleName__c from Module__c where projectID__c=:currentProjectID];//creating list of modules in current project
        count1=modList.size();
        //count2=projRoleList.size();
        count3=projRoleList.size();
       // prevUrl='/apex/ModuleWiseDisplayPage1?projectID='+currentProjectId;
        var1=false;
       
     }
     public class wrapperUser{
        public Boolean selected{get;set;}
        public ModuleUser__c userObject{get;set;}
        public wrapperUser(ModuleUser__c obj){
            this.userObject = obj;
        }
    } 
    
    public class wrapperRoles  /*wrapper class to bind projectrole object and boolean to implement view and delete operation for each role*/
    {
         public ProjectRole__c roleObject{get;set;}
         public boolean bool{get;set;}
         public wrapperRoles(ProjectRole__c c)
         {
                 roleObject=c;
                 bool=false;
         }
     } 
                        
     public List<wrapperRoles> getRolesDisplay() /*Function to show all the available roles by wrapper object*/
     {
           if(roleList==null){
            roleList = new List<wrapperRoles>();
            for(ProjectRole__c cc : [select Name,projectRole__c,Description__c from ProjectRole__c order by projectRole__c]) {
               
                roleList.add(new wrapperRoles(cc));
            
              }
        }
        return roleList; 
      }  
      
     public List<wrapperUser> getUsersDisplay()
     {
        this.accounts = new List<wrapperUser>();
       
         if(all== null) {
            all = new List<wrapperUser>();
       
        List<ModuleUser__c> records =  [select id,isGlobal__c, Name,EmpID__r.Name,EmpID__r.empName__c,EmpID__r.empDesignation__c,EmpID__r.BU__c,ProjectUserRole__r.projectRole__c,user_of_module__r.moduleName__c
             from ModuleUser__c where ProjectID__r.id=:currentProjectID order by EmpID__r.Name limit 100];
        if(records != null){
            for(ModuleUser__c acct : records){
                all.add(new wrapperUser(acct));
            }
        }
       } 
        //10 is pageSize, this refers to this class which acts as listener to paginator
        paginator = new al.ObjectPaginator(8,this);
        paginator.setRecords(all);
        return all; 
      }    
      
      global void handlePageChange(List<Object> newPage){
        accounts.clear();
        if(newPage != null){
            for(Object cc : newPage){
               accounts.add((wrapperUser)cc);
               
            }
        }
        showEditPanel=false;
      }
       
      public List<Employee__c> getEmployee()/*Function to show all employee*/
      {
           string bu=[select technology__c from Project__c where id=:currentProjectID].technology__c;
           empList=new List<Employee__c>();
           if(condition=='BU')
           
               empList=[select id,Name,empName__c,empDesignation__c,BU__c,empLocation__c from Employee__c
                        where BU__c=:conditionvalue and managerID__c=:user];
           if(condition=='Designation')
           
               empList=[select id,Name,empName__c,empDesignation__c,BU__c,empLocation__c from Employee__c 
                        where empDesignation__c=:conditionvalue and managerID__c=:user];
           if(condition=='Location')
               empList=[select id,Name,empName__c,empDesignation__c,BU__c,empLocation__c from Employee__c
                        where empLocation__c=:conditionvalue and managerID__c=:user];
                        
            return empList;
        }    
        
      public void showFilteredResult()/*enable result showing panel*/
      {     
            queryResults=true;
            showBack=false;
          
      }      
      public List<SelectOption> getTechnology()
      {
           List<SelectOption> options=new List<SelectOption>();
           Set<String> Technologies=new Set<String>();
           for(Employee__c c:[select BU__c from Employee__c])
           {
                 Technologies.add(c.BU__c);
           }
           for(String a:Technologies)
           {
                options.add(new selectoption(a,a));
           }     
           return options;
        }               
      
      
           
      public void DeleteRoles()/*Function to delete role*/
      {
           Integer ctr=1;
           ProjectRole__c tobeDeleted = null;
           for(wrapperRoles cCon : getRolesDisplay()) {
            if(cCon.bool == true)
            {
                
               ctr=0;          
               tobeDeleted=cCon.roleObject;
               delete tobeDeleted;       
                
            }
            
         }
        if(ctr==1)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Must Select a value'));        
        } 
           roleList=null;
           getRolesDisplay();
           showRoles();
       
       }             
       public void showUsersPanel()
       {
            bool1=true;
            bool2=false;
            bool6=false;
            bool7=false;
            bool8=false;
            bool11=false;
            bool12=false;
            insertResult1=false;
            insertResult2=false;
            showEditPanel=false;
            showBack=false;
       }
     
      public void showUsersPanel1()
      {
            bool1=true;
            bool4=false;
            insertResult1=false;
            insertResult2=false;
            showBack=false;
            showEditPanel=false;
      }
      public void showPanel1n4()
      {
          bool11=false;
          bool12=false;
          bool1=true;
          bool4=true;
          insertResult1=false;
          insertResult2=false;
          showBack=false;
          roles1 = new String[]{};
      }
      public void roleAdder()
      {
          bool1=true;
          bool4=false;
          bool11=true;
          saveEnabled=true;
          nextEnabled=true;
          insertResult1=false;
          insertResult2=false;
          selectRadioOption='';
      }
      public List<SelectOption> getItems() /* function to show roles check list*/
      {
        List<SelectOption> options = new List<SelectOption>();
        projRoleList=[select id,Name,projectRole__c from ProjectRole__c where projectRole__c!='Manager'];
        for(ProjectRole__c p:projRoleList)
        {
            options.add(new SelectOption(p.id,p.projectRole__c));
        }
        //options.add(new SelectOption('NoRole','None'));
        
        return options;
      }
 
    public String[] getRoles1() {
        return roles1;
    }
 
    public void setRoles1(String[] roles1) {
        this.roles1 = roles1;
    }
    public void showModules()
    {
                 
         if(checkRoleSelected())
            bool12=true;
         else
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Must Select a Role!!'));   
                         
    }
    public boolean checkRoleSelected()
    {
         boolean ctr=false;
         for(string cc:roles1){
         
              if(cc==null)
                  
                  continue;
              else
                  {
                     ctr=true;
                     break;
                  }
         }         
         return ctr;                   
    }     
    public List<SelectOption> getRecords() {
        List<SelectOption> options = new List<SelectOption>();
        for(Module__c m:modList)
        {
            options.add(new SelectOption(m.id,m.moduleName__c));
        }    
        return options;
      }
 
    public String[] getModules() {
        return modules;
    }
 
    public void setModules(String[] modules) {
        this.modules = modules;
    }
    public PageReference test() {
            return null;
    }
    public void insertRoles()
    {
        
        if(checkRoleSelected()){
        setExample1=new List<ModuleUser__c>();
        setExample2=new List<ModuleUser__c>();
        checkInst=new List<ModuleUser__c>();
        
        if(selectRadioOption=='RoleCheck'){
        
        for(String r:roles1)
        {
            
            checkInst=[select Name,isGlobal__c,EmpID__r.Name,EmpID__r.empName__c,EmpID__r.empDesignation__c,EmpID__r.BU__c,ProjectUserRole__r.projectRole__c,user_of_module__r.moduleName__c
            
             from ModuleUser__c where EmpID__c=:empID and projectUserRole__c=:r and user_of_module__c=null and projectID__c=:currentProjectID];
            
            if(checkInst.size()==0)
            {
                 
                 Employee__c empObj=[select id from Employee__c where id=:empID];
                 Project__c prjObj=[select id from Project__c where id=:currentProjectID];
                 ProjectRole__c prjRole=[select id from ProjectRole__c where id=:r];
                 
                 ModuleUser__c  modUserInst=new ModuleUser__c(EmpID__c=empObj.id,ProjectID__c=prjObj.id,ProjectUserRole__c=prjRole.id,user_of_module__c=null,isGlobal__c=false);
                 insert modUserInst;
                 checkInst=[select Name,isGlobal__c,EmpID__r.Name,EmpID__r.empName__c,EmpID__r.empDesignation__c,EmpID__r.BU__c,ProjectUserRole__r.projectRole__c,user_of_module__r.moduleName__c
                 from ModuleUser__c where EmpID__c=:empID and ProjectID__c=:currentProjectID and ProjectUserRole__c=:r and user_of_module__c=null];
                 setExample2.addAll(checkInst);  
                 
            }
            else
                // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Value already exits,Select again!!'));
                setExample1.addAll(checkInst);         
         }
        showInsertResult(); 
        }
        else if(selectRadioOption=='GlobalCheck')
        {
                Integer i=0;
                modules.clear();
                isGlobal=true;
                for(Module__c modObj:[select id from Module__c where ProjectID__c=:currentProjectID])
                {
                
                      modules.add((string)modObj.id);
                      
                }
                     
                ModuleUsers();      
        } 
       }
       else
       
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Must Select a Role!!')); 
       //showPanel1n4(); 
       //showInsertResult();        
     }
    public void ModuleUsers()
    {
       setExample1=new List<ModuleUser__c>();
       setExample2=new List<ModuleUser__c>();
       checkInst=new List<ModuleUser__c>();
       system.debug('rolescheck' + roles1);
                
        for(String r:roles1)
        {
                 
                 for(String rm:modules)
                 {
                     checkInst=[select id,Name,isGlobal__c,EmpID__r.Name,EmpID__r.empName__c,EmpID__r.empDesignation__c,EmpID__r.BU__c,ProjectUserRole__r.projectRole__c,user_of_module__r.moduleName__c
                     
                     from ModuleUser__c where EmpID__c=:empID and ProjectUserRole__c=:r and user_of_module__c=:rm and projectID__c=:currentProjectID];
                      
                     System.debug('elseinsert12');
                     
                     if(checkInst.size()!=0)
                     { 
                        
                          setExample1.addAll(checkInst);         
                          
                     }
                     else 
                     {
                         System.debug('elseinsert');
                         Employee__c empObj=[select id from Employee__c where id=:empID];
                         Project__c prjObj=[select id from Project__c where id=:currentProjectID];
                         ProjectRole__c prjRole=[select id from ProjectRole__c where id=:r];
                         Module__c moduleObj=[select id from Module__c where id=:rm];
                         
                         ModuleUser__c  modUserInst=new ModuleUser__c(EmpID__c=empObj.id,ProjectID__c=prjObj.id,ProjectUserRole__c=prjRole.id,user_of_module__c=moduleObj.id,isGlobal__c=isGlobal);
                                          
                        insert modUserInst;                       
                        checkInst=[select Name,isGlobal__c,EmpID__r.Name,EmpID__r.empName__c,EmpID__r.empDesignation__c,EmpID__r.BU__c,ProjectUserRole__r.projectRole__c,user_of_module__r.moduleName__c
                                    from ModuleUser__c where EmpID__c=:empID and ProjectID__c=:currentProjectID and ProjectUserRole__c=:r and user_of_module__c=:rm];
                        setExample2.addAll(checkInst); 
                         
                     }
                    
                                       
                 }       
          }
          if(selectRadioOption=='GlobalCheck')
          {
                 if(setExample1.size()!=0 && setExample2.size()!=0)
                 {
                         for(ModuleUser__c cc:setExample1)
                         {
                                      cc.isGlobal__c=true;
                                      update cc;
                          }
                  
                          setExample2.addAll(setExample1);
                          setExample1.clear();
                  }  
                                 
            }         
        // showPanel1n4(); 
      showInsertResult();   
    }
    public string getempid()
    {
         return empID;
    }     
    public void showInsertResult()
    {
         if(setExample1.size()!=0 && setExample2.size()!=0)
         {
            insertResult1=true;
            insertResult2=true;
            
         }
         else if(setExample1.size()!=0 && setExample2.size()==0)   
         {
              insertResult1=true;
              insertResult2=false;
         }
         else if(setExample2.size()!=0 && setExample1.size()==0)
         {
              insertResult2=true;
              insertResult1=false;
         }
         else if(setExample1.size()==0 && setExample1.size()==0){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Must Select a Module Name !!')); 
               insertResult2=false;
              insertResult1=false;

           }  
           showBack=true;   
     }               
    public void insertNewRole()
    {
         
          List<ProjectRole__c> checkRole;
          checkRole=[select id from ProjectRole__c where projectRole__c=:prjRoleObj.projectRole__c];
          if(checkRole.size()==0)
          {             
             insert prjRoleObj;
             showRoles();
             
          }   
          else
                
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Role already exists, try with new name !!'));
          //prjRoleObj=new ProjectRole__c(); 
     }       
     
      public void showRolesPanel()
      {
           bool2=true;
           bool1=false;
           bool3=false;
           bool4=false;
           bool5=false;
           bool11=false;
           bool12=false;
           showBack=false;
           insertResult1=false;
           insertResult2=false;
           showEditPanel=false;
      }
      public void showPresentUsers()
      {
           bool3=true;
           bool4=false;
           bool5=false;
           bool6=false;
           bool7=false;
           bool8=false;
           bool11=false;
           bool12=false; 
           //userList=null;
           all=null;
           showEditPanel=false;
           insertResult1=false;  
           insertResult2=false;
           getUsersDisplay();    
      } 
      public void showInsertUsers()
      {
           bool3=false;
           bool4=true;
           bool5=false;
           bool6=false;
           bool7=false;
           bool8=false;
           bool11=false;
           bool12=false;
           showEditPanel=false;
           insertResult1=false;
           insertResult2=false;
      } 
      public void showRoles()
      {
           bool6=true;
           bool7=false;
           roleList=null;
           insertResult1=false;
           insertResult2=false;
      }
      //------------------------------------------------------------
      public void showAddRoles()
      {
           bool6=false;
           bool7=true;
           insertResult1=false;
           insertResult2=false;
           prjRoleObj=new ProjectRole__c();
      }
      public PageReference ButtonEnabled()
      {
          if(selectRadioOption=='RoleCheck' || selectRadioOption=='GlobalCheck')
          {
                saveEnabled=false;
                nextEnabled=true;
                bool12=false;
                insertResult1=false;
                insertResult2=false;
                
          }      
          else
          {
                saveEnabled=true;
                nextEnabled=false;
                insertResult1=false;
                insertResult2=false;
          }   
          isGlobal=false;
          return null;   
      } 
       
    public void employeeDeleted() /*function to delete selected employee*/
    {               
     
        Integer ctr=1;
        ModuleUser__c tobeDeleted = null;
        for(wrapperUser cCon : all) {
            if(cCon.selected == true)
            {
                
               ctr=0;         
               tobeDeleted=cCon.userObject;
               if(tobeDeleted.isGlobal__c==true && tobeDeleted.user_of_module__c!=null)
               {
                      for(ModuleUser__c cc:[select EmpID__c,isGlobal__c,user_of_module__c,ProjectID__c,ProjectUserRole__c
                         from ModuleUser__c where projectID__c=:currentProjectID and EmpID__c=:tobeDeleted.EmpID__c and ProjectUserRole__c=:tobeDeleted.ProjectUserRole__c]){
                      
                             cc.isGlobal__c=false;
                             update cc;
                      }               
                }
                delete tobeDeleted;       
            
             }
        }     
        if(ctr==1)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Must Select a value'));        
        } 
        all=null;
        //getUsersDisplay();
        showPresentUsers(); 
     }     
     //------------Methods for EditPanel--------------------------
     public void callEdit(){ //fetch module detail to be edited
    
        showEditPanel=true;
        isAllModule=new List<ModuleUser__c>();
        ModuleUserInst=[select id,Name,isGlobal__c,EmpID__c,EmpID__r.empName__c,EmpID__r.empDesignation__c,
        EmpID__r.BU__c,ProjectUserRole__r.projectRole__c,user_of_module__r.moduleName__c from ModuleUser__c where id=:SelectedName]; 
        
        isAllModule=[select id,isGlobal__c,EmpID__c,ProjectUserRole__c from ModuleUser__c where projectID__c=:currentProjectID and EmpID__c=:ModuleUserInst.EmpID__c
                     and ProjectUserRole__c=:ModuleUserInst.ProjectUserRole__c];
        count2=isAllModule.size();             
        roleSelected=ModuleUserInst.ProjectUserRole__r.projectRole__c;
        moduleSelected=ModuleUserInst.user_of_module__r.moduleName__c;
        priviledgeSelected=ModuleUserInst.isGlobal__c;
         
        //editedModuleUserInst=[select EmpID__c,ProjectUserRole__r.projectRole__c,user_of_module__c from ModuleUser__c
        //where id=:SelectedName limit 1];                 
        
      }  
      public List<SelectOption> getRoles()
      {                       
          List<SelectOption> options = new List<SelectOption>();
          for (ProjectRole__c a : [select Name,projectRole__c from ProjectRole__c where projectRole__c!='Manager' order by Name]) {           
               options.add(new SelectOption(a.projectRole__c,a.projectRole__c));           
          } 
                    
          return options;        
      }
      public List<SelectOption> getEditModules() {
            List<SelectOption> options = new List<SelectOption>();
             for (Module__c a : [select Name,moduleName__c from Module__c where projectID__c=:currentProjectID order by Name])           
               options.add(new SelectOption(a.moduleName__c,a.moduleName__c));  
            //options.add(new SelectOption('Null','Null'));
            return options;
      }
      public void updateUser(){ //edit the module and redirect to the previous page
       
        Module__c moduleObj=[select id from Module__c where moduleName__c=:moduleSelected and projectID__c=:currentProjectID];
        ProjectRole__c prjObj=[select id from ProjectRole__c where projectRole__c=:roleSelected]; 
          if(priviledgeSelected==true){
            if(ModuleUserInst.isGlobal__c==false){
        
              for(ModuleUser__c cc:isAllModule){
                    cc.isGlobal__c=false;
                    update cc;}
            }        
                    
        }
        else if(count1==count2 && priviledgeSelected==false)
        {
              if(ModuleUserInst.isGlobal__c==true)  
              {
                  for(ModuleUser__c cc:isAllModule){
                     cc.isGlobal__c=true;
                     update cc;}
              }
        }
        else{     
        
           List<ModuleUser__c> ModList=[select id from ModuleUser__c where projectID__c=:currentProjectID and user_of_module__c=:moduleObj.id and ProjectUserRole__c=:prjObj.id and EmpID__c=:ModuleUserInst.EmpID__c];                
           if(ModList.size()==0){
             ModuleUserInst.ProjectUserRole__c=prjObj.id;
             ModuleUserInst.user_of_module__c=moduleObj.id;  
            update ModuleUserInst;
           }
        else
        
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'User is already assign in the module with the same role!!'));        
        }
        //getUsersDisplay();
        showPresentUsers(); 
        // update ModuleUserInst1;
        
     }    
     public void cancelEdit()
     {
          showEditPanel=false;
          showPresentUsers(); 
     }  
     //------------------End of editPanel------------------------------------------   
                                      
}