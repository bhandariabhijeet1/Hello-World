public class AdduserModuleController {

     
   public List<wrapperEmployee> employeeList {get; set;}
   public List<string> empid{get;set;}
   public List<Boolean> selectval{get;set;}
   public List<string> role{get;set;}
//   public string userRole{get;set;};
   public string checkprint{get;set;}
   public string currentProjectID{get;set;}
   
   public AdduserModuleController(){
   
   empid=new List<string>();
   selectVal=new List<Boolean>();
   role=new List<string>();
   currentProjectID=System.currentPagereference().getParameters().get('project');
   }
 
    public class wrapperEmployee
    {
         public Employee__c empObject{get;set;}
         //public string role{get;set;}
         public boolean bool{get;set;}
         public List<string> roles{get;set;}
         public wrapperEmployee(Employee__c c)
         {
                 empObject=c;
                // role='';
                 bool=false;
                 roles=new List<string>();
          }
     }             
    //This method uses a simple SOQL query to return a List of employee
    public List<wrapperEmployee> getEmployee() {
        string bu=[select technology__c from Project__c where Name='P-0033' limit 1].technology__c;
        if(employeeList == null) {
            employeeList = new List<wrapperEmployee>();
            for(Employee__c c : [select id,Name, empName__c,empDesignation__c,BU__c from Employee__c where BU__c=:bu]) {
                // As each employee is processed we create a new wrapEmp object and add it to the employeeList
                employeeList.add(new wrapperEmployee(c));
            }
        }
        return employeeList; 
    }

     
     public List<SelectOption> getRoles()
     {                       
          List<SelectOption> options = new List<SelectOption>();
        // options = new List<SelectOption>();  
         for (ProjectRole__c a : [select Name,projectRole__c from ProjectRole__c where projectRole__c!='Manager' order by Name]) {           
               options.add(new SelectOption(a.Name,a.projectRole__c));           
          } 
                    
          return options;        
      }    


    public PageReference employeeSelected() {

               
        for(wrapperEmployee cCon : getEmployee()) {
            if(cCon.bool == true) {
                //empid.add(cCon.empObject.Name);
               // role.add(cCon.role);
               // selectval.add(cCon.bool);
                for(string a:cCon.roles)
                {
                      ProjectRole__c prjObj=[select id from ProjectRole__c where Name=:a];
                
                      ModuleUser__c moduleUserInst=new ModuleUser__c(EmpID__c=cCon.empObject.id,user_of_module__c=null,ProjectUserRole__c=prjObj.id,ProjectID__c=currentProjectID);
                      insert moduleUserInst;
                }
            }
            
        }        

       return null;
    }
        
}