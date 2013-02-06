public class ModuleReportCon
{
    public String result{get;set;}
    //public String SelectedFilterName{get;set;}
    public List<Module__c> modList { get; set; } 
    public  ModuleReportCon(){         
        modList = new List<Module__c>(); 
        //modInstance= new Module__c();        
    }    
    
    public void viewModuleReport(){               
        //system.debug('-----------------filter name-------------?------' + SelectedFilterName);    
        //testcaselist=[select Name,testName__c,testResult__c from TestCase__c];// where testResult__c =: result];
        modList=[select Name,moduleName__c,priority__c from Module__c where priority__c =: result];
    }
   static testMethod void testOperations()
            {
            ModuleReportCon obj=new ModuleReportCon();
            obj.result='';
            
            Module__c mod=new Module__c();
            mod=[select Name,moduleName__c,priority__c from Module__c limit 1];
            obj.result = mod.priority__c;
            obj.viewModuleReport();
            System.assert(obj.modlist.size()!=0);
           
            }       
        
}