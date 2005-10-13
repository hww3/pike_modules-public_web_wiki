import Public.Web.Wiki;

inherit .Macro;

string describe()
{
   return "Format code in an attractive manner.";
}

void evaluate(String.Buffer buf, array input, RenderEngine engine, mixed|void extras)
{
  
  if(!extras)
  {
    buf->add("INVALID MACRO ENVIRONMENT ");	 
  }

  else
  {
	 if(extras->incode)
	 {
	    m_delete(extras, "incode");
	   buf->add("</pre></div>\n");
   }
    else
    {
      buf->add("<div class=\"code\"><pre>");
      extras->incode = 1;
    }
  }

}
