import Public.Web.Wiki;

inherit .Macro;

string describe()
{
   return "Lists all Macros";
}
array evaluate(.MacroParameters params)
{

  if(params->engine->macro_recent_changes && functionp(params->engine->macro_recent_changes))
  {
    return({params->engine->macro_recent_changes()});
  }  

	else return ({});

}


int is_cacheable()
{
	return 0;
}