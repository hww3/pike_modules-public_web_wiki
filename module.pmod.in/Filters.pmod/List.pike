  inherit .Filter;
  import Public.Web.Wiki;


  private constant openList = ([
    '-': "<ul class=\"minus\">",
    '*': "<ul class=\"star\">",
    '#': "<ol>",
    'i': "<ol class=\"roman\">",
    'I': "<ol class=\"ROMAN\">",
    'a': "<ol class=\"alpha\">",
    'A': "<ol class=\"ALPHA\">",
    'g': "<ol class=\"greek\">",
    'h': "<ol class=\"hiragana\">",
    'H': "<ol class=\"HIRAGANA\">",
    'k': "<ol class=\"katakana\">",
    'K': "<ol class=\"KATAKANA\">",
    'j': "<ol class=\"HEBREW\">",
    '1': "<ol>"
   ]);

  private constant closeList = ([
    '-': "</ul>",
    '*': "</ul>",
    '#': "</ol>",
    'i': "</ol>",
    'I': "</ol>",
    'a': "</ol>",
    'A': "</ol>",
    'g': "</ol>",
    'h': "</ol>",
    'H': "</ol>",
    'k': "</ol>",
    'K': "</ol>",
    'j': "</ol>",
    '1': "</ol>"
  ]);

  public array filter(string match, array|void components, mixed|void extra)
  {
     return addlist(match);

  }


  private array addlist(string match)
  {
    string lastBullet = "";
    string line;
    array res = ({});
    object buf = String.Buffer();

    match = replace(match, "\r\n", "\n");

    foreach(match/"\n";;line)
    {
      if(!line) continue;
      line = String.trim_whites(line);
      if(!sizeof(line))
        continue;

      int bulletend = search(line, " ");

      if(bulletend < 1)
        continue;
      if(line[bulletend-1]=='.')
        bulletend--;

      string bullet = line[0..bulletend-1];

      int sharedPrefixEnd;
      for(sharedPrefixEnd = 0;; sharedPrefixEnd++)
      {
        if((sizeof(bullet) <= sharedPrefixEnd) || 
          sizeof(lastBullet) <= sharedPrefixEnd ||
          bullet[sharedPrefixEnd] != lastBullet[sharedPrefixEnd])
          break;
      }

      for(int i = sharedPrefixEnd; i< sizeof(lastBullet); i++)
      {
        if(closeList[lastBullet[i]])
          buf->add(closeList[lastBullet[i]]);
        buf->add("\n");
      }

      for(int i = sharedPrefixEnd; i< sizeof(bullet); i++)
      {
	if((openList[bullet[i]])
          buf->add(openList[bullet[i]]);
        buf->add("\n");
      }

      buf->add("<li>");
      buf->add(line[search(line, " ")+1..] || "");
      buf->add("</li>\n");
      lastBullet = bullet;
    }

    for(int i = (sizeof(lastBullet)-1); i>=0; i--)
    {
      buf->add(closeList[lastBullet[i]]);
    }

	res += ({ buf->get()});
	return res;

  }
