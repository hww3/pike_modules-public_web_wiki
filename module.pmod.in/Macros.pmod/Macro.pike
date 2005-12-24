//! the base macro.
import Public.Web.Wiki;

string describe()
{
   return "Base Macro";
}

array evaluate(String.Buffer buf, .MacroParameters params)
{
  array res = ({});

  res += ({ ("macro " + params->name + " called"),
    sprintf("params: %O", mkmapping(indices(params), values(params)))
  });
  return res;
}

int is_cacheable()
{
	return 1;
}