  import Public.Web.Wiki;

  static RenderEngine engine;

  static void create(RenderEngine e)
  {
    engine = e;
  }

  public void filter(String.Buffer buf, string match, array|void components, mixed|void extra);

