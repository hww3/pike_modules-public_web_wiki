import Public.Web.Wiki;

inherit .Macro;

int has_content = 1;

string describe()
{
   return "Makes links to API references, supports pike, php and perl.";
}

array evaluate(.MacroParameters params)
{
  if(!sizeof(params->parameters)) 
  {  
    return ({"INVALID API"});
  }

  string symbol, lang;
  int f = search(params->parameters, "|");

  if(!params->args) params->make_args();

  lang = "pike";

  if(params->args->lang) lang = params->args->lang;

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
      return ({"INVALID API LANGUAGE " + lang});

  }

  symbol = params->contents;

  return ({"<a href=\"", link, "\">", symbol, "</a>"});
}
