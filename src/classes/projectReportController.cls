public class projectReportController{ 
   
    public Project__c projectInstance{get;set;}
        
   public String result{get;set;}
    public String SelectedFilterName{get;set;}
    public List<Project__c> projectlist { get; set; } //new
    
    
    
    public  projectReportController(){ 
        
        projectlist = new List<Project__c>(); 
        projectInstance= new Project__c();
        
    }    
    
    public void viewProjectReport(){               
        system.debug('-----------------filter name-------------?------' + SelectedFilterName);    
        if(result=='all')
        {
           projectlist=[select Name,projectTitle__c,status__c from Project__c];// where testResult__c =: result];
        }
        else
        {
        projectlist=[select Name,projectTitle__c,status__c  from Project__c where status__c  =: result];
        }
    }
    
     
}