public class PageController{

    /**
     * variable is used to store pass value from apex page. 
     */    
    String val;
    public String getVal(){
        return val;
    }
    public string[] ListField {get;set;}
    public PageController(){
    ListField=new String[2];
   ListField[0]='reqName__c';
    //ListField.add('reqName__c');
    }    
    public void setVal(String str){
        val=str;
    }
    
    /**
     * called from apex page on chage in  pagesize to display a records for that pagesize
     */
     
    public PageReference fetchRecords() {
             val= Apexpages.currentPage().getParameters().get('one').trim();
             system.debug('-----------------VAL-----'+val);
             setPageSize(Integer.valueOf(val));
             con.setPageSize(Integer.valueOf(val));             
             first();
             system.debug('---------------call first--');
             System.debug('------------pagesize---'+pagesize+'------noOfPages--'+getnoofpages()+'---------toRecordNo---'+toRecordNo);
             return null;
    }

    /**
     * Store the page number
     */
    
    Integer pageNo{
    get{
        return con.getPageNumber();
    }
    set;
    }
    
    public Integer getPageNo(){
       return con.getPageNumber();
    }
    
    public void setPageNo(Integer No){
        pageNo=No;
    }
    
    
    
     /**
     * Used on apex page page to display starting record number
     */
    Integer fromRecordNo;
    public Integer getFromRecordNo(){
          return ((con.getPageNumber()*con.getpagesize())-(con.getpagesize()-1));
    }
    public void setFromRecordNo(Integer no){
        FromRecordNo=no;
    }
    
    /**
     * Used on apex page page to display ending record number
     */
    Integer toRecordNo;
  
    
    public Integer gettoRecordNo(){
        if((con.getPageNumber()*con.getpagesize())>con.getResultSize()){
           System.debug('----------In to record no :'+pageSize+'---------'+pageNo+'------rs:'+noOfRecords);
            return con.getResultSize();
        }else
             System.debug('----------In to record no :'+pageSize+'---------'+pageNo+'------rs:'+noOfRecords);
          return (con.getPageNumber()*con.getpagesize());
    }
    
    public void settoRecordNo(Integer no){
        toRecordNo=no;
    }
    
   /**
    * Store the total results (number of records) in StandardSetController
    */
 
    
    Integer noOfRecords;
 
    public Integer getnoOfRecords(){
          return con.getResultSize();
    }
    
    public void setnoOfRecords(Integer no){
        noOfRecords=no;
    }

    /**
     * Store the total number of pages used to display the rcords for current pagesize 
     */
 
    Integer noOfPages;
 
     public Integer getNoOfPages(){
           noOfPages=(con.getResultSize())/(con.getpagesize());
            if(Math.mod(con.getResultSize(),con.getpagesize())>0){
                noOfPages=noOfPages+1;
            }
            System.debug('---------------No of Pages-'+noOfPages);
             return noOfPages;
    }
    
    public void setNoOfPages(Integer no){
        noOfPages=no;
    }
    
    /**
     * Store the Object Name which is used for pagination 
     */
    String objectName;
    
    public String getObjectName(){
        System.debug('-------------In get ObjectName()---'+objectName);
        return ObjectName;
    }
    
    public void setObjectName(String str){
        System.debug('-------------In set ObjectName()---'+str);
        ObjectName=str;
        sObjType=objectName;
    }
    
   /**
    * variable is used to store the sObject(record var is component) passed in componet tag. 
    */
    String objLabel=null;
    
    public String getobjLabel () {
        objLabel=ObjectName.replace('__c','');
        return objLabel;
    }
    
    public void setobjLabel(String str) {
        System.debug('-------------In set sObj()---');
        objLabel=str;
    }
    
    
   /**
    * variable is store the all records of sObject passed in componet tag. 
    */
    sObject[] records;
    
    public sObject[] getRecords() {
     
        records=con.getRecords();
        System.debug('-------------In get sObj()---'+records);
        return records;
    }
    
    
   /**
    * variable is used to build the Query String . 
    */
    
    String queryString;
    public String getqueryString(){
        return queryString;
    }

    public void setqueryString(String str){
        queryString=str;
    }

   /**
    * variable is used to set number of records per page. 
    */
    Integer pagesize;
    
    public Integer getPageSize(){
    
        System.debug('-------------In get Page Size()---'+pagesize);
        return con.getPageSize();
    }
    
    public void setPageSize(Integer size){
         
        pageSize=size;
        System.debug('-----**In setPagesize==========='+pagesize);
    }
    
    
   /**
    * variable is used to store the type of sObject i.e.Case,Contact etc. 
    */
    String sObjType;

    public void setSObjType(String str){
        sObjType=str;
    }
    
    public String getSObjType(){
        return sObjType;
    }    
                 
   /**
    * variable contains the Label of columns to displayed on page.
    */
    

  /*  List<String> colLabelList;
    
    public void setcolLabelList(List<String> lst){
        colLabelList=lst;
    }
    
    /**
     * variable is used to calculate table width
     */
  /*  Double tableWidth{get;set;}
    public Double getTableWidth(){
    
        return tableWidth;
    }

    */
   /* public List<String> getcolLabelList(){
    Integer i=0,j=0,k=0;
    colLabelList=new list<String>();
        
            
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();    
            Map<String, Schema.SObjectField> fieldMap = gd.get(objectName).getDescribe().fields.getMap();
            System.debug('///////////////////'+fieldMap );
            
            for(String singleColName:colNameList){
              Schema.SObjectField sfield = fieldMap.get(singleColName);
              Schema.DescribeFieldResult dfield = sfield.getDescribe();
               colLabelList.add(dfield.getLabel());
            }
        
           /* for(Schema.SObjectField sfield : fieldMap.Values()){
            System.debug('====i=='+i++);
                Schema.DescribeFieldResult dfield = sfield.getDescribe();  
                String apiName=dfield.getName();
                for(String singleColName:colNameList){
                System.debug('====j=='+j++);
                    if(singleColName.equals(apiName)){          
                       System.debug('====k=='+k++);        
                        colLabelList.add(dfield.getLabel());
                    
                    }    
                    System.debug('------------------------'+  dfield.getLabel()+'-----------------'+ dfield.getName());
               }
            }*/

       /*
        tableWidth= 98/colLabelList.size();
        
            
       
        return colLabelList;
    }
*/
   
    
   /**
    * variable contains the API name of columns to displayed on page.
    */
    
    List<String> colNameList=new list<String>();
    
    public void setcolNameList(List<String> lst){
        colNameList=lst;
    }
    
    public List<String> getcolNameList(){
        return colNameList;
    }
    
    
    /**
     *  Standard set controller for pagination support -Limits :   only 10,000 records can be processed and at most 5 query cursor per user          
     */
    public ApexPages.StandardSetController con {
        get {
       
      
        System.debug('-------------In get StdController');
            if(con == null) {
             //Build query String to fetch the records
                 /*   queryString='Select ';
                    for(String item:colNameList){
                        queryString+=','+item;
                    }
                    queryString+=' from '+sObjType+' limit '+Limits.getLimitQueryRows();
                    queryString=queryString.replaceFirst(',','');
                    System.debug('--------Query String------'+queryString);
                   */ 
                con = new ApexPages.StandardSetController(Database.Query(queryString));
                // sets the number of records in each page set
                if(pagesize==null||pagesize==0){
                   setPageSize(10);
                }
                con.setPageSize(pagesize);
            }
            return con;
        }
        set;
    }
    
   
   
 
    // indicates whether there are more records after the current page set.
    
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }
 
    // indicates whether there are more records before the current page set.
    
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }
 
    // returns the page number of the current page set
    
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }
 
    // returns the first page of records    
     public void first() {
         con.first();
     }
 
     // returns the last page of records
     public void last() {
         con.last();
     }
 
     // returns the previous page of records     
     public void previous() {
         con.previous();
     }
 
     // returns the next page of records     
     public void next() {
         con.next();
     }
 
     // returns the PageReference of the original page, if known, or the home page.     
     public void cancel() {
         con.cancel();
     }     
     
     public void setPageNumber(Integer pageNum){
         con.setPageNumber(pageNum);
     }
     public pageReference changePageNum(){
          String val=Apexpages.currentPage().getParameters().get('pageNum').trim();
          Integer pageNum=Integer.valueOf(val);          
          setpageNumber(pageNum);
          return null;
         
     }
}