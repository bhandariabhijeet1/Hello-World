public class ClientCon
{    
    public Client__c clientIns{get;set;}    
    public  ClientCon()    
    {        
           clientIns = new Client__c();     
    }    
    public void addClientItems()    
    {        
        insert clientIns;    
    }
}