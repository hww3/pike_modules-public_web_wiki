//! the base macro.
import Public.Web.Wiki;

string describe()
{
   return "Base Macro";
}

void evaluate(String.Buffer buf, array input, RenderEngine engine, mixed|void extras)
{
  buf->add("macro " + input[0] + " called");
}
