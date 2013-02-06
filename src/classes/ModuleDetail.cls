public class ModuleDetail {

       String[] employees = new String[]{};//store the empid of emp selected in a module
       public List<SelectOption> options;  //create selectoptions work as the child of selectcheckboxes in moduledetail vf
       public List<User__c> selectList{get;set;}//used to collect information about user details
       public Module__c moduleObj{get;set;}     //object of master module detail object
       public ModuleUser__c moduleInstance{get;set;}//child object of the module detail
       public User__c empObject;
        public ModuleDetail()
        {
                selectList=new List<User__c>();
                moduleObj=new Module__c();
                  
        }    
        public List<SelectOption> getEmployee() {
           
            options = new List<SelectOption>();
            
            for (User__c a : [select Name from User__c order by Name]) {  //Assign userID as the itemlabel and 
                                                                           // itemvalue to the selectoption object
            options.add(new SelectOption(a.Name,a.Name));
            }
            return options; //return set of selectoption to the selectcheckboxes
        }
          
        public String[] getemployees() { 
            return employees;
        }
            
        public void setemployees(String[] employees) {
            this.employees = employees;
        }
       
        public void addObject() //function to add the module object and module user object
        {
                
              insert moduleObj;
              
              //select the latest inserted module detail to add it in the child object also
                     
              List<Module__c> modules=[select id,Name from Module__c ORDER BY Name Desc limit 1];     
                
              for (String i : employees) {
                                            
                  empObject=[select id, Name from User__c where Name=:i limit 1];
                  // use id of the instance of master Module detail and insert value in the reference field
                  //of the child object ModuleUser
                  moduleInstance=new ModuleUser__c(user_of_module__c=modules[0].Id,EmpID__c=empObject.id);
                  insert moduleInstance;
               }
                            
        } 
        
     public List<User__c> getDetail() //retrieve the details of all the users from users detail
     {
         selectList=[select Name,userName__c,userRole__c,BU__c,manager__c from User__c order by Name];
         return selectList;
     }
     public PageReference next() //method to redirect on the next page of two steps process of inserting module detail 
     {
         return Page.AddEmp;   
     }
     public PageReference previous()//method to come on the previous page
     {
         return Page.moduleDetail;
     }    
     public PageReference returnEdit(){//if cancel option is activated
     //return Page.RequirementDetail;
     return null;
     }
  }