  inherit .Filter;
  import Public.Web.Wiki;

  public void filter(String.Buffer buf, string match, array|void components, mixed|void extra)
  {
     werror("Escape Filter:%O / %O\n", match, components);
     if(sizeof(components))
     {
        if(strlen(components[0]))
        {
           buf->add("&#92;&#92;");
        }
        else if(strlen(components[1]))
        {
           buf->add(encode(components[1]));
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
