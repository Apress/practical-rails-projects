class Plugins::Textfilters::TextileController < TextFilterPlugin::Markup
  plugin_display_name "Textile"
  plugin_description 'Textile markup language'

  def self.help_text
    %{
      See [_why's Textile reference](http://hobix.com/textile/).
    }
  end
  
  def self.filtertext(controller,content,text,params)
    RedCloth.new(text).to_html(:textile)
  end
end
