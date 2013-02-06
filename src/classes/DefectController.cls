public class DefectController{

    public String reqId{get;set;}
    public TestCase__C testCaseObj{get;set;}
    public String buildId { get; set; }
    public List<Defect__c> defectList {get; set;}
    public String testId { get; set; }
    public Defect__c defectObj {get;set;}
    public TestCaseBuild__c buildObj {get;set;}
    public Attachment atchmnts {get;set;}       
    
    //constructor accessing parameters
    public DefectController(){
      testId=System.currentPageReference().getParameters().get('id');
      buildId=System.currentPageReference().getParameters().get('buildId');
      testCaseObj=new TestCase__c();
      testCaseObj=[Select id,expectedOutput__c,actualOutput__c ,testDescription__c,testSteps__c from TestCase__c where id=:testId];
      reqId=System.currentPageReference().getParameters().get('reqId');
      //testList=[select id from TestCase__c where reqID__r.id=:reqId];
      
      defectList=new List<Defect__c>();
      defectList=[select defectName__c,defectDescription__c,defectSeverity__c,defectStatus__c from Defect__c limit 5];
      defectObj=new Defect__c();
      buildObj=new TestCaseBuild__c();
   }
    
    public Attachment attachment {
      get {
          if (attachment == null)
          attachment = new Attachment();
          return attachment;
      }
      set;
    }
 
    
    //function to insert defect data
    public void addDefect(){
       testCaseObj=new TestCase__c();
       buildObj=[Select id from TestCaseBuild__c where id=:buildId];
       testCaseObj=[Select id,expectedOutput__c,actualOutput__c ,testDescription__c,testSteps__c from TestCase__c where id=:testId];
       defectObj.testId__c=testCaseObj.id;
       defectObj.TestCaseBuildID__c=buildObj.id;
       insert defectObj;
       upload();
       } 
    
   //function to insert attachment to the defect
    public void upload() {
        attachment.name=defectObj.defectName__c;
        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = defectObj.id;
        attachment.IsPrivate = true;
 
      try {
        insert attachment;
      }
      catch (DMLException e) {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
        return;
      } 
      finally {
      attachment = new Attachment(); 
      }
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
      return ;
    }
   
    
    /* public PageReference viewAttach(){
        atchmnts=new Attachment();
        atchmnts=[SELECT Id, Name,ParentId FROM Attachment WHERE ParentId=:defectObj.id limit 1];
        url='https://c.ap1.content.force.com/servlet/servlet.FileDownload?file='+atchmnts.id;
        return null;
     }*/
 
 
   }//end of controller