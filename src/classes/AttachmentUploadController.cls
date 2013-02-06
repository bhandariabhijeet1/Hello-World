public with sharing class AttachmentUploadController {
 
 Map<string, string> parentmap {get;set;}
public Attachment atchmnts {GET;SET;}  
 public List<Requirement__c> reqList {get;set;}
 public Requirement__c reqObj {get;set;}
 public string modID {get;set;}
 public string url {get;set;}
 public string child {get;set;}
  public decimal cnt {get;set;}
  
  public Attachment attachment {
  get {
      if (attachment == null)
        attachment = new Attachment();
      return attachment;
    }
  set;
  }
 
 public AttachmentUploadController(){
 cnt=19;
cnt=cnt.divide(100,3);
url='https://c.ap1.content.force.com/servlet/servlet.FileDownload?file=00P90000000KTbb';

 reqList=new List<Requirement__c>();
 reqList=[select reqName__c,id,Name from Requirement__c where moduleID__r.Name='M-0014'];
 reqObj=new Requirement__c();
parentmap = new Map<string, string> {};
parentmap.put('/a0590000001GRRG', '/00P90000000KTbb');

//child=parentmap.get(atchmnts.ParentId);
 }
 
 
 public void loadData(){
 
//atchmnts=[SELECT Id, Name,ParentId FROM Attachment WHERE ParentId='a0E9000000T4zQL' limit 1];
//parentmap.put(atchmnts.ParentId,atchmnts.id);

 }
 public PageReference dispReq(){
// this.modID=modID;
 reqObj=[select id,Name from Requirement__c where id=:modID];
 return Page.AttachmentUploadPage;
 }
 
  public PageReference upload() {
 
    attachment.OwnerId = UserInfo.getUserId();
    //attachment.ParentId = 'a0E9000000T4zQL'; // the record the file is attached to
   attachment.ParentId = reqObj.id;
    attachment.IsPrivate = true;
 
    try {
      insert attachment;
parentmap.put(reqObj.id,attachment.id);
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
      return null;
    } finally {
      attachment = new Attachment(); 
    }
 
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
    return null;
  }
 
public PageReference viewAttach(){

atchmnts=new Attachment();
atchmnts=[SELECT Id, Name,ParentId FROM Attachment WHERE ParentId=:reqObj.id limit 1];
parentmap.put(atchmnts.ParentId,atchmnts.id);

string b='00P90000000KTbb';
url='https://c.ap1.content.force.com/servlet/servlet.FileDownload?file='+atchmnts.id;
return null;
}
public string bodyContent {get;set;}
public void fetchBody(){

bodyContent = atchmnts.body.toString();

}


}