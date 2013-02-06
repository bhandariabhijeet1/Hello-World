public class showReport {
    public string module{get;set;}
    public string status{get;set;}
    public string priority;
    public List<Requirement__c> reqList{get;set;}
    public string setType{get;set;}
    public string fileFormat;
    public showReport()
    {
        // module=returnModule();
         //module='vishal';
        // status=returnStatus();
        // priority=returnPriority();
         //fileFormat=selectedformat();
         module=System.currentPagereference().getParameters().get('module');
         status=System.currentPagereference().getParameters().get('status');
     }     
     public List<Requirement__c> getReport()
     {
           reqList=new List<Requirement__c>();
           
            if(module!='-Any-')
            {
                if(status!='-Any-')
                  
                 {    if(priority!='-Any-')
                    
                       reqList=[select Name,reqName__c,reqDescription__c,reqPriority__c,reqProposedBy__c,
                       reqStatus__c,reqVersion__c from Requirement__c where moduleID__r.Name=:module and reqStatus__c=:status and reqPriority__c=:priority ];
           
                     else
                       
                       reqList=[select Name,reqName__c,reqDescription__c,reqPriority__c,reqProposedBy__c,
                       reqStatus__c,reqVersion__c from Requirement__c where moduleID__r.Name=:module and reqStatus__c=:status];
                 }
                 else if(priority!='-Any-')
                    
                      reqList=[select Name,reqName__c,reqDescription__c,reqPriority__c,reqProposedBy__c,
                      reqStatus__c,reqVersion__c from Requirement__c where moduleID__r.Name=:module and reqPriority__c=:priority ];
                 else
                                                      
                      reqList=[select Name,reqName__c,reqDescription__c,reqPriority__c,reqProposedBy__c,
                      reqStatus__c,reqVersion__c from Requirement__c where moduleID__r.Name=:module];
            }
            else if(status!='-Any-')
            {
                   if(priority!='-Any-')
                      
                      reqList=[select Name,reqName__c,reqDescription__c,reqPriority__c,reqProposedBy__c,
                      reqStatus__c,reqVersion__c from Requirement__c where reqStatus__c=:status and reqPriority__c=:priority];                           

                    else
                    
                      reqList=[select Name,reqName__c,reqDescription__c,reqPriority__c,reqProposedBy__c,
                      reqStatus__c,reqVersion__c from Requirement__c where reqStatus__c=:status];                           
  
             }
             else if(priority!='-Any-')
                     
                     reqList=[select Name,reqName__c,reqDescription__c,reqPriority__c,reqProposedBy__c,
                      reqStatus__c,reqVersion__c from Requirement__c where reqPriority__c=:priority];                           
    
             else
                     reqList=[select Name,reqName__c,reqDescription__c,reqPriority__c,reqProposedBy__c,
                     reqStatus__c,reqVersion__c from Requirement__c];                           
 
           return reqList;
           //return null;
    
       }
     public void setChange()
     {
         if(fileFormat=='MS-Word')
         setType='application/msword';
         if(fileFormat=='MS-Excel')
          setType='application/vnd.ms-excel';
         if(fileFormat=='HTML')
          setType='';
         if(fileFormat==null)
          setType='';
     }
 }