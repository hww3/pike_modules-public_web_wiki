  inherit .Filter;
  import Public.Web.Wiki;

  public array filter(string match, array|void components, RenderEngine engine, mixed|void extra)
  {
	 array res = ({});
    string linkspec = "/";

    if(extra && extra->linkspec)
    {
       linkspec = extra->linkspec;
    }

    string name, view, anchor;

    array c = components[0] / "#";
    
    if(sizeof(c) > 2) 
      error("invalid link format. too many anchors!\n");
    else if(sizeof(c) ==2)
      anchor = c[1];

    name = c[0];

    view = (name/linkspec)[-1];    

	 object buf = String.Buffer();

    if(engine->exists(name))
    {
       if(anchor)
         engine->appendLink(buf, name, view, anchor);
       else
         engine->appendLink(buf, name, view);
    }
    else
    {
      if(engine->showCreate())
      {
        engine->appendCreateLink(buf, name, view);
      }
      else
      {
        return({match});
      }
    }
	return ({buf->get()});
  }

