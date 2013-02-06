public class RequirementReportsController
{      

         public SDate__c startDate{get;set;}
         public SDate__c endDate{get;set;}
         public string SummariseParam{get;set;}
         public string status{get;set;}
         public List<AggregateResult> groupedResults{get;set;}
         public List<WrapperSummary> requirementReport{get;set;}
         public Project__c projectObj{get;set;}
         public List<Module__c> moduleList{get;set;}    
         public string currentProjectID{get;set;}
         public boolean summaryShow{get;set;}        
         
         public RequirementReportsController()
         {
         
              currentProjectID=System.currentPagereference().getParameters().get('project');
              projectObj=[select Name,projectTitle__c,projectVersion__c,startDate__c,endDate__c from Project__c where id=:currentProjectID]; 
              moduleList=[select Name,id from Module__c where projectID__r.id=:currentProjectID];
              summaryShow=false;
              startDate=new SDate__c();
              endDate=new SDate__c();
              searchParam='Show';
             
          }    
          
         public class WrapperSummary{
            
             public String reportParam{get;set;}      
             public List<Requirement__c> reqList{get;set;}
             public Integer count{get;set;}
             public WrapperSummary(List<Requirement__c> rList,string str)
             {
                     reportParam=str;
                     count=rList.size();    
                     reqList=rList;
             }        
         }
                  
        public void getResult()
        {
             
             groupedResults=new List<AggregateResult>(); 
             if(SummariseParam=='RequirementPriority')
             {
                 groupedResults=[SELECT reqPriority__c cnt FROM Requirement__c GROUP BY reqPriority__c];
                 searchParam='Requirement Priority';   
             }
             else if(SummariseParam=='RequirementStatus')
             {
                 searchParam='Requirement Status';
                 groupedResults=[SELECT reqStatus__c cnt FROM Requirement__c where moduleID__r.projectID__r.id=:currentProjectID GROUP BY reqStatus__c];
             }
             else if(SummariseParam=='RequirementVersion')
             {
                 groupedResults=[SELECT reqVersion__c cnt From Requirement__c where moduleID__r.projectID__r.id=:currentProjectID Group BY reqVersion__c];      
                 searchParam='Requirement Version'; 
             }
                                          
        }  
      
        public string searchParam{get;set;} 
        public List<Requirement__c> dateResultList{get;set;}
        
        public void queryOnDate()
        {
                dateResultList=new List<Requirement__c>();
                if(startDate.dateField__c!=null && endDate.dateField__c!=null)
                
                    dateResultList=[select id,Name from Requirement__c where CreatedDate >=: startDate.dateField__c and CreatedDate<=: endDate.dateField__c order by Name];
                else if(startDate.dateField__c!=null && endDate.dateField__c==null)
                      
                    dateResultList=[select id,Name from Requirement__c where CreatedDate >=: startDate.dateField__c order by Name];
                else if(startDate.dateField__c==null && endDate.dateField__c!=null)
                
                    dateResultList=[select id,Name from Requirement__c where CreatedDate<=: endDate.dateField__c order by Name];
                
        
        }
        public List<Requirement__c> newList;
        
        public void addToShow(List<Requirement__c> listOfDate,List<Requirement__c> listOfFetch)
        {
                 
               //requirementReport=new List<WrapperSummary>();
               newList=new List<Requirement__c>();
                                   
               for(Requirement__c lf:listOfFetch)
               {
                    for(Requirement__c ld:listOfDate)
                    {
                         if(lf.Name==ld.Name)
                         {    
                             newList.add(lf);
                             break;
                         }
                     }
                }                                                    
                                           
        }
        public PageReference ReportSummarise(){
        
           getResult();
           queryOnDate();
           List<Requirement__c> fetchList;
           requirementReport=new List<WrapperSummary>();
           if(groupedResults.size()!=0){
                                      
              for(AggregateResult ar:groupedResults){
                 
                 String str=(string)ar.get('cnt');
                 
                 fetchList=[select CreatedDate,Name,reqName__c,reqDescription__c,reqPriority__c,
                            reqStatus__c,reqVersion__c,moduleID__r.moduleName__c from Requirement__c where moduleID__c in (select id from Module__c where projectID__r.id=:currentProjectID) 
                            and (reqPriority__c=:str or reqStatus__c=:str or reqVersion__c=:str) order by Name];
                     
                if(startDate.dateField__c!=null || endDate.dateField__c!=null)
                 {         
                       addToShow(dateResultList,fetchList);
                       requirementReport.add(new WrapperSummary(newList,str)); 
                 }
                 else
                       requirementReport.add(new WrapperSummary(fetchList,str));                
                    
                }
           }
         else
         {
                
                if(SummariseParam=='Module Name')
                {
                     searchParam='Module Name'; 
                     for(Module__c cc:[select id,moduleName__c from Module__c where projectID__r.id=:currentProjectID])
                     {
                            fetchList=[select CreatedDate,Name,reqName__c,reqDescription__c,reqPriority__c,
                            reqStatus__c,reqVersion__c from Requirement__c where moduleID__c=:cc.id];
                            
                            if(startDate.dateField__c!=null || endDate.dateField__c!=null)
                            {         
                                addToShow(dateResultList,fetchList);
                                requirementReport.add(new WrapperSummary(newList,cc.moduleName__c)); 
                            }
                            else
                                requirementReport.add(new WrapperSummary(fetchList,cc.moduleName__c));  
                      }
                 }
                 else
                 {     
                    
                    fetchList=[select CreatedDate,Name,reqName__c,reqDescription__c,reqPriority__c,
                    reqStatus__c,reqVersion__c,moduleID__r.moduleName__c from Requirement__c where moduleID__c in (select id from Module__c where projectID__r.id=:currentProjectID) order by Name];
                    if(startDate.dateField__c!=null || endDate.dateField__c!=null)
                    {         
                       addToShow(dateResultList,fetchList);
                       requirementReport.add(new WrapperSummary(newList,'All Requirements')); 
                    }
                    else
                      requirementReport.add(new WrapperSummary(fetchList,'All Requirements')); 
                 }       
                       
          }       
              
           summaryShow=true;
           return null;
                                                
       }
        
        public PageReference ShowRequirementReportPage()
        {
          return Page.ExcelRequirementReportPage;
          //return null;
        } 
        
}