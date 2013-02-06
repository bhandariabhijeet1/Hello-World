public class TestCaseCon
{
    public TestCase__c testCaseIns{get;set;}
    public TestCaseCon()
    {
        testCaseIns=new TestCase__c();
    }
    public void addItem()
    {
        insert testCaseIns;
    }
}