
class BaseRule{

  static object regexp;
  static function split_fun;
  int max_iterations = 10;

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
   string classname;
   program filter_prog;

   void create(string match, string cls)
   {
      ::create(match);
      filter_prog = master()->resolv(cls);
   }

   void filter(String.Buffer buf, string input, .RenderEngine engine, mixed|void extra)
   {
werror("Rule.Filter.filter()\n");
      replace(buf, input, lambda(String.Buffer buf, string a, mixed|void b){
                     if(b){
                         filter_prog(engine)->filter(buf, a, b, extra);
                        }
                        else
                          filter_prog(engine)->filter(buf, a, ({}), extra);
                    }
                  );

   }
}

class Regex {
   inherit BaseRule;
   static string dest;

   void create(string match, string to)
   {
     ::create(match);
     dest = predef::replace(to, "\\n", "\n");
   }

   void full_replace(String.Buffer buf, string input)
   {
      replace(buf, input, lambda(String.Buffer buf, string a, mixed b){
                     if(b){
			array replacements = ({"$0"});
                        for(int i=1; i<=sizeof(b); i++)
                           replacements+=({"$"+i});
                         buf->add(predef::replace(dest ,replacements, ({a})+b));
                        }
                        else
                          buf->add(dest);
                    }
                  );
   }



}


class Macro {
   inherit BaseRule;
   static string dest;

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
                            buf->add(a);
                          else
                          {
                            macros[b[0]]->evaluate(buf, b, engine, extras);
                          }
                        }
                        else
                          buf->add(a);
                    }
                  );
   }



}


