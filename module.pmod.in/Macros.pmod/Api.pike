import Public.Web.Wiki;

inherit .Macro;

string describe()
{
   return "Makes links to API references, supports pike, php and perl.";
}

void evaluate(String.Buffer buf, .MacroParameters params)
{
  if(!sizeof(params->parameters)) 
  {  
    buf->add("INVALID API");
    return;
  }

  string symbol, lang;
  int f = search(params->parameters, "|");

  if(f > 0)
  {
    lang = params->parameters[0..f-1];
    if(!sscanf(lang, "lang=%s", lang));
    {
      buf->add("INVALID API LANGUAGE " + lang);
      return;
    }
    symbol = params->parameters[(f+1)..];
  }
  else if(f==0)
  {
    lang="pike";
    symbol=params->parameters[1..];
  }
  else 
  {
    lang="pike";
    symbol=params->parameters;
  }

  string link = "";

  switch(lang)
  {
    case "pike":
      link = "http://pike.ida.liu.se/doc/" + symbol;
      break;

    case "php":
      link = "http://php.net/search.php?show=quickref&pattern=" + symbol;

    case "perl":
      link = "http://perldoc.perl.org/search.html?q=" + symbol;

    default:
      buf->add("INVALID API LANGUAGE " + lang);
      return;


  }

  buf->add("<a href=\"");
  buf->add(link);
  buf->add("\">");
  buf->add(symbol);
  buf->add("</a>");
}
