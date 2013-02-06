public class TestCaseReportController1{ 
   
    public TestCase__c testcaseInstance{get;set;}
       public String[] countries = new String[]{};  
    public String result{get;set;}
    public String status{get;set;}
    public String SelectedFilterName{get;set;}
    public List<TestCase__c> testcaselist { get; set; } //new
    
    public String reqStatus{get;set;}
    public String reqPriority{get;set;}
    public List<Requirement__c> requirementlist { get; set; } //new1
     
    public boolean showReport{get;set;}
    
    public Module__c moduleObj{get;set;}
    public List<SelectOption> options{get;set;}
    public List<Module__c> selectedList{get;set;}
   
      
      public String[] getCountries() {
        return countries;
    }

   public void setCountries(String[] countries) {
        this.countries = countries;
    }
   public List<SelectOption> getItems() {
    
  
    
    
     for(List<Module__c> moduleList:
            [select ModuleName__c,Name,projectID__c from Module__c where projectID__r.Name='P-0033']){
                for(Module__c c: moduleList){
            
                    options.add(new SelectOption(c.ModuleName__c,c.ModuleName__c));
                }
     
        return options;
    }
    return null;
    }
    
    
    
    public  TestCaseReportController1(){ 
        
        showReport=false;
        testcaselist = new List<TestCase__c>(); 
        testcaseInstance= new TestCase__c();
       
        requirementlist = new List<Requirement__c>(); 
        
        moduleObj=new Module__c();
        options = new List<SelectOption>(); 
        selectedList= new List<Module__c>();
    
        
    }    
    
    public void viewTestCaseReport(){               
        //system.debug('-----------------filter name-------------?------' + SelectedFilterName);  
         
        if((result=='all')&&(status=='all'))
        {
           testcaselist=[select Name,testName__c,testResult__c,testStatus__c from TestCase__c];// where testResult__c =: result];
        }
        else if((result=='pass')&&(status=='success'))
        {
        testcaselist=[select Name,testName__c,testResult__c,testStatus__c from TestCase__c where testResult__c =: result and testStatus__c =: status];
        }
        else if((result=='fail')&&(status=='bug'))
        {
        testcaselist=[select Name,testName__c,testResult__c,testStatus__c from TestCase__c where testResult__c =: result and testStatus__c =: status];
        }
        else if((result=='fail')&&(status=='pending'))
        {
        testcaselist=[select Name,testName__c,testResult__c,testStatus__c from TestCase__c where testResult__c =: result and testStatus__c =: status];
        }
        showReport=true; 
    }
    public void viewRequirementReport(){               
        //system.debug('-----------------filter name-------------?------' + SelectedFilterName);    
        /*if(result=='all')
        {
           testcaselist=[select Name,testName__c,testResult__c from TestCase__c];// where testResult__c =: result];
        }
        else
        {
        testcaselist=[select Name,testName__c,testResult__c from TestCase__c where testResult__c =: result];
        }*/
        requirementlist=[select Name,reqName__c,reqStatus__c,reqPriority__c from Requirement__c where reqStatus__c =: reqStatus or reqPriority__c =: reqPriority];
    }
    
     
}