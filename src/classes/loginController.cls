public class loginController
        {
        public String name{get;set;}
        public String pass{get;set;}
        public String passStyle{get;set;}
        public String nameStyle{get;set;}
        public List <Employee__c> listobj{get;set;}
        public employee__c empObj{get;set;}
        public boolean showlogin{get;set;}
        public boolean showWizard{get;set;}
        public loginController()
            {
            empObj=new Employee__c();
            showlogin=true;
            showWizard=false;
            }
        public String getUserID()
            {
            empObj=[select Name from Employee__c where empEmail__c=:name ];
            return empObj.id;
             } 
        public PageReference login()
            {               
            if (name=='')
                {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Login Id can not be left blank.'));
                nameStyle = 'border-size:2px; border-color:red;border-style:solid;';
                empObj=new Employee__c();
                return null;
                }
             if (pass=='')
                {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Password field can not be left blank.'));
                passStyle = 'border-size:2px; border-color:red;border-style:solid;';
                empObj=new Employee__c();
                return null;
                }
             PageReference newPage;
             listobj=[select Name, empDesignation__c from Employee__c where empEmail__c=:name and empPassword__c=:pass ];
             if(listobj.size()>0)
                 {
                 if(listobj[0].empDesignation__c!='Manager')
                     {
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Your designation is not Manager'));
                     empObj=new Employee__c();
                    return null;
                     }
                  showlogin=false;
                 showWizard=true;
                 newPage=Page.createProjectPage;              
                 return newPage;
                  }
             else
                 {
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You are not a valid user to login'));
                   passStyle = 'border-size:2px; border-color:red;border-style:solid;';
                   nameStyle = 'border-size:2px; border-color:red;border-style:solid;';
                    empObj=new Employee__c();
                    return null;
                 }
            }
    }