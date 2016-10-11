require File.dirname(__FILE__) + '/../test_helper'
require 'textfilter_controller'

require 'flickr_mock'

# Re-raise errors caught by the controller.
class TextfilterController; def rescue_action(e) raise e end; end
class ActionController::Base; def rescue_action(e) raise e end; end

class TextfilterControllerTest < Test::Unit::TestCase
  fixtures :text_filters

  def setup
    @controller = TextfilterController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @controller.request = @request
    @controller.response = @response
    @controller.assigns ||= []
    reset_whiteboard

    get :test_action # set up @url; In Rails 1.0, we can't do url_for without it.

#    @controller.initialize_current_url #rescue nil
  end

  def filter_text(text, filters, filterparams={}, filter_html=false)
    TextFilter.filter_text(text, @controller, self, filters, filterparams, filter_html)
  end

  def whiteboard
    @whiteboard ||= Hash.new
  end

  def reset_whiteboard
    @whiteboard = nil
  end

  def sparklines_available
    begin
      Plugins::Textfilters::SparklineController
    rescue NameError
      false
    end
  end

  def test_unknown
    text = filter_text('*foo*',[:unknowndoesnotexist])
    assert_equal '*foo*', text
  end

  def test_smartypants
    text = filter_text('"foo"',[:smartypants])
    assert_equal '&#8220;foo&#8221;', text
  end

  def test_markdown
    text = filter_text('*foo*', [:markdown])
    assert_equal '<p><em>foo</em></p>', text

    text = filter_text("foo\n\nbar",[:markdown])
    assert_equal "<p>foo</p>\n\n<p>bar</p>", text
  end

  def test_filterchain
    assert_equal '<p><em>&#8220;foo&#8221;</em></p>',
      filter_text('*"foo"*',[:markdown,:smartypants])

    assert_equal '<p><em>&#8220;foo&#8221;</em></p>',
      filter_text('*"foo"*',[:doesntexist1,:markdown,"doesn't exist 2",:smartypants,:nopenotmeeither])

    assert_equal '<p>foo</p>',
      filter_text('<p>foo</p>',[],{},false)

    assert_equal '&lt;p&gt;foo&lt;/p&gt;',
      filter_text('<p>foo</p>',[],{},true)
  end

  def test_amazon
    text = filter_text('<a href="amazon:097669400X" title="Rails">Rails book</a>',
      [:amazon],
      'amazon-associate-id' => 'scottstuff-20')
    assert_equal "<a href=\"http://www.amazon.com/exec/obidos/ASIN/097669400X/scottstuff-20\" title=\"Rails\">Rails book</a>",
      text
    assert_equal %w{097669400X}, whiteboard[:asins]
    reset_whiteboard

    text = filter_text('[Rails book](amazon:097669400X)',
      [:markdown,:amazon],
      'amazon-associate-id' => 'scottstuff-20')
    assert_equal "<p><a href=\"http://www.amazon.com/exec/obidos/ASIN/097669400X/scottstuff-20\">Rails book</a></p>",
      text
    assert_equal %w{097669400X}, whiteboard[:asins]
    reset_whiteboard


    text = filter_text("Foo\n\n[Rails book](amazon:097669400X)",
      [:markdown,:amazon],
      'amazon-associate-id' => 'scottstuff-20')
    assert_equal "<p>Foo</p>\n\n<p><a href=\"http://www.amazon.com/exec/obidos/ASIN/097669400X/scottstuff-20\">Rails book</a></p>",
          text
    assert_equal %w{097669400X}, whiteboard[:asins]
    reset_whiteboard
  end

  def test_flickr
    assert_equal "<div style=\"float:left\" class=\"flickrplugin\"><a href=\"http://www.flickr.com/users/scottlaird/31366117\"><img src=\"http://photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a><p class=\"caption\" style=\"width:75px\">This is Matz, Ruby's creator</p></div>",
      filter_text('<typo:flickr img="31366117" size="Square" style="float:left"/>',
        [:macropre,:macropost],
        {'flickr-user' => 'scott@sigkill.org'})

    # Test default image size
    assert_equal "<div style=\"\" class=\"flickrplugin\"><a href=\"http://www.flickr.com/users/scottlaird/31366117\"><img src=\"http://photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a><p class=\"caption\" style=\"width:75px\">This is Matz, Ruby's creator</p></div>",
      filter_text('<typo:flickr img="31366117"/>',
        [:macropre,:macropost],
        {'flickr-user' => 'scott@sigkill.org'})

    # Test with caption=""
    assert_equal "<div style=\"\" class=\"flickrplugin\"><a href=\"http://www.flickr.com/users/scottlaird/31366117\"><img src=\"http://photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a></div>",
      filter_text('<typo:flickr img="31366117" caption=""/>',
        [:macropre,:macropost],
        {'flickr-user' => 'scott@sigkill.org'})
  end

  def test_broken_flickr_link
    assert_equal %{<div class='broken_flickr_link'>\`notaflickrid\' could not be displayed because: <br />Photo not found</div>},
      filter_text('<typo:flickr img="notaflickrid" />',
        [:macropre, :macropost],
        { 'flickr-user' => 'scott@sigkill.org' })
  end

  def test_sparkline
    return unless sparklines_available

    tag = filter_text('<typo:sparkline foo="bar"/>',[:macropre,:macropost])
    # url_for returns query params in hash order, which isn't stable, so we can't just compare
    # with a static string.  Yuck.
    assert tag =~ %r{^<img  src="http://test.host/plugins/filters/sparkline/plot\?(data=|foo=bar|&)+"/>$}

    assert_equal "<img  title=\"aaa\" src=\"http://test.host/plugins/filters/sparkline/plot?data=\"/>",
      filter_text('<typo:sparkline title="aaa"/>',[:macropre,:macropost])

    assert_equal "<img  style=\"bbb\" src=\"http://test.host/plugins/filters/sparkline/plot?data=\"/>",
      filter_text('<typo:sparkline style="bbb"/>',[:macropre,:macropost])

    tag = filter_text('<typo:sparkline alt="ccc"/>',[:macropre,:macropost])
    assert_tag_in tag, :tag => 'img', :attributes => {
        'alt' => 'ccc',
        'src' => URI.parse('http://test.host/plugins/filters/sparkline/plot?data=')
    }, :children => { :count => 0 }

    tag = filter_text('<typo:sparkline type="smooth" data="1 2 3 4"/>',[:macropre,:macropost])
    assert_tag_in tag, :tag => 'img', :attributes => {
        'src' => URI.parse('http://test.host/plugins/filters/sparkline/plot?data=1%2C2%2C3%2C4&type=smooth')
    }, :children => { :count => 0 }

    assert_equal "<img  src=\"http://test.host/plugins/filters/sparkline/plot?data=1%2C2%2C3%2C4%2C5%2C6\"/>",
      filter_text('<typo:sparkline>1 2 3 4 5 6</typo:sparkline>',[:macropre,:macropost])
  end

  def test_sparkline_plot
    return unless sparklines_available

    get 'public_action', :filter => 'sparkline', :public_action => 'plot', :data => '1,2,3'
    assert_response :success

    get 'public_action', :filter => 'sparkline', :public_action => 'plot2', :data => '1,2,3'
    assert_response :missing

    get 'public_action', :filter => 'sparkline', :public_action => 'plot', :data => '1,2,3', :type => 'smooth'
    assert_response :success

    get 'public_action', :filter => 'sparkline', :public_action => 'plot', :data => '1,2,3', :type => 'instance_methods'
    assert_response :error
  end

  def test_code
    assert_equal %{<div class="typocode"><pre><code class="typocode_default "><notextile>foo-code</notextile></code></pre></div>},
      filter_text('<typo:code>foo-code</typo:code>',[:macropre,:macropost])

    assert_equal %{<div class="typocode"><pre><code class="typocode_ruby "><notextile><span class="ident">foo</span><span class="punct">-</span><span class="ident">code</span></notextile></code></pre></div>},
      filter_text('<typo:code lang="ruby">foo-code</typo:code>',[:macropre,:macropost])

    assert_equal %{<div class="typocode"><pre><code class="typocode_ruby "><notextile><span class="ident">foo</span><span class="punct">-</span><span class="ident">code</span></notextile></code></pre></div> blah blah <div class="typocode"><pre><code class="typocode_xml "><notextile>zzz</notextile></code></pre></div>},
      filter_text('<typo:code lang="ruby">foo-code</typo:code> blah blah <typo:code lang="xml">zzz</typo:code>',[:macropre,:macropost])
  end

  def test_code_multiline
    assert_equal %{\n<div class="typocode"><pre><code class="typocode_ruby "><notextile><span class="keyword">class </span><span class="class">Foo</span>\n  <span class="keyword">def </span><span class="method">bar</span>\n    <span class="attribute">@a</span> <span class="punct">=</span> <span class="punct">&quot;</span><span class="string">zzz</span><span class="punct">&quot;</span>\n  <span class="keyword">end</span>\n<span class="keyword">end</span></notextile></code></pre></div>\n},
      filter_text(%{
<typo:code lang="ruby">
class Foo
  def bar
    @a = "zzz"
  end
end
</typo:code>
},[:macropre,:macropost])
  end

  def test_named_filter
    assert_equal '<p><em>&#8220;foo&#8221;</em></p>',
      TextFilter.filter_text_by_name('*"foo"*', @controller, 'markdown smartypants')
  end

  def test_code_plus_markup_chain
    text = <<-EOF
*header text here*

<typo:code lang="ruby">
class test
  def method
    "foo"
  end
end
</typo:code>

_footer text here_

EOF

    expects_markdown = <<-EOF
<p><em>header text here</em></p>

<div class="typocode"><pre><code class="typocode_ruby "><span class="keyword">class </span><span class="class">test</span>
  <span class="keyword">def </span><span class="method">method</span>
    <span class="punct">&quot;</span><span class="string">foo</span><span class="punct">&quot;</span>
  <span class="keyword">end</span>
<span class="keyword">end</span></code></pre></div>

<p><em>footer text here</em></p>
EOF

    expects_textile = <<-EOF
<p><strong>header text here</strong></p>


<div class="typocode"><pre><code class="typocode_ruby "><span class="keyword">class </span><span class="class">test</span>
  <span class="keyword">def </span><span class="method">method</span>
    <span class="punct">&quot;</span><span class="string">foo</span><span class="punct">&quot;</span>
  <span class="keyword">end</span>
<span class="keyword">end</span></code></pre></div>

\t<p><em>footer text here</em></p>
EOF

    assert_equal expects_markdown.strip, TextFilter.filter_text_by_name(text, @controller, 'markdown')
    assert_equal expects_textile.strip, TextFilter.filter_text_by_name(text, @controller, 'textile')
  end

  def test_lightbox
    assert_equal "<div style=\"float:left\" class=\"lightboxplugin\"><a href=\"http://photos23.flickr.com/31366117_b1a791d68e_b.jpg\" rel=\"lightbox\" title=\"Matz\"><img src=\"http://photos23.flickr.com/31366117_b1a791d68e_t.jpg\" width=\"67\" height=\"100\" alt=\"Matz\" title=\"Matz\"/></a><p class=\"caption\" style=\"width:67px\">This is Matz, Ruby's creator</p></div>",
      filter_text('<typo:lightbox img="31366117" thumbsize="Thumbnail" displaysize="Large" style="float:left"/>',
        [:macropre,:macropost],
        {})

#     Test default thumb image size
    assert_equal "<div style=\"\" class=\"lightboxplugin\"><a href=\"http://photos23.flickr.com/31366117_b1a791d68e_b.jpg\" rel=\"lightbox\" title=\"Matz\"><img src=\"http://photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a><p class=\"caption\" style=\"width:75px\">This is Matz, Ruby's creator</p></div>",
      filter_text('<typo:lightbox img="31366117" displaysize="Large"/>',
        [:macropre,:macropost],
        {})

#     Test default display image size
    assert_equal "<div style=\"\" class=\"lightboxplugin\"><a href=\"http://photos23.flickr.com/31366117_b1a791d68e_o.jpg\" rel=\"lightbox\" title=\"Matz\"><img src=\"http://photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a><p class=\"caption\" style=\"width:75px\">This is Matz, Ruby's creator</p></div>",
      filter_text('<typo:lightbox img="31366117"/>',
        [:macropre,:macropost],
        {})

#     Test with caption=""
    assert_equal "<div style=\"\" class=\"lightboxplugin\"><a href=\"http://photos23.flickr.com/31366117_b1a791d68e_o.jpg\" rel=\"lightbox\" title=\"Matz\"><img src=\"http://photos23.flickr.com/31366117_b1a791d68e_s.jpg\" width=\"75\" height=\"75\" alt=\"Matz\" title=\"Matz\"/></a></div>",
      filter_text('<typo:lightbox img="31366117" caption=""/>',
        [:macropre,:macropost],
        {})
  end
end
