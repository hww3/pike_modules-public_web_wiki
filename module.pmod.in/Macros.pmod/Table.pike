import Public.Web.Wiki;

inherit .Macro;

string describe()
{
   return "Table Generator";
}

void evaluate(String.Buffer buf, .MacroParameters params)
{
  if(sizeof(params->parameters)>2)
  {
    array lines = String.trim_whites(params->parameters[2])/"\n";
    
    if(!sizeof(lines)) return;

    buf->add("<table>\n");

    array row;    

    row=lines[0]/"|";

    buf->add("<tr>\n");

    foreach(row, string th)
    {
      buf->add("<th>");
      buf->add(th);
      buf->add("</th>\n");
    }

    buf->add("</tr>");

    
    if(sizeof(lines)>1) 
    {
      foreach(lines[1..], string line)
      {
        row=line/"|";

        buf->add("<tr>\n");
  
        foreach(row, string td)
        {
          buf->add("<td>");
          buf->add(td);
          buf->add("</td>\n");
        }

        buf->add("</tr>\n");
      }
    }

    buf->add("</table>\n");
  }  

}
