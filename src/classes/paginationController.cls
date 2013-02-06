public class paginationController {

public List<Requirement__c> accountList {get;set;}
public Integer pageNo {get;set;}

public paginationController(){
/*accountList = [SELECT Name,reqName__c FROM Requirement__c];
ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(accountList);
ssc.setPageSize(5);
*/
accountList=con.getRecords();

}

public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                con = new ApexPages.StandardSetController(Database.getQueryLocator([Select Id, Name,reqName__c FROM Requirement__c Order By Name limit 100]));
                // sets the number of records in each page set
                con.setPageSize(5);
            }
            return con;
        }
        set;
    }
    
  public List<Requirement__c> getAccountList() {
        accountList = new List<Requirement__c>();
        for (Requirement__c c : (List<Requirement__c>)con.getRecords())
            accountList.add(c);
            system.debug('------------'+accountList);
        return accountList;
    }
  
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }

 public void callPage(){
// this.pageNo=valueOf(pageNo);
 //con.setpageNumber(3);
// con.previous();
 con.next();

 return ;
 }

}