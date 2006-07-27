import Public.Web.Wiki;

inherit .Macro;

constant is_container = 1;

string describe()
{
   return "Table Generator";
}

array evaluate(.MacroParameters params)
{
	array res = ({});
  if(params->contents && sizeof(params->contents))
  {
    array lines = String.trim_all_whites(params->contents)/"\n";
    
    if(!sizeof(lines)) return ({});

    res += ({"<table>\n"});

    array row;    

    row=lines[0]/"|";

    res += ({"<tr>\n"});

    foreach(row, string th)
    {
      res += ({"<th>", th, "</th>\n"});
    }

    res += ({"</tr>"});

    
    if(sizeof(lines)>1) 
    {
      foreach(lines[1..], string line)
      {
        row=line/"|";

        res += ({"<tr>\n"});
  
        foreach(row, string td)
        {
          res += ({"<td>", td, "</td>\n"});
        }

        res += ({"</tr>\n"});
      }
    }

    res += ({"</table>\n"});
  }  
  return res;
}
