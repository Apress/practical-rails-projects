require File.dirname(__FILE__) + '/../test_helper'

class ConfigurationTest < Test::Unit::TestCase
  fixtures :blogs

  def test_booleans
    assert  this_blog.sp_global?
    assert  this_blog.sp_allow_non_ajax_comments?
    assert  this_blog.default_allow_comments?
    assert !this_blog.default_allow_pings?

    assert TrueClass === this_blog.sp_global
    assert String    === this_blog.blog_name
    assert Fixnum    === this_blog.limit_rss_display
  end

  def test_is_ok
    assert this_blog.is_ok?
  end

end
