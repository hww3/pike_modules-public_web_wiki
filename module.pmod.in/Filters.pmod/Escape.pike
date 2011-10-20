  inherit .Filter;
  import Public.Web.Wiki;

  public array filter(string match, array|void components, mixed|void extra)
  {
     if(sizeof(components))
     {
        if(strlen(components[0]))
        {
           return({"&#92;&#92;"});
        }
        else if(strlen(components[1]))
        {
           return({encode(components[1])});
        }
     }
  }
  
  // we want top priority, to escape anything nasty.
  public int priority()
  {
     return 1;
  }


  static string encode(string s)
  {
     string s2 = "";

     foreach((array)s;;int c)
     {
        s2+="&#" + c + ";";
     }
     return s2;
  }
