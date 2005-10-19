import Public.Web.Wiki;

inherit .Macro;

string describe()
{
   return "Format code in an attractive manner.";
}

void evaluate(String.Buffer buf, .MacroParameters params)
{
   buf->add("<div class=\"code\"><pre>");
   werror("code: |%O|", params->parameters);
   if(sizeof(params->parameters)>2)
     buf->add(replace(params->parameters[2], ({"&", "<", ">", "[", "\\"}), ({"&amp;", "&lt;", "&gt;", "&#91;", "&#92;"})));
	buf->add("</pre></div>\n");  
}
