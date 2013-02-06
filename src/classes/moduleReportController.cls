public class moduleReportController{    
    public Module__c moduleInstance{get;set;}        
    public String result{get;set;}
    public String result1{get;set;}
   // public String status{get;set;}
   // public String SelectedFilterName{get;set;}
    public List<Module__c> modulelist { get; set; }
    public List<Module__c> modulelist1 { get; set; }     
    public String moduleStatus{get;set;}
    public String priority{get;set;}     
    public boolean showReport1{get;set;}    
    public moduleReportController(){         
        showReport1=false;
        modulelist = new List<Module__c>(); 
        modulelist1 = new List<Module__c>();              
    }    
    
    public void showReport(){               
        if(result=='all')
                {
           moduleInstance=[select Name,moduleName__c,moduleStatus__c from Module__c];
        }
        else
        {
        moduleInstance=[select Name,moduleName__c,moduleStatus__c from Module__c where moduleStatus__c =: result];
        }  
          
          showReport1=true; 
    }
    public void showModuleReport(){  
     if(result1=='all')
        {
           modulelist1=[select Name,moduleName__c,priority__c from Module__c];
        }
        else
        {
        modulelist1=[select  Name,moduleName__c,priority__c from Module__c where priority__c  =: result1];
        }       
        //showReport1=true;              
    }
      static testMethod void testOperations()
            {
            moduleReportController obj=new moduleReportController();
            obj.result='all ';
            obj.showReport();
            System.assert(obj.modulelist.size()!=0);
            System.assert(obj.showReport1);
            Module__c mod=new Module__c();
            mod=[select Name,moduleName__c,priority__c,moduleStatus__c from Module__c limit 1];
            obj.result = mod.moduleStatus__c;
            obj.showReport();
            System.assert(obj.modulelist.size()!=0);
             obj.result1='all ';
            obj.showModuleReport();
            System.assert(obj.modulelist1.size()!=0);
            mod=[select Name,moduleName__c,priority__c from Module__c limit 1];
            obj.result = mod.priority__c;
            obj.showModuleReport();
            System.assert(obj.modulelist1.size()!=0);
            }       
           
 }