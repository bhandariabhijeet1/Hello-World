public global with sharing class RequirementViewCon{

   public List<Requirement__c> reqList { get; set; }
   public List<Requirement__c> updateList { get; set; }
   public String user{get;set;}
   public String currentProjectId{ get; set; }
   public global String SelectedReqName { get; set; }
   public static String SelectedName { get; set; }
   
   public Requirement__c tobeEdited2{get;set;}
   
   PageReference newPage;
   
   public RequirementViewCon() {
       user=System.currentPagereference().getParameters().get('user');
       currentProjectID=System.currentPagereference().getParameters().get('project');
       LoadData();
       tobeEdited2=new Requirement__c();
       updateList=new List<Requirement__c>();
   }
  
   public void LoadData() {
       //modList=[select  id, moduleName__c from Module__c where id in (Select user_of_module__c  from ModuleUser__c where EmpID__c =:user) ];
       //reqList = [Select  id,reqName__c,reqType__c,reqDescription__c,reqPriority__c,reqProposedBy__c,reqStatus__c,reqVersion__c from Requirement__c where id in (Select user_of_module__c  from ModuleUser__c where EmpID__c =:user)];               
       if(user=='admin')
           reqList = [Select moduleID__c,Name,reqName__c,reqType__c,reqDescription__c,reqPriority__c,reqProposedBy__c,reqStatus__c,reqVersion__c from Requirement__c where moduleID__c in(select user_of_module__c from ModuleUser__c where ProjectID__c=:currentProjectID)];
       else
           reqList = [Select moduleID__c,Name,reqName__c,reqType__c,reqDescription__c,reqPriority__c,reqProposedBy__c,reqStatus__c,reqVersion__c from Requirement__c where moduleID__c in(select user_of_module__c from ModuleUser__c where EmpID__c =:user)];
       return;
   }
    
   public void deleteReq()   {  
      // if for any reason we are missing the reference  
      if (SelectedReqName == null) {    
           return;  
      } 
      // find the req record within the collection  
      Requirement__c tobeDeleted = null;
      for(Requirement__c a : reqList)
      if (a.Name == SelectedReqName) {
          tobeDeleted = a;
          break;
       }
      //if req record found delete it
       if (tobeDeleted != null) {
           Delete tobeDeleted;
       }
       //refresh the data
       LoadData();
    }    
   
       
    
  public PageReference callEdit(){
    
      tobeEdited2 = [Select  Name,reqName__c,reqType__c,reqDescription__c,reqPriority__c,reqProposedBy__c,reqStatus__c,reqVersion__c from Requirement__c  where Name=:SelectedName limit 1];
        System.debug(SelectedName);
        SelectedReqName=tobeEdited2.reqName__c;
        return Page.RequirementEdit;
     } 
     
     
    public PageReference updateReq(){
       
        update tobeEdited2;
         PageReference oldPage=Page.RequirementView;
        oldPage.setRedirect(true);
         return oldPage;
     }
     
     public PageReference returnEdit(){
     return Page.RequirementView;
     }
  
}