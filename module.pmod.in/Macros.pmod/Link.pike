import Public.Web.Wiki;

inherit .Macro;

string describe()
{
   return "Handles external links";
}

array evaluate(.MacroParameters params)
{
	array res = ({});
	
  if(!sizeof(params->parameters)) 
  {  
   	return ({"INVALID LINK"});
  }

  string link, name;
  int f = search(params->parameters, "|");

  if(f > 0)
  {
    name = params->parameters[0..f-1];
    link = params->parameters[(f+1)..];
  }
  else if(f==0)
  {
    name=link=params->parameters[1..];
  }
  else 
  {
    name=link=params->parameters;
  }

  res+=({"<a href=\"", link, "\">", name, "</a>"});

	return res;
}
