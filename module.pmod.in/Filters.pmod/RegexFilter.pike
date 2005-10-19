  import Public.Web.Wiki;
  inherit .Filter;

  string dest;

  public void filter(String.Buffer buf, string match, array|void components, RenderEngine engine, mixed|void context)
  {
     if(!dest)
       dest = predef::replace(extra->print, "\\n", "\n");

       if(components){
			array replacements = ({"$0"});
         for(int i=1; i<=sizeof(components); i++)
            replacements+=({"$"+i});
         buf->add(predef::replace(dest ,replacements, ({match})+components));
      }
      else
         buf->add(dest);
         
  }
