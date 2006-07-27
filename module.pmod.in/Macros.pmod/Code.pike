import Public.Web.Wiki;

inherit .Macro;

int has_content = 1;

string describe()
{
   return "Format code in an attractive manner.";
}

array evaluate(.MacroParameters params)
{
	array res = ({});
   res += ({"<div class=\"code\"><pre>"});
   if(params->contents)
     res += ({replace(params->contents, ({"&", "<", ">", "[", "\\"}), ({"&amp;", "&lt;", "&gt;", "&#91;", "&#92;"}))});
	res += ({"</pre></div>\n"});  

  return res;
}
