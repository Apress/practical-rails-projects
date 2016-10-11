require File.dirname(__FILE__) + '/../test_helper'
require 'xml_controller'
require 'dns_mock'

# This test now has optional support for validating the generated RSS feeds.
# Since Ruby doesn't have a RSS/Atom validator, I'm using the Python source
# for http://feedvalidator.org and calling it via 'system'.
#
# To install the validator, download the source from
# http://sourceforge.net/cvs/?group_id=99943
# Then copy src/feedvalidator and src/rdflib into a Python lib directory.
# Finally, copy src/demo.py into your path as 'feedvalidator', make it executable,
# and change the first line to something like '#!/usr/bin/python'.

if($validator_installed == nil)
  $validator_installed = false
  begin
    IO.popen("feedvalidator 2> /dev/null","r") do |pipe|
      if (pipe.read =~ %r{Validating http://www.intertwingly.net/blog/index.})
        puts "Using locally installed Python feed validator"
        $validator_installed = true
      end
    end
  rescue
    nil
  end
end

# Re-raise errors caught by the controller.
class XmlController; def rescue_action(e) raise e end; end

class XmlControllerTest < Test::Unit::TestCase
  fixtures :contents, :categories, :articles_categories, :tags,
    :articles_tags, :users, :blogs, :resources

  def setup
    @controller = XmlController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new

    Article.create!(:title => "News from the future!",
                    :body => "The future is cool!",
                    :keywords => "future",
                    :created_at => Time.now + 12.minutes)
  end

  def assert_feedvalidator(rss, todo=nil)
    return unless $validator_installed

    begin
      file = Tempfile.new('typo-feed-test')
      filename = file.path
      file.write(rss)
      file.close

      messages = ''

      IO.popen("feedvalidator file://#{filename}") do |pipe|
        messages = pipe.read
      end

      okay, messages = parse_validator_messages(messages)

      if todo && ! ENV['RUN_TODO_TESTS']
        assert !okay, messages + "\nTest unexpectedly passed!\nFeed text:\n"+rss
      else
        assert okay, messages + "\nFeed text:\n"+rss
      end
    end
  end

  def parse_validator_messages(message)
    messages=message.split(/\n/).reject do |m|
      m =~ /Feeds should not be served with the "text\/plain" media type/ ||
      m =~ /Self reference doesn't match document location/
    end

    if(messages.size > 1)
      [false, messages.join("\n")]
    else
      [true, ""]
    end
  end

  def test_feed_rss20
    get :feed, :format => 'rss20', :type => 'feed'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body, :todo

    assert_rss20(7)
  end

  def test_feed_rss20_comments
    get :feed, :format => 'rss20', :type => 'comments'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body

    assert_rss20(3)
  end

  def test_feed_rss20_trackbacks
    get :feed, :format => 'rss20', :type => 'trackbacks'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body

    assert_rss20(2)
  end

  def test_feed_rss20_article
    get :feed, :format => 'rss20', :type => 'article', :id => 1
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body, :todo

    assert_rss20(2)
  end

  def test_feed_rss20_category
    get :feed, :format => 'rss20', :type => 'category', :id => 'personal'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body, :todo

    assert_rss20(3)
  end

  def test_feed_rss20_tag
    get :feed, :format => 'rss20', :type => 'tag', :id => 'foo'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body, :todo

    assert_rss20(2)
  end

  def test_feed_atom10_feed
    get :feed, :format => 'atom10', :type => 'feed'

    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body

    assert_equal(assigns(:items).sort { |a, b| b.created_at <=> a.created_at },
                 assigns(:items))

    assert_atom10(7)
  end

  def test_feed_atom10_comments
    get :feed, :format => 'atom10', :type => 'comments'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body

    assert_equal(assigns(:items).sort { |a, b| b.created_at <=> a.created_at },
                 assigns(:items))

    assert_atom10(3)

    assert_xpath('//title[@type="html"]')
  end

  def test_feed_atom10_trackbacks
    get :feed, :format => 'atom10', :type => 'trackbacks'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body

    assert_equal(assigns(:items).sort { |a, b| b.created_at <=> a.created_at },
                 assigns(:items))

    assert_atom10(2)

    assert_xpath('//title[@type="html"]')
    assert_xpath('//summary', "Trackback entry has no summaries")
  end

  def test_feed_atom10_article
    get :feed, :format => 'atom10', :type => 'article', :id => 1
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body

    assert_equal(assigns(:items).sort { |a, b| b.created_at <=> a.created_at },
                 assigns(:items))

    assert_atom10(2)
  end

  def test_feed_atom10_category
    get :feed, :format => 'atom10', :type => 'category', :id => 'personal'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body

    assert_equal(assigns(:items).sort { |a, b| b.created_at <=> a.created_at },
                 assigns(:items))

    assert_atom10(3)
  end

  def test_feed_atom10_tag
    get :feed, :format => 'atom10', :type => 'tag', :id => 'foo'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body

    assert_equal(assigns(:items).sort { |a, b| b.created_at <=> a.created_at },
                 assigns(:items))

    assert_atom10(2)
  end

  def test_articlerss
    get :articlerss, :id => 1
    assert_response :redirect
  end

  def test_commentrss
    get :commentrss, :id => 1
    assert_response :redirect
  end

  def test_trackbackrss
    get :trackbackrss, :id => 1
    assert_response :redirect
  end

  def test_bad_format
    get :feed, :format => 'atom04', :type => 'feed'
    assert_response :missing
  end

  def test_bad_type
    get :feed, :format => 'rss20', :type => 'foobar'
    assert_response :missing
  end

  def test_pubdate_conformance
    get :feed, :format => 'rss20', :type => 'feed'
    assert_response :success
    xml = REXML::Document.new(@response.body)
    assert_equal contents(:article2).created_at.rfc822, REXML::XPath.match(xml, '/rss/channel/item[title="Article 2!"]/pubDate').first.text
  end

  def test_rsd
    get :rsd, :id => 1
    assert_response :success
    assert_nothing_raised do
      assert REXML::Document.new(@response.body)
    end
  end

  def test_extended_rss20
    set_extended_on_rss true
    get :feed, :format => 'rss20', :type => 'feed'
    assert_response :success
    assert_match /extended content/, @response.body

    set_extended_on_rss false
    get :feed, :format => 'rss20', :type => 'feed'
    assert_response :success
    assert_no_match /extended content/, @response.body
  end

  def test_atom03
    get :feed, :format => 'atom03', :type => 'feed'
    assert_response :redirect
    assert_redirected_to :format => 'atom'
  end

  def test_extended_atom10
    set_extended_on_rss true
    get :feed, :format => 'atom10', :type => 'feed'
    assert_response :success
    assert_match /extended content/, @response.body
    assert_not_equal 0, get_xpath(%{//summary]}).size, "Extended feed has no summaries"
    assert_not_equal 0, get_xpath(%{//content]}).size, "Extended feed has no content"

    set_extended_on_rss false
    get :feed, :format => 'atom10', :type => 'feed'
    assert_response :success
    assert_no_match /extended content/, @response.body
    assert_not_equal 0, get_xpath(%{//summary]}).size, "Non-Extended feed has no summaries"
    assert_equal 0, get_xpath(%{//content]}).size, "Non-extended feed has content"
  end

  def test_xml_atom10
    get :feed, :format => 'atom10', :type => 'feed'
    assert_response :success

    # titles are escaped html
    assert_xpath('//entry/title[text()="Associations aren\'t :dependent =&amp;gt; true anymore" and @type="html"]')

    # categories are well formed
    assert_match /this &amp; that/, @response.body
  end

  def test_enclosure_rss20
    get :feed, :format => 'rss20', :type => 'feed'
    assert_response :success

    # There's an enclosure in there somewhere
    assert_xpath('/rss/channel/item/enclosure')

    # There's an enclosure attached to the node with the title "Article 1!"
    assert_xpath('/rss/channel/item[title="Article 1!"]/enclosure')
    assert_xpath('/rss/channel/item[title="Article 2!"]/enclosure')

    # Article 3 exists, but has no enclosure
    assert_xpath('/rss/channel/item[title="Article 3!"]')
    assert_not_xpath('/rss/channel/item[title="Article 3!"]/enclosure')
  end

  def test_enclosure_atom10
    get :feed, :format => 'atom10', :type => 'feed'
    assert_response :success

    # There's an enclosure in there somewhere
    assert_xpath('/feed/entry/link[@rel="enclosure"]')

    # There's an enclosure attached to "Article 1!" with a length
    assert_xpath('/feed/entry[title="Article 1!"]/link[@rel="enclosure" and @length]')

    # There's an enclosure attached to "Article 2!" with no length
    assert_xpath('/feed/entry[title="Article 2!"]/link[@rel="enclosure" and not(@length)]')

    # Article 3 exists, but has no enclosure
    assert_xpath('/feed/entry[title="Article 3!"]')
    assert_not_xpath('/feed/entry[title="Article 3!"]/link[@rel="enclosure"]')
  end

  def test_itunes
    get :itunes
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body, :todo
  end

  # TODO(laird): make this more robust
  def test_sitemap
    get :feed, :format => 'googlesitemap', :type => 'sitemap'

    assert_response :success
    assert_xml @response.body
  end

  def assert_rss20(items)
    assert_equal 1, get_xpath(%{/rss[@version="2.0"]/channel[count(child::item)=#{items}]}).size, "RSS 2.0 feed has wrong number of channel/item nodes"
  end

  def assert_atom10(entries)
    assert_equal 1, get_xpath(%{/feed[@xmlns="http://www.w3.org/2005/Atom" and count(child::entry)=#{entries}]}).size, "Atom 1.0 feed has wrong number of feed/entry nodes"
  end

  def set_extended_on_rss(value)
    this_blog.show_extended_on_rss = value
  end
end
