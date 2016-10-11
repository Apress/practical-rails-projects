require 'net/http'
require 'flickr/flickr'

class Plugins::Textfilters::FlickrController < TextFilterPlugin::MacroPost
  plugin_display_name "Flickr"
  plugin_description "Automatically generate image tags for Flickr images"

  def self.help_text
    %{
You can use `<typo:flickr>` to display images from [Flickr](http://flickr.com).  Example:

    <typo:flickr img="31367273" size="small"/>

will produce an `<img>` tag showing image number 31367273 from Flickr.  This image will be linked to
the Flickr page for this image, so you can zoom in and see larger versions.  It will also have a
comment block attached if a description has been attached to the picture in Flickr.

This macro takes a number of parameters:

* **img** The Flickr image ID of the picture that you wish to use.  This shows up in the URL whenever
  you're viewing a picture in Flickr; for example, the image ID for <http://flickr.com/photos/scottlaird/31367273>
  is 31367273.
* **size** The image size that you'd like to display.  Options are:
  * square (75x75)
  * thumbnail (maximum size 100 pixels)
  * small (maximum size 240 pixels)
  * medium (maximum size 500 pixels)
  * large (maximum size 1024 pixels)
  * original
* **style** This is passed through to the enclosing `<div>` that this macro generates.  To float the flickr
  image on the right, use `style="float:right"`.
* **caption** The caption displayed below the image.  By default, this is Flickr's description of the image.
  to disable, use `caption=""`.
* **title** The tooltip title associated with the image.  Defaults to Flickr's image title.
* **alt** The alt text associated with the image.  By default, this is the same as the title.
}
  end

  def self.macrofilter(controller,content,attrib,params,text="")
    img     = attrib['img']
    size    = attrib['size'] || "square"
    style   = attrib['style']
    caption = attrib['caption']
    title   = attrib['title']
    alt     = attrib['alt']

    begin
      flickr      = Flickr.new(FLICKR_KEY)
      flickrimage = Flickr::Photo.new(img)
      sizes       = flickrimage.sizes

      details     = sizes.find {|s| s['label'].downcase == size.downcase } || sizes.first
      width       = details['width']
      height      = details['height']
      imageurl    = details['source']
      imagelink   = flickrimage.url

      caption   ||= sanitize(CGI.unescapeHTML(flickrimage.description)) unless flickrimage.description.blank?
      title     ||= flickrimage.title
      alt       ||= title

      if(caption.blank?)
        captioncode=""
      else
        captioncode = "<p class=\"caption\" style=\"width:#{width}px\">#{caption}</p>"
      end

      "<div style=\"#{style}\" class=\"flickrplugin\"><a href=\"#{imagelink}\"><img src=\"#{imageurl}\" width=\"#{width}\" height=\"#{height}\" alt=\"#{alt}\" title=\"#{title}\"/></a>#{captioncode}</div>"

    rescue Exception => e
      logger.info e
      %{<div class='broken_flickr_link'>`#{img}' could not be displayed because: <br />#{e}</div>}
    end
  end
end
