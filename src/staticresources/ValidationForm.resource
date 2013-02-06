function isDigit(str)
{
       var len=str.length;
       for(var i=0;i<len;i++)
       {
              var num=str.charAt(i);
              if(num>="a" && num<="z" || num>="A" && num<="Z" || num==" ")
                   continue;
              else 
                   return 1;    
        }     
} 
function isAlpha(str)
{
               
     var len=str.length;
     for(var i=0;i<len;i++)
     {
            var num=str.charAt(i);
            if(num>="a" && num<="z" || num>="A" && num<="Z" || num==" " || num>="0" && num<="9" || num==",")
                   continue;
            else 
                   return 1;    
      }       
} 
function isChar(str)
{
               
     var len=str.length;
     for(var i=0;i<len;i++)
     {
         var num=str.charAt(i);
         if(num>="0" && num<="9")
             continue;
         else 
             return 1;    
      }       
}