public with sharing class ReqAddCon
{
    public List<Module__c>modList{get;set;}
    public List<Requirement__c> reqList{get;set;}
    public List<Requirement__c> reqList1{get;set;}
    public List<Attachment> reqAttachList {get;set;}
    public List<ModuleWrapper> moduleListWrapper { get; set; }
    
    public Requirement__c tobeEdited2{get;set;}
    public Requirement__c reqIns{get;set;}
    public Employee__c userName{get;set;}
    public Requirement__c tobeDeleted{get;set;}
    public Module__c modname{get;set;}
    public Requirement__c requirename{get;set;}
    
    public String modID{get;set;}
    public String reqName{get;set;}
    public String reqName1{get;set;}
    public String user{get;set;}
    public String currentProjectId{get;set;}
    public String role{get;set;}
    public String description{get;set;}
    public String name{get;set;}
    public String priority{get;set;}
    public String propby{get;set;}
    public String status{get;set;}
    public String reqtype{get;set;}
    public String ver{get;set;}
    public string reqAttachId {get;set;}
    public string selectedAttachmentId{get;set;}
    public string deleteAttachmentId{get;set;}
    public string url {get;set;}
    public String empName{get;set;}
    
    public boolean var1{get;set;}
    public boolean var2{get;set;}
    public boolean atmt{get;set;}
    public boolean booleanAttach{get;set;}
    public boolean booleanEditAttach{get;set;}
    public boolean booleanAttachList{get;set;}
    public boolean booleanAttachjs{get;set;}
    public boolean boolAttach2 {get;set;} 
    public boolean boolAttach3 {get;set;} 
    public boolean boolAttach4 {get;set;} 
    public boolean boolAttach5 {get;set;}
    public boolean boolAddMore1 {get;set;} 
    public boolean boolAddMore2 {get;set;} 
    public boolean boolAddMore3 {get;set;} 
    public boolean boolAddMore4 {get;set;}
    public boolean boolAddMore5 {get;set;}
    public boolean reqAdd1{get;set;}
    public boolean reqAdd2{get;set;}
    public boolean modAdd1{get;set;}
    public boolean modAdd2{get;set;}
    
    public static integer i {get;set;}
    public Attachment attachment2 {get;set;}
    public Attachment attachment3 {get;set;}
    public Attachment attachment4 {get;set;}
    public Attachment attachment5 {get;set;}
     
     
    public Decimal cnt {get;set;}
    public Integer statuscnt {get;set;}         

    public  ReqAddCon()
    {
        try
        {
            user=System.currentPagereference().getParameters().get('user');
            currentProjectID=System.currentPagereference().getParameters().get('project');
            role=System.currentPagereference().getParameters().get('role');
            reqList1=new List<Requirement__c>();
            userName = new Employee__c();
            userName=[select id,empName__c from Employee__c where id=:user];
            empName=userName.empName__c;
            if(role=='admin')
                modList=[select id,moduleName__c,startDate__c,endDate__c,moduleSpecification__c,moduleStatus__c,priority__c,projectID__c from Module__c where projectID__c=:currentProjectID];      
            else               
                modList=[select  id,moduleName__c,startDate__c,endDate__c,moduleSpecification__c,moduleStatus__c,priority__c,projectID__c from Module__c where id in (Select user_of_module__c  from ModuleUser__c where EmpID__c =:user and ProjectUserRole__c='a0G90000002af7d') and projectID__c=:currentProjectID];                   
             List<Requirement__c> tempreqList=new List<Requirement__c>();
             List<Requirement__c> statusreqList=new List<Requirement__c>();
             moduleListWrapper=new List<ModuleWrapper>();             
             for(Module__c m:modList)
             {
                 moduleListWrapper.add(new ModuleWrapper(m));
             }
             if(moduleListWrapper.size()==0)
             {
                 modAdd1=false;
                 modAdd2=true;
             }
             else
             {
                 modAdd1=true;
                 modAdd2=false;
             }
             for(ModuleWrapper mw:moduleListWrapper)
             {
                 tempreqList=[select Name from Requirement__c where moduleID__r.id=:mw.modObj.id];
                 statusreqList=[select Name from Requirement__c where moduleID__r.id=:mw.modObj.id and reqStatus__c='complete'];
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
            
            reqIns = new Requirement__c();
            tobeEdited2=new Requirement__c();
            var2=true;
            var1=false;
            atmt=false; 
            booleanAttach=false;     
            booleanAttachjs=false;     
   
            boolAttach2=false;
            boolAttach3=false;
            boolAttach4=false;
            boolAttach5=false;
       
            boolAddMore1=true;
            boolAddMore2=false;
            boolAddMore3=false;
            boolAddMore4=false;
            boolAddMore5=false;
            attachment2=new Attachment();
            attachment3=new Attachment();
            attachment4=new Attachment();
            attachment5=new Attachment();
            i=0;
            //deleteAttachmentId='ff090df';
            dynamicAttachmentList=new List<Attachment>();
            dynamicAttachmentObj=new Attachment();
            dynamicAttachmentList.add(new Attachment());
            
       }
        catch(Exception e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error In Loading Page');
            ApexPages.addMessage(myMsg);
        }
    }

    public void loadData()
    {
        name='';
        description='';
        priority='';
        propby='';
        status='';
        reqtype='';
        ver='';
        boolAddMore1=true;
        boolAddMore2=false;
        boolAddMore3=false;
        boolAddMore4=false;
        boolAddMore5=false;
        booleanAttach=false;
        booleanAttachList=false;
        boolAttach2=false;
        boolAttach3=false;
        boolAttach4=false;
        boolAttach5=false;
        i=0;
        
        
    }
    
    public Attachment attachment1 
    {
        get 
        {
            if (attachment1 == null)
                attachment1 = new Attachment();
            return attachment1;
        }
        set;
    }
 
    public PageReference dispReq()
    {
        booleanAttachjs=false;
        booleanAttach=false;    
        try
        {
            modname=new Module__c();
            modname=[select moduleName__c from Module__c where id=:modID];
            reqList=new List<Requirement__c>(); 
            reqList=[Select  Name,id,reqName__c from Requirement__c where  moduleID__r.id=:modID];
        }
        catch(ListException e)
        {
            ApexPages.addMessages(e);
        }
        var1=true;
        return null;
    }
    public void cancelatt()
    {
        booleanAttachjs=false;
        atmt=false;
        var2=true;
        var1=true;
    }
    public PageReference loadEdit()
    { 
        booleanAttachjs=false;
        try
        {
            tobeEdited2 = [Select  Name,reqName__c,reqType__c,reqDescription__c,reqPriority__c,reqProposedBy__c,reqVersion__c from Requirement__c  where Name=:reqName limit 1];
            reqName=tobeEdited2.reqName__c;
        }
        catch(ListException e)
        {
          ApexPages.addMessages(e);
        }
        return Page.ReqAddEdit;   
    }
    public PageReference editItems()
    {
        booleanAttachjs=false;
        booleanAttach=false;
        try
        {
            update tobeEdited2; 
        }
        catch(DMLException e){
           ApexPages.addMessages(e);
        }
        reqIns=new Requirement__c();
        reqIns=[select id from Requirement__c where id=:tobeEdited2.id];
         upload1();
        loadData(); 
        tobeEdited2= new Requirement__c();
        checkAttachment();    
        return Page.ReqAddPage;
    }
    
    public PageReference delReq()
    { 
        reqList1=[select id,Name,reqName__c from Requirement__c where Name=:reqName1];
        if (reqList1==null) 
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error In Fetching List');
            ApexPages.addMessage(myMsg);
            return Page.ReqAddPage;
        }      
        Requirement__c tobeDeleted = null;
        for(Requirement__c a : reqList1)
            if (a.Name == reqName1) 
            {
                tobeDeleted = a;
                break;
            }
            //if emp record found delete it
            if (tobeDeleted != null) 
            {
                Delete tobeDeleted;
            }
            else
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error In Fetching List');
                ApexPages.addMessage(myMsg);
            }
            checkAttachment();
        return null;
    }
    
    public PageReference loadForm()
    { 
        booleanAttachjs=false;
        return Page.ReqAddForm;
    }
    
    public PageReference cancelForm()
    { 
        booleanAttachjs=false;
        booleanAttach=false;
        System.debug('-----------------hello-------------------------------');
       
        dynamicAttachmentList.clear();
        dynamicAttachmentList.add(new Attachment());
         loadData();
        return Page.ReqAddPage;
    }
    
    public PageReference addItems()
    {
        booleanAttachjs=false;
        booleanAttach=false;
        try
        {
           reqIns=new Requirement__c(reqName__c=name,reqDescription__c=description,reqPriority__c=priority,reqProposedBy__c=empName,reqType__c=reqtype,reqStatus__c='inprogress',moduleID__c=modID);
           insert reqIns;
        }
        catch(DMLException e)
        {
            ApexPages.addMessages(e);
        }
        upload1();
        loadData(); 
        checkAttachment();   
        return Page.ReqAddPage;
    }
    public PageReference boolattach()
    {
        booleanAttach=true;
        return null;
    }
    public List<Attachment> dynamicAttachmentList {get;set;}
    public Attachment dynamicAttachmentObj {get;set;}
   
    public PageReference attachMoreList1()
    {
        dynamicAttachmentList.add(new Attachment());
        return null;
    }
    
    public void upload1()
    {
        try 
        {
            for(Attachment a:dynamicAttachmentList)
            {
                a.OwnerId = UserInfo.getUserId();
                a.ParentId = reqIns.id;
                a.IsPrivate = true;
                if(a.body!=null)
                {
                    insert a;
                }
            }
        }
         catch (DMLException e) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));           
        } 
        finally 
        {
            dynamicAttachmentList.clear();
            dynamicAttachmentList.add(new Attachment());        
        }       
    }
    public PageReference selectAttach()
    {
        //  booleanAttachjs=true;
        booleanAttachjs=false;
        var1=false;
        var2=false;
        atmt=true;
        booleanAttachList=true;
        try
        {
            requirename=new Requirement__c();
            requirename=[select reqName__c from Requirement__c where id=:reqAttachId];
            reqAttachList=new List<Attachment>();
            Requirement__c reqAttach=new Requirement__c();
            reqAttach=[select id,Name from Requirement__c where id=:reqAttachId];
            reqAttachList=[SELECT Id, Name,ParentId FROM Attachment WHERE ParentId=:reqAttach.id];
        }
        catch(ListException e)
        {
              ApexPages.addMessages(e);
        }
        return null;
    }   

    public PageReference viewAttach()
    {
        booleanAttachjs=true;
        url='https://c.ap1.content.force.com/servlet/servlet.FileDownload?file='+selectedAttachmentId;
        booleanAttach=false; 
        return null;
    }
    
    public void deleteAttach()
    {
        booleanAttachjs=false;
        Attachment delAttach=new Attachment();
        this.deleteAttachmentId=deleteAttachmentId;
        delAttach=[select id from Attachment where id=:deleteAttachmentId];
        delete delAttach;
        reqAttachList=[SELECT id, Name,ParentId FROM Attachment WHERE ParentId=:reqAttachId];
        //return Page.ReqAddPage;
        checkAttachment();
        atmt=false;
        var2=true;
        var1=true;
    }
    public PageReference addManyItems()
    {
        booleanAttachjs=false;
       
        booleanAttach=false;
        try
        {
            reqIns=new Requirement__c(reqName__c=name,reqDescription__c=description,reqPriority__c=priority,reqProposedBy__c=user,reqType__c=reqtype,reqStatus__c='inprogress',moduleID__c=modID);
            insert reqIns;
        }
        
        catch(DMLException e)
        {
               ApexPages.addMessages(e);
        }
        upload1();
        
        loadData(); 
        checkAttachment();
        return null;           
    }
    //requirement wrapper class list
    public List<rRequirement> reqWrapperList{get;set;}

    public PageReference checkAttachment() 
    {
        modname=new Module__c();
        modname=[select moduleName__c from Module__c where id=:modID];
        booleanAttachjs=false;
        booleanAttach=false;  
        try
        {
            reqWrapperList = new List<rRequirement>();
            for(Requirement__c r : [select Name,id,reqName__c,reqDescription__c,reqPriority__c,reqType__c from Requirement__c where  moduleID__r.id=:modID]) 
            { 
                reqWrapperList.add(new rRequirement(r));
            }
            if(reqWrapperList.size()==0)
            {
                reqAdd1=false;
                reqAdd2=true;
            }
            else
            {
                reqAdd1=true;
                reqAdd2=false;
            }
            for(rRequirement r:reqWrapperList)
            {
                for(Attachment a:[select ParentId from Attachment])
                {
                    if(a.ParentId==r.req.id)
                    {
                        r.haveAttachment=true;
                        r.message=false;
                    }
                }
            }
      }
      catch(ListException e)
      {
          ApexPages.addMessages(e);
      }
      var1=true;  
      return null;
    }
 
    public class rRequirement 
    {
        public Requirement__c req {get; set;}
        public Boolean haveAttachment {get; set;}
        public boolean message{get;set;}

        //This is the contructor method. When we create a new cContact object we pass a Contact that is set to the con property. We also set the selected value to false
        public rRequirement(Requirement__c r) 
        {
            req = r;
            haveAttachment = false;
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