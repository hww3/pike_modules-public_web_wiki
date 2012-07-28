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

    string path, view, anchor;
    array c;

    c = components[0]/"|";

    if(sizeof(c) > 2)
    {
      error("invalid link format. too many pipes!\n");
    }

    path = c[0];
   
    if(sizeof(c) == 2)
      view = c[1];

    c = path / "#";
    
    if(sizeof(c) > 2) 
      error("invalid link format. too many anchors!\n");
    else if(sizeof(c) ==2)
      anchor = c[1];

    path = c[0];

    if(!view)
      view = (path/linkspec)[-1];    

    object buf = String.Buffer();

    if(engine->exists(path))
    {
       if(anchor)
         engine->appendLink(buf, path, view, anchor);
       else
         engine->appendLink(buf, path, view);
    }
    else
    {
      if(engine->showCreate())
      {
        engine->appendCreateLink(buf, path, view);
      }
      else
      {
        return({match});
      }
    }
	return ({buf->get()});
  }

