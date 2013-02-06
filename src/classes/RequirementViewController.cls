public Global with sharing class RequirementViewController
{
    public String modID{get;set;}
    public String user{get;set;}
    public String currentProjectID{get;set;}
    public String selectedrole{get;set;}
    public String role{get;set;}
    public String reqAttachId{get;set;}
    public String selectedAttachmentId{get;set;}
    public String url{get;set;}
    
    public boolean mod{get;set;}
    public boolean req{get;set;}
    public boolean atmt{get;set;}
    public boolean booleanAttachjs{get;set;}
    public boolean reqView1{get;set;}
    public boolean reqView2{get;set;}
    public boolean modView1{get;set;}
    public boolean modView2{get;set;}
    
    public Module__c modname{get;set;}
    public Requirement__c reqName{get;set;}
     
    public List<Requirement__c>reqList{get;set;}
    public List<Module__c>modList{get;set;}
    public List<iRequirement>holder{get;set;}
    public List<Attachment> reqAttachList {get;set;}
    public List<ModuleWrapper> moduleListWrapper { get; set; }
    
    public Decimal cnt {get;set;}
    public Integer statuscnt {get;set;}

    public RequirementViewController()
    {
        user=System.currentPagereference().getParameters().get('user');        
        currentProjectID=System.currentPagereference().getParameters().get('project');
        role=System.currentPagereference().getParameters().get('role');
        atmt=false;
        modList=new List<Module__c>();
        if(role=='admin')
            modList=[select id, moduleName__c,moduleSpecification__c,priority__c,startDate__c,endDate__c from Module__c where projectID__c=:currentProjectID];    
        else
            modList=[select  id, moduleName__c,moduleSpecification__c,priority__c,startDate__c,endDate__c from Module__c where id in (Select user_of_module__c  from ModuleUser__c where EmpID__c =:user and ProjectUserRole__c=:role) and projectID__c=:currentProjectID];        
        List<Requirement__c> tempreqList=new List<Requirement__c>();
        List<Requirement__c> statusreqList=new List<Requirement__c>();
        moduleListWrapper=new List<ModuleWrapper>();
        //counting no. of requirements in each module
             
        for(Module__c m:modList)
        {
            moduleListWrapper.add(new ModuleWrapper(m));
        }
        for(ModuleWrapper mw:moduleListWrapper)
        {
            tempreqList=[select Name from Requirement__c where moduleID__r.id=:mw.modObj.id];
            statusreqList=[select Name from Requirement__c where moduleID__r.id=:mw.modObj.id and reqStatus__c='success'];
            cnt=tempreqList.size();
            statuscnt=statusreqList.size();
            if(statuscnt!=0)
            {
                cnt=(statuscnt/cnt)*10000;
                cnt=cnt.Divide(100,2);
            }
            else 
                cnt=0;
            mw.width= String.valueOf(cnt);
            tempreqList=new List<Requirement__c>();
        }
        mod=true;
        req=false;
        atmt=false;
        booleanAttachjs=false;
        reqView1=true;
        if(moduleListWrapper.size()==0)
        {
            modView1=false;
            modView2=true;
        }
        else
        {
            modView1=true;
            modView2=false;
        }
    }
    public void verifyAttachments()
    {
        
        booleanAttachjs=false;
        atmt=false;
        holder=new List<iRequirement>();
        modname=new Module__c();
        modname=[select moduleName__c from Module__c where id=:modID];
        for(Requirement__c r :[Select  Name,id,reqName__c,reqDescription__c,reqPriority__c,reqType__c from Requirement__c where  moduleID__r.id=:modID])
        {
            holder.add(new iRequirement(r));
        }
        for(iRequirement r:holder)
        {
            for(Attachment a:[select ParentId from Attachment])
            {
                if(a.ParentId==r.req.id)
                {
                    r.message=false;
                    r.checkAttach=true;
                }
            }
        }
        req=true;
        if(holder.size()==0)
        {
            reqView1=false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No Requirements Added yet for this module...');
            ApexPages.addMessage(myMsg);
        }
        else
        {
            reqView1=true;
        }
    }
    public void back()
    {
        booleanAttachjs=false;
        atmt=false;
        mod=true;
        req=true;
    }
    public void openAttach()
    {
        mod=false;
        req=false;
        booleanAttachjs=false;
        atmt=true;
        reqAttachList=new List<Attachment>();
        reqAttachList=[SELECT Id, Name,ParentId FROM Attachment WHERE ParentId=:reqAttachId];
        reqname=new Requirement__c();
        reqname=[select reqName__c from Requirement__c where id=:reqAttachId];        
    }
    public PageReference viewAttach()
    {
        booleanAttachjs=true;
        url='https://c.ap1.content.force.com/servlet/servlet.FileDownload?file='+selectedAttachmentId;
        return null;
    }    
    public class iRequirement
    {    
        public Requirement__c req{get;set;}
        public boolean checkAttach{get;set;}
        public boolean message{get;set;} 
        
        public iRequirement(Requirement__c r)
        {
            req=r;
            checkAttach=false;
            message=true;
        }        
    }
    public class Modulewrapper
    {
        public String width{get;set;}
        public Module__c modObj {get;set;}
 
        public Modulewrapper(Module__c m)
        {
            modObj=m;
            width='';
        } 
    }//end of moduleWrapper
}