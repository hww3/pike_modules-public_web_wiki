//! parameters for a macro.
import Public.Web.Wiki;

RenderEngine engine;
mapping extras;
string name;
string parameters;
string contents;
array positions;
mapping args;

void make_args()
{
  args = ([]);
  positions = ({});

  if(!parameters) return;

  foreach(parameters / "|";int i; string e)
  {
    int l;
    int s = 0;
    do
    {
      l = search(e, "=", s);
      if(l == -1)
      {
        args[e] = "1"; // a simple argument with no value.
        positions += ({e});
        continue;
      }
      if(e[l-1] == '\\') // ah, we're trying to escape!
      {
        // this algorithm is not good enough, as we can't escape a backslash.
        s = l+1;
        continue;
      }
      else 
      {
         string key = e[0..l-1];
         key = replace(key, "\\=", "=");
         string value = e[l+1..];
         key = String.trim_all_whites(key);
         args[key] = String.trim_all_whites(value);
         positions += ({key});
         l=-1;
      }
    } while (l!=-1);
  }
}
