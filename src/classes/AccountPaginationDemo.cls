global class AccountPaginationDemo implements al.SObjectPaginatorListener {
    global List<Requirement__c> accounts {get;private set;}
    global al.SObjectPaginator paginator {get;private set;}
    global AccountPaginationDemo(){
        accounts = new List<Requirement__c>();
        //15 is pageSize, this refers to this class which acts as listener to paginator
        paginator = new al.SObjectPaginator(5,this);
        paginator.setRecords([select id,name,reqName__c,reqPriority__c from Requirement__c limit 100]);
    }
    global void handlePageChange(List<SObject> newPage){
        accounts.clear();
        if(newPage != null){
            for(SObject acct : newPage){
                accounts.add((Requirement__c)acct);
            }
        }
    }
}