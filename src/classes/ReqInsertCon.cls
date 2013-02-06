public class ReqInsertCon
{

       public Requirement__c reqObj{get;set;}
       
       public ReqInsertCon()
       {
             reqObj=new Requirement__c(); 
             reqObj=new Requirement__c(reqName__c='New Requirement',reqPriority__c='High',reqDescription__c='Demo Description',reqStatus__c='Open',
             reqType__c='Functional',reqVersion__c='1.0',reqProposedBy__c='Vishal');
       }  
       public void reqInsert()
       {
           insert reqObj;
       }
}