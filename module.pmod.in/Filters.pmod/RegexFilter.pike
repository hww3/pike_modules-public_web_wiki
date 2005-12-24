  import Public.Web.Wiki;
  inherit .Filter;

  string dest;

  public array filter(string match, array|void components, RenderEngine engine, mixed|void context)
  {
		array res = ({});
		
     if(!dest)
       dest = predef::replace(extra->print, "\\n", "\n");

       if(components){
			array replacements = ({"$0"});
         for(int i=1; i<=sizeof(components); i++)
            replacements+=({"$"+i});
         res += ({predef::replace(dest ,replacements, ({match})+components)});
      }
      else
         res += ({dest});
      return res;
  }
