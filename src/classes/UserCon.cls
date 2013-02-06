public class UserCon
{
    public User__c userIns{get;set;}
    public  UserCon()
    {
        userIns = new User__c(); 
    }
    public void addItems()
    {
        insert userIns;
    }
}