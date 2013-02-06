public class try2Con
{
    public String ref{get;set;}
    public boolean var1{get;set;}
    public Integer count{get;set;}
    public String modID{get;set;}
    public Requirement__c reqIns{get;set;}
    //public Module__c moduleIns{get;set;}
    public List<Module__c> modList{get;set;}
    public Project__c projIns{get;set;}
    public List<Requirement__c> reqList { get; set; }
    public try2Con()
    {
        var1=false;
        projIns=new Project__c();
        reqIns=new Requirement__c();
        //moduleIns=[select moduleName__c from Module__c limit 1];
        projIns=[select Name,projectTitle__c from Project__c Limit 1]; 
        modList=[select id,moduleName__c from Module__c ];
        count=modList.size();
        //for()
        reqList = [Select  Name,id,reqName__c from Requirement__c where  moduleID__r.id=:modID];  
        //reqList = [Select  Name,id,reqName__c from Requirement__c];    
    }
    public void loadData()
    {
         projIns=[select Name,projectTitle__c from Project__c Limit 1]; 
         //moduleIns=[select Name,moduleName__c from Module__c limit 1];
         modList=[select moduleName__c from Module__c ]; 
         reqList = [Select  Name,id,reqName__c from Requirement__c where  moduleID__r.id=:modID];        
    }
     public PageReference  addItems()    
    {        
        insert reqIns;
        PageReference oldpage;
        if(ref!=NULL)
            
        if(ref=='full')
        {
            var1=false;
            oldPage=Page.try2;
            
           
        }            
        else
        {    
            var1=true;
            reqIns = new Requirement__c(); 
            loadData();
            oldPage=Page.try2;
            
           
        }
         return oldPage;
    }
   /* public void callRequirementList()
    {
        reqList = [Select  Name,id,reqName__c from Requirement__c where  moduleID__r.id=:modID]; 
    }*/
    public PageReference redirect()
    {
        PageReference viewPage = new PageReference('/apex/RequirementDetail');
        return viewPage; 
    }
    public void showform()
    {
        var1=true;
    }

}