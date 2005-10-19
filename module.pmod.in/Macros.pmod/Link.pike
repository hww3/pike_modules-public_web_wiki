import Public.Web.Wiki;

inherit .Macro;

string describe()
{
   return "Handles external links";
}

void evaluate(String.Buffer buf, .MacroParameters params)
{
  if(sizeof(params->parameters) !=2) 
  {  
    buf->add("INVALID LINK");
    return;
  }

  string link, name;
  int f = search(params->parameters[1], "|");

  if(f > 0)
  {
    name = params->parameters[1][0..f-1];
    link = params->parameters[1][(f+1)..];
  }
  else if(f==0)
  {
    name=link=params->parameters[1][1..];
  }
  else 
  {
    name=link=params->parameters[1];
  }

  buf->add("<a href=\"");
  buf->add(link);
  buf->add("\">");
  buf->add(name);
  buf->add("</a>");
}
