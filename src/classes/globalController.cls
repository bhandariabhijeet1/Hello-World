public class globalController{


public List<ModuleUser__c> empList {get;set;}
public List<ModuleUser__c> emp1List {get;set;}
public List<Module__c> moduleList {get;set;}
public Set<String> empSet {get;set;}
public List<String> globalList {get;set;}
public String currentProjectID {get;set;}
 
public globalController(){
currentProjectId='a0190000000vAW2';
//fetchGlobalUser();
}
 
 
 public PageReference test(){
          return null; 
           }
public void fetchGlobalUser(){

ModuleUser__c empObj=new ModuleUser__c();
empList=new List<ModuleUser__c>(); 
emp1List=new List<ModuleUser__c>(); 
moduleList=new List<Module__c>();  
empSet=new Set<String>();  
globalList=new List<String>();  
           //moduleList=[select id,Name from Module__c where projectID__r.id=:currentProjectID];

           empList=[select EmpID__r.id,EmpID__r.empName__c,EmpID__r.Name,ProjectID__c,ProjectUserRole__c from ModuleUser__c where projectID__r.id=:currentProjectID and isGlobal__c=true];
           //System.debug('All testers : ' + emp);
           for(ModuleUser__c m:empList)
           {
              empSet.add(m.EmpID__r.Name);
           }
           empList=new List<ModuleUser__c>();
           
           for(String s:empSet){
               
               empObj=[select user_of_module__r.Name,EmpID__r.id,EmpID__r.empName__c,EmpID__r.Name,ProjectID__c,ProjectUserRole__c from ModuleUser__c where projectID__r.id=:currentProjectID and EmpID__r.Name=:s and isGlobal__c=true limit 1];
               empList.add(empObj);
               empObj=new ModuleUser__c();
               
           } 
           
           
          
//insertGlobal();
return;
}

 
public ModuleUser__c moduleUserInstance {get;set;}
public Module__c moduleObj {get;set;}

public void insertGlobal(){

moduleObj=new Module__c();
moduleObj=[select id,Name from Module__c where Name='M-0015'];
for(String s:globalList){
Employee__c empObj=new Employee__c();
empObj=[select id from Employee__c where Name=:s];
//insert code
moduleUserInstance=new ModuleUser__c();
moduleUserInstance.EmpID__c=empObj.id;
moduleUserInstance.user_of_module__c=moduleObj.id;
moduleUserInstance.ProjectUserRole__c='a0G90000002airn';
moduleUserInstance.ProjectID__c=currentProjectID;
insert moduleUserInstance;
}
}

public List<ModuleUser__c> testList {get;set;}
public void check(){
testList=new List<ModuleUser__c>();
//testList=[select Name,reqID__r.moduleID__r.Name from TestCase__c limit 5 ];
testList=[select Name,id from ModuleUser__c limit 5];
}
}