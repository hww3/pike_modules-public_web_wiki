//! the base macro.
import Public.Web.Wiki;

string describe()
{
   return "Base Macro";
}

void evaluate(String.Buffer buf, .MacroParameters params)
{
  buf->add("macro " + params->parameters[0] + " called");
  buf->add(sprintf("params: %O", mkmapping(indices(params), values(params))));
}
