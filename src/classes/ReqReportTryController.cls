public class ReqReportTryController
{
    public List<SelectOption> options;
    public String fileFormat=null;
    public string module{get;set;}
    public string author{get;set;}
    public string status{get;set;}
    public string rtype{get;set;}
    public string priority{get;set;}
    public List<Requirement__c> reqList{get;set;}
    String[] check = new String[]{};
    String[] store=new String[]{};
    public string setType{get;set;}
    public string status1{get;set;}
    public SDate__c startDate{get;set;}
    public SDate__c endDate{get;set;}
     public String user{get;set;}
     public String currentProjectId{get;set;}     
   /* public PageReference test() {
        return null;
    }*/
   public ReqReportTryController()
   {
         //reqList=new List<Requirement__c>();
        //  author=null;status=null;rtype=null;priority=null;
       //module='vishal';
      //status='status';
      startDate=new SDate__c();
      endDate=new SDate__c();
       // user=System.currentPagereference().getParameters().get('user');
       currentProjectID=System.currentPagereference().getParameters().get('project');
       
    }      
    
    public List<SelectOption> getFormats() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('HTML','HTML')); 
        options.add(new SelectOption('Pdf','Pdf')); 
        options.add(new SelectOption('MS-Word','MS-Word')); 
        options.add(new SelectOption('MS-Excel','MS-Excel')); return options; 
    }
    public string returnModule()
    {
         return module;
    }
    public PageReference test(){
    return Page.RequirementReportsPage;
    }
  
    public string returnPriority()
    {
         return priority;
    } 
    public string selectedformat()
    {
         return fileFormat;
    }                 
    public List<SelectOption> getModules()
    {                       
         options = new List<SelectOption>();  
         options.add(new SelectOption('-Any-','-Any-'));
         for (Module__c a : [select Name,moduleName__c from Module__c where projectID__c=:currentProjectID order by Name]) {           
               options.add(new SelectOption(a.Name,a.moduleName__c));           
          } 
                    
          return options;        
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
    public String getfileFormat() {
        return fileFormat;
    }
                    
    public void setfileFormat(String fileFormat) { this.fileFormat = fileFormat; }
    
    public String getmodule() {
        return module;
    }
                    
    public void setmodule(String module) { this.module = module; }
    
    public PageReference Reports()
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
                                              
          //PageReference page;
         // page = new PageReference('/apex/showReports?module='+module+'&status='+status);
         PageReference newPage=Page.showReports;
         //newPage.setRedirect(true);
         return newPage;
          // return null;
    
    }  
    public PageReference returnEdit(){ //redirect to the previous page after pressing cancel
         return Page.RequirementReportsPage;
    }          
}