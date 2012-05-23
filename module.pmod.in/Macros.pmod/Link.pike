import Public.Web.Wiki;

inherit .Macro;

string describe()
{
   return "Handles external links";
}

// format
// {link:url|text}
array evaluate(.MacroParameters params)
{
	array res = ({});
	
  if(!sizeof(params->parameters)) 
  {  
   	return ({"INVALID LINK"});
  }

  string link, name;

  if(!params->args) params->make_args();

  array a = indices(params->args);

  name = a[-1];
  if(sizeof(a) > 1)
    link = a[-2];
  else
    link = a[-1];

  res+=({"<a href=\"", link, "\">", name, "</a>"});

	return res;
}
