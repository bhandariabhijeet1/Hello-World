public class RequirementHomeCon
{
    
    public Module__c moduleInstance{get;set;}
    public Project__c projectInstance{get;set;}
    public RequirementHomeCon()
    {
        
        
        moduleInstance=[select moduleName__c,moduleSpecification__c from Module__c limit 1];
        
        projectInstance=[select projectTitle__c,projectVersion__c,technology__c from Project__c limit 1];
                 
    }

}