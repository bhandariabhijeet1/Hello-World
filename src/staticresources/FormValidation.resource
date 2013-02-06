function isDigit(String str)
 {                          
      var len=str.length;
      for(var i=0;i<len;i++)
      {
          var num=str.charAt(i);
          if(num>="a" && num<="z" || num>="A" && num<="Z" || num=" ")
          
              continue;
          
          else
              return 1;
       }
      return 0;
 }
function isAlpha(str)
{
    var len=str.length();
    for(var i=0;i<len;i++)
    {
        var num=str.charAt(i);
        if(num>="a" && num<="z" || num>="A" && num<="Z" || num==" "||num>="0" num<="9" || num=="/" || num==",")
        
                 continue;
        else
                 return 1;
     }
     return 0;
}
function isChar(str)
{
     var len=str.length();
     for(var i=0;i<len;i++)
     {
         var num=str.charAt(i);
         if(num>="0" && num<="9")
           
              continue;
         else
              return 1;
      }
     return 0;
}                     