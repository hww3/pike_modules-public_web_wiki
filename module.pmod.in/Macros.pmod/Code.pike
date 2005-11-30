import Public.Web.Wiki;

inherit .Macro;

string describe()
{
   return "Format code in an attractive manner.";
}

void evaluate(String.Buffer buf, .MacroParameters params)
{
   buf->add("<div class=\"code\"><pre>");
   if(params->contents)
     buf->add(replace(params->contents, ({"&", "<", ">", "[", "\\"}), ({"&amp;", "&lt;", "&gt;", "&#91;", "&#92;"})));
	buf->add("</pre></div>\n");  
}
