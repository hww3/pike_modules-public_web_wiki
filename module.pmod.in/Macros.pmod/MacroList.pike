import Public.Web.Wiki;

inherit .Macro;

string describe()
{
   return "Lists all Macros";
}
void evaluate(String.Buffer buf, .MacroParameters params)
{
  
  foreach(params->engine->macros; string name; Macros.Macro macro)
  {
     buf->add("<p>\nname: ");
     buf->add(name);
     buf->add("<br>\ndescription: ");
     buf->add(macro->describe());
  }
}
