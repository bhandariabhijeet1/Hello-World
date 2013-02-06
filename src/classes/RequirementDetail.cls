public global with sharing class RequirementDetail
{

       public List<Requirement__c> selectedList{get;set;}//selectlist to fetch all the requirement detail
       public Module__c moduleInstance{get;set;}         //to retrieve details of the module
       public Requirement__c editedReqInst{get;set;}     //requirement instance to be edited
       public String SelectedName { get; set; }   //bind requirement id to be edited
       public String SelectedName1 { get; set; }   
       public String check{get;set;}     //bind requirement id to be deleted
       public global String SelectedreqName1 { get; set; }//new
       public String reqId { get; set; } 
       public RequirementDetail()
       {
             reqId=System.currentPagereference().getParameters().get('reqId');
            
             selectedList=new List<Requirement__c>();
             editedReqInst=new Requirement__c(); 
             moduleInstance=new Module__c(); 
             
             //Retrieve all the details of module having child to parent relationship with project detail
             moduleInstance=[select Name,moduleName__c,moduleSpecification__c,projectID__r.Name,projectID__r.projectTitle__c from Module__c
                             where projectID__r.Name='P-0033' and  Name='M-0015'];   
                editedReqInst = [Select Name,id,reqName__c,reqType__c,reqDescription__c,reqStatus__c, reqVersion__c,reqPriority__c,reqProposedBy__c from Requirement__c where Name=:reqId]; 
             //callEdit();            
       }
       public List<Requirement__c> getDisplay()//Retrieve all the details of requirements in a module
       {
       
             SelectedList=[select id,reqName__c,reqType__c,reqDescription__c,reqPriority__c,reqVersion__c,reqStatus__c,reqProposedBy__c
             from Requirement__c where moduleID__r.Name='M-0015' order by Name];             
             return SelectedList;
       }
      
        public PageReference callEdit(){ //select only that requirement to be edited and send details to EditRequirement vf
    
       editedReqInst = [Select id,reqName__c,reqType__c,reqDescription__c,reqStatus__c, reqVersion__c,reqPriority__c,reqProposedBy__c from Requirement__c  where id=:reqId];
         
        //PageReference newPage=Page.EditRequirement;
        //newPage.setRedirect(true);
        SelectedreqName1=editedReqInst.Name;
        return Page.EditRequirement;
        
      } 
     
    
    /* public PageReference updateRequirement(){ //function to update the requirement
       
         update editedReqInst;
         //PageReference oldPage=Page.RequirementDetail;
         //oldPage.setRedirect(true);
         return Page.RequirementDetail;                //redirect to the previous page after edit operation
         //return null;
     }
    
    
     public PageReference returnEdit(){   //redirect to the previous page after pressing cancel button
     return Page.RequirementDetail;
     }*/
     
     public void DeleteRequirement()   {  //function to delete the selected requirement
      
      // find the emp record within the collection  
      Requirement__c tobeDeleted = null;
      for(Requirement__c a : SelectedList)
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
         
  }