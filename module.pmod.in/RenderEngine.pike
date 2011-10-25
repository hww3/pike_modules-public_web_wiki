
array (.Rules.Filter) filter_rules = ({});
mapping (string:.Macros.Macro) macros = ([]);

// break and escape are two special filters that should
// be run first, in that order.
.Rules.Filter break_rule;
.Rules.Filter escape_rule;

.Rules.Macro macro_rule;

array priorities = ({});
mapping f_r = ([]);
mapping m_r = ([]);
mapping md_r = ([]);

string render(string i, mixed|void extras, int|void force)
{
mixed ex = compile(i, extras);
  return output(ex, extras);	
}

array compile(string i, mixed|void extras)
{
  if(!extras)
    extras = (["foo":123]);


  array input = ({i});
  array output =input;
  
  input = break_rule->filter(input, this, extras);
  input = escape_rule->filter(input, this, extras);

  input = macro_rule->full_replace(input, macros, this, extras);  

  foreach(filter_rules; int i; .Rules.Filter rule)
   {
	  int last_was_string = 0;
		string running = "";
		array x = ({});
		foreach(input; int z; mixed val)
		{
		  if(val && stringp(val))
		  {
		    running += val;
		    last_was_string = 1;
		  }
		  else if(last_was_string && !stringp(val))
		  {
			last_was_string = 0;
			 x += rule->filter(({running}), this, extras);
				running = "";
				x += ({val});
			}
			else if(val)
 			  x += ({val});
		}
		if(strlen(running))
		{
  	          x += rule->filter(({running}), this, extras);
		}
		input = x;
   }

  // ok, by this point, we should have an array containing chunks of text, or
  // renderer objects.
  return input;
}

string output(array input, mixed|void extras)
{
  String.Buffer buf = String.Buffer();

  foreach(input;; mixed item)
  {
    if(arrayp(item))
	buf->add(output(item, extras));
    else if(stringp(item))
      buf->add(item);
  else if(objectp(item))
	buf->add(output(item->render(this, extras), extras));
    else buf->add("unknown item\n");
  }

  return buf->get();
}

void create(string|void rulefile)
{
  if(!rulefile) rulefile = .RuleFile.default_rules;

  foreach(rulefile/"\n";int lineno;string line)
  {
    string key,value;
    int n;

    if(!sizeof(line) || line[0] =='#' || String.trim_whites(line) == "") continue;

    n = sscanf(line, "%s=%s", key, value);
 
    if(n!=2)
    {
      werror("bogus format at line %d.\n", lineno); 
      continue;
    }

    array k = key/".";

    if(sizeof(k) != 3)
    {
      werror("bogus key at line %d.\n", lineno); 
      continue;
    } 

    switch(k[0])
    {
      case "macros":
        handle_macro_rule(k[1], k[2], value);
        break;

      case "macro":
        handle_macrodef_rule(k[1], k[2], value);
        break;

      case "filter":
        handle_filter_rule(k[1], k[2], value);
        break;

      default:
        werror("invalid key type at line %d.\n", lineno);
        continue;
    }

  }


  /// ok, let's do something with the parsed rules.

  load_filter_rules(f_r);
  load_macro_rule(m_r);
  load_macrodef_rule(md_r);
  f_r=0;
  m_r=0;
  md_r=0;
}

void load_macro_rule(mapping m_r)
{
  foreach(m_r; string key; mapping value)
  {
    if(!(value->match))
      werror("incomplete rule definition for %s.\n", key);

    object r = .Rules.Macro(value->match);
    macro_rule = r;

  }
}

void load_macrodef_rule(mapping md_r)
{
  foreach(md_r; string key; mapping value)
  {
    if(!(value->class))
      werror("incomplete rule definition for %s.\n", key);

    program r = load_class(value->class);

    if(!r)
    {
      werror("class " + value->class + " not found.\n");
      continue;
    }

   //werror("loading macro: %s\n", key);
    add_macro(key, r());
  }
}

void add_macro(string name, object code)
{
  macros[name] = code;
}

void load_filter_rules(mapping f_r)
{
  foreach(f_r; string key; mapping value)
  {
    if(!(value->class && value->match))
      werror("incomplete rule definition for %s.\n", key);
   
   // werror("loading filter %s: %O\n", key, value);

    object r = .Rules.Filter(value->match, value->class, value);

    if(key=="escape")
    {
      escape_rule = r;
      continue;
    }

    if(key=="break")
    {
      break_rule = r;
      continue;
    }
    filter_rules+=({r});
    priorities += ({ r->filter_prog->priority()});
  }
  
  sort(priorities, filter_rules);

  //werror("%O\n", filter_rules);
}


void handle_macrodef_rule(string a, string b, string c)
{
  if(b!="class")
  {
    werror("invalid rule %s for macro.%s\n", b, a);
    return; 
  }

  if(!md_r[a])
    md_r[a] = ([]);

  md_r[a][b] = c;
}

void handle_filter_rule(string a, string b, string c)
{

  if(!f_r[a])
    f_r[a] = ([]);

  f_r[a][b] = c;
}

void handle_macro_rule(string a, string b, string c)
{
  if(a!="format" && b!="match")
  {
    werror("invalid rule %s for macro.%s\n", b, a);
    return; 
  }

  if(!m_r[a])
    m_r[a] = ([]);

  m_r[a][b] = c;
}

//! you should impliment this method in your own RenderEngine.
public int(0..1) exists(string name)
{
  return 1;
}

//! you should impliment this method in your own RenderEngine.
public int(0..1) showCreate()
{
  return 1;
}

//! you should impliment this method in your own RenderEngine.
public void appendLink(String.Buffer buf, string name, string view, string|void anchor)
{
  if(anchor)
    buf->add(sprintf("link: %s %s %s", name, view, anchor));
  else
    buf->add(sprintf("link: %s %s", name, view));
}

//! you should impliment this method in your own RenderEngine.
public void appendCreateLink(String.Buffer buf, string name, string view)
{
    buf->add(sprintf("create link: %s %s", name, view));
}


program load_class(string cls)
{
  program p;
  p = master()->resolv(cls);

  if(!p)
    p = (program)cls;

  return p;
}
