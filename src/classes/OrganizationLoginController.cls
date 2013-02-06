public class OrganizationLoginController     {
        public String name{get;set;} //username of  person logged in
        public String pass{get;set;} // password of person logged in
        public String passStyle{get;set;} // style of password text Field
        public String nameStyle{get;set;}// style of username textfield  
        public List <Employee__c> listobj{get;set;}
        public employee__c empObj{get;set;}
        public OrganizationLoginController()  {
             empObj=new Employee__c();
            }
        public String getUserID()            { //returns userid of person logging in
            empObj=[select Name from Employee__c where empEmail__c=:name ];
            return empObj.id;
             } 
        public PageReference login()         {               
            if (name=='')                { // show error if neme is left blank
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Login Id can not be left blank.'));
                nameStyle = 'border-size:2px; border-color:red;border-style:solid;';
                empObj=new Employee__c();
                return null;
                }
             if (pass=='')                {// show error if password is left blank
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Password can not be left blank.'));
                nameStyle='';
                passStyle = 'border-size:2px; border-color:red;border-style:solid;';
                empObj=new Employee__c();
                return null;
                }
             PageReference newPage;
             listobj=[select Name, empDesignation__c from Employee__c where empEmail__c=:name and empPassword__c=:pass ];
             if(listobj.size()>0)          { //means some employee with that username and password exists 
                 newPage=new PageReference('/apex/projectPage?user='+getUserID()+''); 
                 return newPage; // forward user to project page
                  }
             else                 {//show login error 
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You are not a valid user to login'));
                   passStyle = 'border-size:2px; border-color:red;border-style:solid;';
                   nameStyle = 'border-size:2px; border-color:red;border-style:solid;';
                    empObj=new Employee__c();
                    return null;
                 }
        
            
            }
         static testMethod void testOperations()
            {
            OrganizationLoginController obj=new OrganizationLoginController();
            obj.name='';
            obj.pass='something';
            obj.login();
            System.assert(ApexPages.hasMessages());
            obj.name='something';
            obj.pass='';
            obj.login();
            System.assert(ApexPages.hasMessages());
             obj.name='something';
            obj.pass='something';
            obj.login();
            System.assert(ApexPages.hasMessages());
            Employee__c emp=[Select empEmail__c, empPassword__c from Employee__c limit 1];
            obj.name=emp.empEmail__c;
            obj.pass=emp.empPassword__c;
            Pagereference page=obj.login();
            System.assertNotEquals(page,null);
            System.assertNotEquals(obj.getUserID(),null);
            }       
        
    }