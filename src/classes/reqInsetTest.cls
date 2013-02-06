@isTest 
private class reqInsetTest {
 static testMethod void testSingleInsert() { 
  
  ReqInsertCon cc=new  ReqInsertCon();
   
  Requirement__c rc=new Requirement__c(reqName__c='New Requirement',reqPriority__c='High',reqDescription__c='Demo Description',reqStatus__c='Open',
             reqType__c='Functional',reqVersion__c='1.0',reqProposedBy__c='Vishal');
  cc.reqObj=rc;
  cc.reqInsert();
    // assert that the color on the account matches the account owner's color on their user record  
  System.assertEquals(rc.reqName__c,[Select reqName__c From Requirement__c Where Id = :rc.Id].reqName__c);
  }
}