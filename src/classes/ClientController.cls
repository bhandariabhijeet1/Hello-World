public class ClientController
{
 public Client__c clientIns{get;set;}  
 public List <SelectOption> allClients {get;set;}
 public boolean showTopPanel{get;set;} 
 public boolean showMiddlePanel{get;set;}
 public boolean showLastPanel{get;set;}
 public String selectedClient{get;set;}
 public ClientController()
    {
     clientIns = new Client__c();
      allclients=new List<SelectOption>(); 
       showTopPanel=true;
        showMiddlePanel=false;
        showLastPanel=true;
    }


 public List<SelectOption> getItems()
        {
        allclients=new List<SelectOption>(); 
        for(List<Client__c> clientList: [select  clientCompany__c from Client__c ])
                {
                for(Client__c c: clientList)
                    {
                     allClients.add(new SelectOption(c.clientCompany__c,c.clientCompany__c));
                    }  
                return allClients;
                }   
         return allClients;
        }
  public String SelectedClientID()
         {
         Client__c client= new Client__c();
         client=[select Name from Client__c where clientCompany__c=:selectedClient];
         return client.id;
          }
   public PageReference showClientInputFormshowClientInputFormshowClientInputFormshowClientInputFormshowClientInputFormshowClientInputFormshowClientInputFormshowClientInputFormshowClientInputFormshowClientInputFormshowClientInputFormshowClientInputFormshowClientInputForm()
    {
     showTopPanel=false;
     showMiddlePanel=true;
     showLastPanel=false;  
     PageReference page = new PageReference('/apex/createProjectPage');
     return page;
    }
   public PageReference addClientItems()    
    {        
        insert clientIns; 
         showTopPanel=true;
         showMiddlePanel=false;
         showLastPanel=true;
        PageReference page = new PageReference('/apex/createProjectPage');
         return page;   
    }
}