global class myPaginationController implements al.ObjectPaginatorListener {
    global List<SelectableAccount> accounts {get;private set;}
    global al.ObjectPaginator paginator {get;private set;}
    
    global List<ModuleUser__c> Liststr {get;private set;}
    global List<SelectableAccount> all{get;private set;}
    public boolean bool{get;set;}
    
    public myPaginationController(){
        /*this.accounts = new List<SelectableAccount>();
        bool=false;
        all = new List<SelectableAccount>();
        List<ModuleUser__c> records = [select id,Name from ModuleUser__c order by Name limit 100];
        if(records != null){
            for(ModuleUser__c acct : records){
                all.add(new SelectableAccount(acct));
            }
        }
        //15 is pageSize, this refers to this class which acts as listener to paginator
        paginator = new al.ObjectPaginator(10,this);
        paginator.setRecords(all);*/
        getUsersDisplay();
    }
   public List<SelectableAccount> getUsersDisplay()
     {
        this.accounts = new List<SelectableAccount>();
        bool=false;
        all = new List<SelectableAccount>();
        List<ModuleUser__c> records =  [select id, Name,EmpID__r.Name,EmpID__r.empName__c,EmpID__r.empDesignation__c,EmpID__r.BU__c,ProjectUserRole__r.projectRole__c,user_of_module__r.moduleName__c
             from ModuleUser__c limit 100];
        if(records != null){
            for(ModuleUser__c acct : records){
                all.add(new SelectableAccount(acct));
            }
        }
        //15 is pageSize, this refers to this class which acts as listener to paginator
        paginator = new al.ObjectPaginator(5,this);
        paginator.setRecords(all);
        return all; 
      }    
    global void handlePageChange(List<Object> newPage){
        accounts.clear();
        //all.clear();
        if(newPage != null){
            for(Object acct : newPage){
               accounts.add((SelectableAccount)acct);
               //all.add((SelectableAccount)acct);
            }
        }
    }
    public class SelectableAccount{
        public Boolean selected{get;set;}
        public ModuleUser__c obj{get;set;}
        public SelectableAccount(ModuleUser__c obj){
            this.obj = obj;
        }
    }
    public PageReference getemployeeSelected() /*function to delete selected employee*/
    {               
        
        Integer ctr=1;
        bool=true;
        Liststr=new List<ModuleUser__c>();
        ModuleUser__c tobeDeleted = null;
        for(SelectableAccount cCon : all) {
            if(cCon.selected == true)
            {
                        
               Liststr.add(cCon.obj);
                
            }
            
        } 
        return null;     
     }      
}