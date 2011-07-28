  import Public.Web.Wiki;

  static mapping extra;

  static void create(mapping _extras)
  {
    extra = _extras;
  }

  public array filter(string match, array|void components, RenderEngine engine, mixed|void context);

  public int priority()
  {
     return 99;
  }

	int is_cacheable()
	{
		return 1;
	}

