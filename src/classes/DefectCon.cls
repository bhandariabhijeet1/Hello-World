public class DefectCon
{    
    public Defect__c defectIns{get;set;}    
    public  DefectCon()    
    {        
        defectIns = new Defect__c();     
    }    
    public void addItems()    
    {        
        insert defectIns;    
    }
}