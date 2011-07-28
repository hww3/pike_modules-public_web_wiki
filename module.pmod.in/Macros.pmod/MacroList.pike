import Public.Web.Wiki;

inherit .Macro;

string describe()
{
   return "Lists all Macros";
}
array evaluate(.MacroParameters params)
{
  array res = ({});
  foreach(params->engine->macros; string name; Macros.Macro macro)
  {
     res += ({("<p>\nname: "), name, "<br>\ndescription: ", macro->describe()});
  }
  return res;
}


int is_cacheable()
{
	return 0;
}

