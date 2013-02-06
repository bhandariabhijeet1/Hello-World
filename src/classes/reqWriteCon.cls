public global with sharing class reqWriteCon{ 
    public Module__c moduleIns{get;set;}
    public List<Module__c> modulelist{get;set;}
    public List<Requirement__c> reqlist{get;set;}
    public List<TestCase__c> testlist{get;set;}
    public Requirement__c reqIns{get;set;} 
    public Requirement__c reqIns1{get;set;}   
    public string currentProjectID{get;set;}// added now
    
    public String SelectedModuleName { get; set; }//new 
    public boolean showtable{get;set;}  
    public boolean showform{get;set;}
    public boolean showreqtable{get;set;}
    public String SelectedReqName{get;set;}
    public static String SelectedTestName { get; set; }//new
    public global String SelectedreqName1 { get; set; }//new
    public String selectedreqid{get;set;}
    public TestCase__c testcaseInstance{get;set;}
        
    public String testName{get;set;}
    public String testDescription{get;set;}
    public String testAssignTo {get;set;}
    public String sampleInputData {get;set;}
    public Date lastExecuted{get;set;}
   // public String actualOutput {get;set;}
    public String expectedOutput {get;set;}
    //public String testResult {get;set;}
    public String user {get;set;}
    public TestCase__c tobeEdited2{get;set;}//new
    public List<TestCase__c> updateList { get; set; } //new
    public   reqWriteCon(){ 
        showtable=false;     
        showform=false; 
        showreqtable=false;
        user=System.currentPagereference().getParameters().get('user');
        currentProjectID=System.currentPagereference().getParameters().get('project');//added now
             
        reqIns = new Requirement__c(); 
        reqIns1 = new Requirement__c();
        moduleIns = new Module__c();     
        modulelist = new List<Module__c>(); 
        reqlist = new List<Requirement__c>(); 
        testlist = new List<TestCase__c>(); 
        testcaseInstance= new TestCase__c();
        tobeEdited2=new TestCase__c();//new     
        updateList=new List<TestCase__c>();//new  
        showmodulelist();
    }    
    public PageReference addItems(){        
        insert reqIns;
        PageReference viewPage = new PageReference('/apex/RequirementView');
        return viewPage; 
    }
    public void showmodulelist(){
    showreqtable=false;  
    modulelist=[select  id, moduleName__c from Module__c where id in (Select user_of_module__c  from ModuleUser__c where EmpID__c =:user) ];
    }
   /* public PageReference showreq(){  
        showreqtable=true;          
        reqlist=[select id,Name,reqName__c,reqDescription__c,reqPriority__c,reqProposedBy__c,reqStatus__c,reqType__c,reqVersion__c from Requirement__c where moduleID__r.id=:SelectedModuleName];  
        return Page.showmodulereq;
    }*/
    public void showreq(){  
        showreqtable=true;          
        reqlist=[select id,Name,reqName__c,reqDescription__c,reqPriority__c,reqProposedBy__c,reqStatus__c,reqType__c,reqVersion__c from Requirement__c where moduleID__r.id=:SelectedModuleName];  
        
    }
    public PageReference calltestcases(){        
        showtable=true;   
        showform=false;   
        system.debug('-----------------req-------------?------' + SelectedReqName);      
        reqIns1=[select Name,reqName__c,reqDescription__c,reqPriority__c,reqProposedBy__c,reqStatus__c,reqType__c,reqVersion__c from Requirement__c where Name =: SelectedReqName];  
        return Page.displaytestcases;    
    }
    public void viewtestcases(){               
        showtable=true;      
        showform=false;       
        testlist=[select Name,testName__c,testDescription__c,testAssignTo__c,sampleInputData__c,lastExecuted__c,actualOutput__c,expectedOutput__c,testStatus__c,testResult__c,reqID__c from TestCase__c where reqID__r.Name =: SelectedReqName];
    }
    public void viewForm(){            
        showtable=false;      
        showform=true;   
    }
    public PageReference callEdit(){         
        system.debug('-----------------sel-------------?------' + SelectedTestName); 
        tobeEdited2 = [Select  Name,testName__c,testDescription__c,testAssignTo__c,sampleInputData__c,lastExecuted__c,actualOutput__c,expectedOutput__c,testResult__c,reqID__c from TestCase__c  where Name=:SelectedTestName limit 1]; 
        System.debug(SelectedTestName);    
        SelectedreqName1=tobeEdited2.Name;
        return Page.testcaseEditPage;
    } 
    public void DeleteAccount(){           
        system.debug('-----------------selected-------------?------' + SelectedreqName);    
        // if for any reason we are missing the reference  
        if (SelectedreqName == null){ return;}         
        // find the emp record within the collection         
        TestCase__c tobeDeleted = null;       
        for(TestCase__c a : testlist)   
        if (a.Name == SelectedreqName){            
            tobeDeleted = a;      
            break;         
        }        
        //if emp record found delete it    
        if (tobeDeleted != null){Delete tobeDeleted;}
        viewtestcases();//new1
   }
    public void addtestcaseObject(){         
        system.debug('-----------------req1-------------?------' + selectedreqid);   
        testcaseInstance=new TestCase__c(testName__c=testName,testDescription__c=testDescription,testAssignTo__c=testAssignTo,sampleInputData__c=sampleInputData,lastExecuted__c=lastExecuted,expectedOutput__c=expectedOutput,reqID__c=reqIns1.id,userID__c=user);  
        insert testcaseInstance;    
        testcaseInstance = new TestCase__c();//after inserting this object will clean the form
        viewtestcases();//new1
    }     
    public PageReference previous(){   
        showtable=false;             
        return Page.showmodulereq;
    } 
    public PageReference updatetestcase(){               
        update tobeEdited2; 
        tobeEdited2= new TestCase__c();//after inserting this object will clean the form new1
        viewtestcases();//new1
        return Page.displaytestcases;//old
    }
    public PageReference returnEdit(){        
        return Page.displaytestcases;
    }    
    
}