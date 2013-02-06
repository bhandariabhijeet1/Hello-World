public class ProjectManagerPageState {
    public boolean more{get;set;}
    public boolean less{get;set;}
    public boolean showDetail{get;set;}
    public boolean disableViewModule{get;set;}
    public boolean prevDisabled{get;set;}
    public boolean view {get;set;}
    public boolean nextDisabled{get;set;}
    public String selectedModule{get;set;}
    public boolean showEditPanel {get;set;} 
    public boolean showModuleInfo {get;set;} 
    public boolean showAddModuleForm {get;set;}
    public Integer i{get;set;}   
    public List<Module__c> selectedList{get;set;}//store the module detail to be viewed
    public ProjectManagerPageState()    {
        i=0;
        showDetail=false;
        showAddModuleForm=false;
        more=true;
        less=false;    
        disableViewModule=false;
        showEditPanel=false;
        showModuleInfo=true;
        prevDisabled=true;
        nextDisabled=false;
        }
    public void resetPage()    {
        showDetail=false;
        more=true;
        less=false;    
        disableViewModule=false;
        }
    public void loadAddModuleState()
        {
        showModuleInfo=false;
        showAddModuleForm=true;
        }
     public void showNext()      {
            i++;
            prevDisabled=false;
            if (i==(selectedList.size()-1))
                        nextDisabled=true;
            }
      public PageReference navigateModule()    {
              this.selectedModule=selectedModule;
              for (i=0;i<selectedList.size();i++)   {
                    if(selectedList[i].moduleName__c.equals(selectedModule))
                       break;               
                    }
            if(i==0){
                    prevDisabled=true;
                    nextDisabled=false;
                    }
            else if(i==selectedList.size()-1){
                     prevDisabled=false;
                     nextdisabled=true;   
                     }
            else      {
                     
                      prevDisabled=false;
                      nextDisabled=false;
                     }
            showEditPanel=false;
            showModuleInfo=true;
            return null;
            }
        public void showPrevious()   {
            i--;
            nextDisabled=false;
            if(i==0)
                prevDisabled=true;
             }
    public void showProjectDetail()    {
        if (more)    {
           more=false;
           less=true; 
           showDetail=true;
           }
         else if (less)    {
             less=false;
             more=true;
             showDetail=false;
             }
         }
     
    }