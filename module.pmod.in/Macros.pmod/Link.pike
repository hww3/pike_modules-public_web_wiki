import Public.Web.Wiki;

inherit .Macro;

string describe()
{
   return "Handles external links";
}

void evaluate(String.Buffer buf, array input, RenderEngine engine, mixed|void extras)
{
  if(sizeof(input) !=2) 
  {  
    buf->add("INVALID LINK");
    return;
  }

  string link, name;
  int f = search(input[1], "|");

  if(f > 0)
  {
    name = input[1][0..f-1];
    link = input[1][(f+1)..];
  }
  else if(f==0)
  {
    name=link=input[1][1..];
  }
  else 
  {
    name=link=input[1];
  }

  buf->add("<a href=\"");
  buf->add(link);
  buf->add("\">");
  buf->add(name);
  buf->add("</a>");
}
