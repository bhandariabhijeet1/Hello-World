public class TestcaseReportsController
{      
 
        
         public SDate__c startDate{get;set;}
         public SDate__c endDate{get;set;}
         public string SummariseParam{get;set;}
         public string status{get;set;}
         public List<AggregateResult> groupedResults{get;set;}
         public List<WrapperSummary> TestcaseReport{get;set;}
         public Project__c projectObj{get;set;}
         public List<Module__c> moduleList{get;set;}   
         Public List<Requirement__c> reqList{get;set;} 
         public List<ModuleUser__c> userList{get;set;}
         public string currentProjectID{get;set;}
         public boolean summaryShow{get;set;}
         
         public TestcaseReportsController()
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
             public List<TestCase__c> testcaseList{get;set;}
             public Integer count{get;set;}
             public WrapperSummary(List<TestCase__c> tList,string str)
             {
                     reportParam=str;
                     count=tList.size();    
                     testcaseList=tList;
             }        
         }
                  
        public void getResult()
        {
             
             groupedResults=new List<AggregateResult>();
             reqList=new List<Requirement__c>();
             
             userList=new List<ModuleUser__c>();
             
             if(SummariseParam=='Testcase Status')
             {
                 groupedResults=[SELECT testStatus__c cnt FROM TestCase__c GROUP BY testStatus__c];
                 searchParam='Testcase Status';   
             }
             else if(SummariseParam=='Requirement Name')
             {
                 searchParam='Requirement Name';
                 reqList=[SELECT id,Name,reqName__c FROM Requirement__c where moduleID__r.projectID__r.id=:currentProjectID];
             }
             else if(SummariseParam=='Testcase Writer')
             {
                 system.debug('hellome');
                 //userList=[SELECT id,EmpID__c,EmpID__r.empName__c from ModuleUser__c where projectID__r.Name='P-0033' and ProjectUserRole__r.projectRole__c='TestCaseWriter'];      
                 groupedResults=[SELECT EmpID__c cnt from ModuleUser__c where projectID__r.id=:currentProjectID and ProjectUserRole__r.projectRole__c='TestCaseWriter' group by EmpID__c];      
                 searchParam='Testcase Writer'; 
             }
                                          
        }  
       
        public string searchParam{get;set;} 
        public List<TestCase__c> dateResultList{get;set;}
        
        public void queryOnDate()
        {
                dateResultList=new List<TestCase__c>();
                if(startDate.dateField__c!=null && endDate.dateField__c!=null)
                
                    dateResultList=[select id,Name from TestCase__c where CreatedDate >=: startDate.dateField__c and CreatedDate<=: endDate.dateField__c order by Name];
                else if(startDate.dateField__c!=null && endDate.dateField__c==null)
                      
                    dateResultList=[select id,Name from TestCase__c where CreatedDate >=: startDate.dateField__c order by Name];
                else if(startDate.dateField__c==null && endDate.dateField__c!=null)
                
                    dateResultList=[select id,Name from TestCase__c where CreatedDate<=: endDate.dateField__c order by Name];
                
        
        }
        public List<TestCase__c> newList;
        
        public void addToShow(List<TestCase__c> listOfDate,List<TestCase__c> listOfFetch)
        {
                 
               
               newList=new List<TestCase__c>();
                                   
               for(TestCase__c lf:listOfFetch)
               {
                    for(TestCase__c ld:listOfDate)
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
           List<TestCase__c> fetchList;
           TestcaseReport=new List<WrapperSummary>();
           if(groupedResults.size()!=0){
                                      
              for(AggregateResult ar:groupedResults){
                 
                 String str=(string)ar.get('cnt');
                 
                                            
                 fetchList=[select CreatedDate,Name,testName__c,testDescription__c,reqID__r.reqName__c,reqID__r.moduleID__r.moduleName__c,expectedOutput__c,actualOutput__c,
                            testStatus__c from TestCase__c where reqID__c in (SELECT id FROM Requirement__c where moduleID__r.projectID__r.id=:currentProjectID) and (testStatus__c=:str or userID__c=:str)];           
                     
                  if(SummariseParam=='Testcase Writer')
                  {
                         str=[select empName__c from Employee__c where id=:str limit 1].empName__c;
                  }       
                 if(startDate.dateField__c!=null || endDate.dateField__c!=null)
                 {         
                       addToShow(dateResultList,fetchList);
                     
                      
                       TestcaseReport.add(new WrapperSummary(newList,str)); 
                 }
                 else
                       TestcaseReport.add(new WrapperSummary(fetchList,str));                
                    
                }
           }
         else
         {
                
                if(SummariseParam=='Requirement Name')
                {
                     
                     for(Requirement__c cc:reqList)
                     {
                           fetchList=[select CreatedDate,Name,testName__c,testDescription__c,reqID__r.reqName__c,reqID__r.moduleID__r.moduleName__c,expectedOutput__c,actualOutput__c,
                               testStatus__c from TestCase__c where reqID__c=:cc.id];           
                     
                            
                            if(startDate.dateField__c!=null || endDate.dateField__c!=null)
                            {         
                                addToShow(dateResultList,fetchList);
                                TestcaseReport.add(new WrapperSummary(newList,cc.reqName__c)); 
                            }
                            else
                                TestcaseReport.add(new WrapperSummary(fetchList,cc.reqName__c));  
                      }
                 }
                 
                 else 
                 {     
                    
                          fetchList=[select CreatedDate,Name,testName__c,testDescription__c,reqID__r.reqName__c,reqID__r.moduleID__r.moduleName__c,expectedOutput__c,actualOutput__c,
                                     testStatus__c from TestCase__c order by Name];           
                     
                            
                           if(startDate.dateField__c!=null || endDate.dateField__c!=null)
                           {         
                                addToShow(dateResultList,fetchList);
                                TestcaseReport.add(new WrapperSummary(newList,'All TestCases')); 
                           }
                           else
                               TestcaseReport.add(new WrapperSummary(fetchList,'All TestCases'));  
                     
                 }       
                       
          }       
              
           summaryShow=true;
           return null;
                                                
       }
        
        public PageReference ShowTestcaseReportPage()
        {
          return Page.ExcelTestCaseReportPage;
          //return null;
        } 
        
}