public virtual class ValidationFormPageController{  
    public Boolean isDigit(String str){    
      for(Integer i=0;i<str.length();i++) 
      { 
         string ch=str.substring(i,i+1);  
         if(ch>='a' && ch<='z' || ch>='A' && ch<='Z' || ch==' ')
            continue;  
         else     
            return true; 
      }      
      return false; 
    }
    public Boolean isAlphanumeric(String str){ 
      for(Integer i=0;i<str.length();i++) 
      {                   
          string ch=str.substring(i,i+1);
          if(ch>='a' && ch<='z' || ch>='A' && ch<='Z' || ch==' '|| ch>='0' && ch<='9' || ch=='/' || ch==',')  
             continue;         
          else  
             return true;     
      }    
      return false;           
    }  
    public Boolean isCharacter(string str){     
       for(Integer i=0;i<str.length();i++)       
       {              
            string ch=str.substring(i,i+1);       
            if(ch>='0' && ch<='9')   
               continue;                   
            else                                              
               return true;               
       }               
       return false;        
   }
}