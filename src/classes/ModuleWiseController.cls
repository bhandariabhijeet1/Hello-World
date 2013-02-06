public class ModuleWiseController
{
     public Project__c projectObj{get;set;} 
     public string currentProjectID{get;set;}
     public ModuleWiseController()
     {
         currentProjectID=System.currentPagereference().getParameters().get('projectID');
         projectObj=[select projectTitle__c,startDate__c,projectVersion__c,endDate__c from Project__c where id=:currentProjectID];
         getDisplay();
         
     }     
          
      public List<moduleUserWrapper> moduleUserList {get;set;}
      public class moduleUserWrapper
      {
             public List<ModuleUser__c> userList{get;set;}
             public String moduleName{get;set;}
             public String status{get;set;}
             public moduleUserWrapper(List<ModuleUser__c> c,String Name,String str)
             {
                  userList=c;
                  status=str;
                  moduleName=Name;
             }
      }
      
     public List<moduleUserWrapper> getDisplay()
     {
      
            moduleUserList = new List<moduleUserWrapper>();
            
            for(Module__c c:[select Name,moduleName__c from Module__c where projectID__r.id=:currentProjectID]){
            
               List<ModuleUser__c> cc =[select id, Name,EmpID__r.Name,EmpID__r.empName__c,EmpID__r.BU__c,ProjectUserRole__r.projectRole__c,
                user_of_module__r.moduleName__c from ModuleUser__c where user_of_module__r.Name=:c.Name and projectID__c=:currentProjectID order by EmpID__r.empName__c];
               
                    if(cc!=null)
                       moduleUserList.add(new moduleUserWrapper(cc,c.moduleName__c,null));
                    else
                        moduleUserList.add(new moduleUserWrapper(cc,c.moduleName__c,'No Users Available'));   
                }
            
       
        return moduleUserList; 
      } 
 }