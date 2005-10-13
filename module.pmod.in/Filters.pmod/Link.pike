  inherit .Filter;
  import Public.Web.Wiki;

  public void filter(String.Buffer buf, string match, array|void components, mixed|void extra)
  {
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
        buf->add(match);
      }
    }
  }

