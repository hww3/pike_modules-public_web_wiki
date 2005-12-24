  import Public.Web.Wiki;
  inherit .RegexFilter;

 // we want top priority, to escape anything nasty.
  public int priority()
  {
     return 10;
  }
