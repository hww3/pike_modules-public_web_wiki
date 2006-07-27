//! the base macro.
import Public.Web.Wiki;

int has_content = 0;

string describe()
{
   return "Base Macro";
}

array evaluate(.MacroParameters params)
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
