
class BaseRule{

  constant type = "BaseRule";
  static object regexp;
  static function split_fun;
  int max_iterations = 10;

  string _sprintf(mixed ... args)
  {
     return sprintf("%s(%s)", type, regexp->pattern);
  }

  void create(string match) {
    regexp = _Regexp_PCRE(match, Regexp.PCRE.OPTION.MULTILINE);
    split_fun = regexp->split;
  }

   array replace(string subject,string|function with, mixed|void ... args)
   {
      int i=0;
		array res = ({});
		
      for (;;)
      {
         array substrings = ({});
         array(int)|int v=regexp->exec(subject,i);

         if (intp(v) && !regexp->handle_exec_error([int]v)) break;

         if (v[0]>i) res+=({subject[i..v[0]-1]});

         if(sizeof(v)>2)
         {
           int c = 2;
           do
           {
             substrings += ({ subject[v[c]..(v[c+1]-1)] });
             c+=2;
           }
           while(c<= (sizeof(v)-2));
         }

         if (stringp(with)) res+=({with});
           else { array o = with(subject[v[0]..v[1]-1], substrings, @args); res+=o; }
 
         i=v[1];
      }

      res+=({subject[i..]});

		return res;

   }

}

class Filter {
   inherit BaseRule;
   constant type = "FilterRule";
   string classname;
   object filter_prog;

   string _sprintf(mixed...args)
   {  
      return "Filter(" + classname + ")";
   }

   void create(string match, string cls, mapping extras)
   {
      ::create(match);
      classname = cls;
      filter_prog = master()->resolv(cls)(extras);
   }

   array filter(array input, .RenderEngine engine, mixed|void context)
   {
		array res = ({});
		foreach(input;; mixed item)
		  	if(stringp(item))
        		res += replace(item, filter_processor, engine, context);
 			else res += ({item});
		return res;
   }

	array filter_processor(string a, mixed|void b, object engine, mixed|void context)
	{
	   if(b){
			object r = ReplacerObject(filter_prog->filter);
			r->set(a, b);
			if(filter_prog->is_cacheable())
			{
			//	werror("cacheable!\n");
			 	return r->render(engine, context);
			}
			else return ({r});
	   }
	  else
		{
			
	 		object r = ReplacerObject(filter_prog->filter);
			r->set(a, ({}));
			if(filter_prog->is_cacheable())
			{
			//	werror("cacheable!\n");
				return r->render(engine, context);
			}
			else return ({r});
		}
	}
	
	class ReplacerObject(function with)
	{
		string match;
		array substrings;
		int cacheable;
		
		void set(string _match, array _substrings)
		{
			match = _match;
			substrings = _substrings;
		}
		
		array render(object engine, mixed extras)
		{
			return with(match, substrings, engine, extras);
		}
		
		string _sprintf(mixed t)
		{
			return "Replacer(" + match + ")";
		}
	}

}

class Macro {
   inherit BaseRule;
 //  program replacer_class = MacroReplacerObject;

   void create(string match)
   {
     ::create(match);
   }

   array full_replace(array input, mapping macros, 
                                           .RenderEngine engine, mixed|void extras)
   {

      array a = ({});

		foreach(input;; mixed item)
		{ 
			// no sense in trying to replace something that's a render object.
			if(objectp(item))
				a += ({item});
			else
			{
				a+=replace(item, macro_processor, macros, engine, extras);
				
			}
		}

		return a;
	}


	
					array macro_processor(string a, mixed|void b, mapping macros, object engine, mixed|void extras)
					{
						array res = ({});

                 	if(b)
						{
       					if(!macros[b[0]])
		               {
		      				res+=({a});
		                          }
		               else
		       			{
		//                              werror("calling macro %s: %O\n", b[0], b);
									if(macros[b[0]]->is_cacheable())
													res += MacroReplacerObject(macros[b[0]]->evaluate, b)->render(engine, extras);
								else
		                  	res += ({MacroReplacerObject(macros[b[0]]->evaluate, b)});

		                           }
		                       	}
		            else
		              res+=({a});
						return res;
		         }

						class MacroReplacerObject(function with, array b)
						{
							string match;
							array substrings;
							int cacheable;

							array render(object engine, mixed extras)
							{

									                   .Macros.MacroParameters p = .Macros.MacroParameters(); 
							                      	p->engine = engine;
									                              p->extras = extras;
									                              p->name = b[0];
									                              p->parameters = b[1];
												      if(sizeof(b)>2)
									                                p->contents = b[2];
								return with(p);
							}

							string _sprintf(mixed t)
							{
								return "Replacer(" + b[0] + ")";
							}
						}


}


