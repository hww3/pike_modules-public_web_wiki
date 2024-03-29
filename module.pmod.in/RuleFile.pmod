
string default_rules =
#"
filter.escape.match=\\\\(\\\\\\\\)|\\\\(.)
filter.escape.class=Public.Web.Wiki.Filters.Escape
filter.bold.match=(^|>|[[:punct:][:space:]]+)__(.*?)__($|<|[[:punct:][:space:]]+)
filter.bold.print=$1<b class=\"bold\">$2</b>$3
filter.bold.class=Public.Web.Wiki.Filters.Bold
filter.ital.match=(^|>|[[:punct:][:space:]]+)~~(.*?)~~($|<|[[:punct:][:space:]]+)
filter.ital.print=$1<i class=\"ital\">$2</i>$3
filter.ital.class=Public.Web.Wiki.Filters.Ital
filter.line.match=-{5,}
filter.line.print=<hr class=\"line\"/>\n
filter.line.class=Public.Web.Wiki.Filters.Line
filter.break.match=\\\\\\r\\n
filter.break.print=<br class=\"break\"/>\n
filter.break.class=Public.Web.Wiki.Filters.Break
filter.newline.match=\\n{2,}
filter.newline.print=<p/>\\n
filter.newline.class=Public.Web.Wiki.Filters.NewLine
filter.url.match=([[:space:]]|^)((http|ftp)s?://(%[[:digit:]A-Fa-f][[:digit:]A-Fa-f]|[-_.!~*';/?:@#&=+$,[:alnum:]])+)
filter.url.print=$1<span class=\"nobr\"><a href=\"$2\">$2</a></span>
filter.url.class=Public.Web.Wiki.Filters.Url
filter.heading.match=^[[:space:]]*(1(?:\\.1)?)[[:space:]]+(.*?)$
filter.heading.print=<h3 class=\"heading-$1\">$2</h3>
filter.heading.class=Public.Web.Wiki.Filters.Heading
filter.key.match=((Ctrl|Alt|Shift|Cmd|Meta)-[^ ]*)
filter.key.print=<span class=\"key\">$1</span>
filter.key.class=Public.Web.Wiki.Filters.Key
filter.typography.match=([^.]|^)[.][.][.](?!\\\\.)( |$)
filter.typography.print=$1&#8230;$2
filter.typography.class=Public.Web.Wiki.Filters.Typography
filter.paragraph.match=([ \\t\\r]*[\\n]){2}
filter.paragraph.print=<p class=\"paragraph\"/>\n
filter.paragraph.class=Public.Web.Wiki.Filters.Paragraph
filter.list.match=(^[[:space:]]*([-#*]+|[-#*]*[iIaA1ghHkKj]+\\.)[ ]+([^\\r\\n]+)[\\r\\n]*)+
filter.list.class=Public.Web.Wiki.Filters.List
filter.link.match=\\[(.*?)\\]
filter.link.class=Public.Web.Wiki.Filters.Link
macros.format.match={([a-z\-_0-9]+):?(.*?)}(?:((?s).*?){\\1})?
macro.hello.class=Public.Web.Wiki.Macros.Hello
macro.link.class=Public.Web.Wiki.Macros.Link
macro.code.class=Public.Web.Wiki.Macros.Code
macro.boggle.class=Public.Web.Wiki.Macros.Boggle
macro.api.class=Public.Web.Wiki.Macros.Api
macro.macro-list.class=Public.Web.Wiki.Macros.MacroList
macro.recent-changes.class=Public.Web.Wiki.Macros.RecentChanges
macro.table.class=Public.Web.Wiki.Macros.Table
";
