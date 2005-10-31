import Public.Web.Wiki;

inherit .Macro;

string describe()
{
   return "Lists all Macros";
}
void evaluate(String.Buffer buf, .MacroParameters params)
{

  if(params->engine->macro_recent_changes && functionp(params->engine->macro_recent_changes))
  {
    buf->add(params->engine->macro_recent_changes());
  }  

}
