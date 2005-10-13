import Public.Web.Wiki;

inherit .Macro;

string describe()
{
   return "Lists all Macros";
}
void evaluate(String.Buffer buf, array input, RenderEngine engine, mixed|void extras)
{
  
  foreach(engine->macros; string name; Macros.Macro macro)
  {
     buf->add("<p>\nname: ");
     buf->add(name);
     buf->add("<br>\ndescription: ");
     buf->add(macro->describe());
  }
}
