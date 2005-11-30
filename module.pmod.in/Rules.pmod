
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

   void replace(String.Buffer buf, string subject,string|function(String.Buffer,string,array|void:string) with)
   {
      int i=0;
      for (;;)
      {
         array substrings = ({});
         array(int)|int v=regexp->exec(subject,i);

         if (intp(v) && !regexp->handle_exec_error([int]v)) break;

         if (v[0]>i) buf->add(subject[i..v[0]-1]);

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

         if (stringp(with)) buf->add(with);
         else with(buf, subject[v[0]..v[1]-1], substrings);

         i=v[1];
      }

      buf->add(subject[i..]);

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

   void filter(String.Buffer buf, string input, .RenderEngine engine, mixed|void context)
   {
      replace(buf, input, lambda(String.Buffer buf, string a, mixed|void b){
                     if(b){
                         filter_prog->filter(buf, a, b, engine, context);
                        }
                        else
                          filter_prog->filter(buf, a, ({}), engine, context);
                    }
                  );

   }
}

class Macro {
   inherit BaseRule;

   void create(string match)
   {
     ::create(match);
   }

   void full_replace(String.Buffer buf, string input, mapping macros, 
                                           .RenderEngine engine, mixed|void extras)
   {
      
      replace(buf, input, lambda(String.Buffer buf, string a, mixed b){
                     if(b){
                          if(!macros[b[0]])
                          {
                            buf->add(a);
                          }
                          else
                           {
//                              werror("calling macro %s: %O\n", b[0], b);
                              .Macros.MacroParameters p = .Macros.MacroParameters();
                              p->engine = engine;
                              p->extras = extras;
                              p->name = b[0];
                              p->parameters = b[1];
			      if(sizeof(b)>2)
                                p->contents = b[2];
  //                            werror("calling macro %O\n", 
//					mkmapping(indices(p), values(p)));
                              macros[b[0]]->evaluate(buf, p);
                                                      
                            }
                        }
                        else
                          buf->add(a);
                    }
                  );
   }



}


