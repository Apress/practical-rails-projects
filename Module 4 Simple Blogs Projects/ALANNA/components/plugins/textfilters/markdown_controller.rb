class Plugins::Textfilters::MarkdownController < TextFilterPlugin::Markup
  plugin_display_name "Markdown"
  plugin_description 'Markdown markup language from <a href="http://daringfireball.com/">Daring Fireball</a>'

  def self.help_text
    %{
[Markdown](http://daringfireball.net/projects/markdown/) is a simple text-to-HTML converter that
turns common text idioms into HTML.  The [full syntax](http://daringfireball.net/projects/markdown/syntax)
is available from the author's site, but here's a short summary:

* **Paragraphs**: Start a new paragraph by skipping a line.
* **Italics**: Put text in *italics* by enclosing it in either \* or \_: `*italics*` turns into *italics*.
* **Bold**: Put text in **bold** by enclosing it in two \*s: `**bold**` turns into **bold**.
* **Pre-formatted text**: Enclosing a short block of text in backquotes (&#96;) displays it in a monospaced font
  and converts HTML metacharacters so they display correctly.  Example: &#96;`<img src="foo"/>`&#96; displays as `<img src="foo"/>`.
  Also, any paragraph indented 4 or more spaces is treated as pre-formatted text.
* **Block quotes**: Any paragraph (or line) that starts with a `>` is treated as a blockquote.
* **Hyperlinks**: You can create links like this: `[amazon's web site](http://www.amazon.com)`.  That produces
  "[amazon's web site](http://www.amazon.com)".
* **Lists**: You can create numbered or bulleted lists by ending a paragraph with a colon (:), skipping a line, and then using
  asterisks (*, for bullets) or numbers (for numbered lists).  See the
  [Markdown syntax page](http://daringfireball.net/projects/markdown/syntax) for examples.
* **Raw HTML**: Markdown will pass raw HTML through unchanged, so you can use HTML's syntax whenever Markdown doesn't provide
  a reasonable alternative.

    }
  end

  def self.filtertext(controller,content,text,params)
    BlueCloth.new(text.gsub(%r{</?notextile>}, '')).to_html
  end
end
