public class ReqAddController
{
    public List<Module__c>modList{get;set;}
    public List<Requirement__c>reqList{get;set;}
    public Requirement__c reqIns{get;set;}
    public String modID{get;set;}
    public String focus{get;set;}
    public boolean plus{get;set;}
    public boolean minus{get;set;}
    public boolean tab1{get;set;}
    public boolean tab2{get;set;}
    public  ReqAddController()
    {
        modList=[select moduleName__c from Module__c ]; 
        reqIns = new Requirement__c();
        focus='name1';
        plus=true;
        minus=false;
        tab1=false;
        tab2=true;
        System.debug(modID); 
    }
    public void dispReq()
    {
       //reqList=[]
        //plus=false;
        //minus=true;    
    }
    public  void loadTab()
    {
        focus='name2';
        tab1=true;
        tab2=false;
    }
    public void addItems()
    {
        insert reqIns;
        focus='name1';
        tab1=false;
        tab2=true;
    }
    public PageReference redirect()
    {
        PageReference viewPage = new PageReference('/apex/RequirementDetail');
        return viewPage; 
    }
}