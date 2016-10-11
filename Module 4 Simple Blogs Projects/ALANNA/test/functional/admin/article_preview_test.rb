require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/content_controller'
require 'http_mock'

class Admin::ContentController; def rescue_action(e) raise e end; end

class Admin::ArticlePreviewTest < Test::Unit::TestCase
  fixtures :contents, :users, :categories, :resources, :text_filters, :blogs

  def setup
    @controller = Admin::ContentController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @request.session = {:user => users(:tobi)}

    @art_count = Article.find(:all).size
  end

  def assert_no_new_articles
    assert_equal @art_count, Article.find(:all).size
  end

  def test_only_title
    post :preview, 'article' => { :title => 'A title' }
    assert_response :success
    assert_rendered_file 'preview'
    assert_tag :tag => 'h4', :content => 'A title'
    assert_no_tag :tag => 'p'
    assert_no_new_articles
  end

  def test_only_body
    post :preview, :article => { :body => 'A body' }

    assert_tag :tag => 'p',
      :child => 'A body',
      :after => { :tag => 'h4', :content => nil }

    assert_no_new_articles
  end

  def test_only_extended
    post :preview, :article => { :body => 'An extension' }

    assert_tag :tag => 'p',
      :child => 'An extension',
      :after => { :tag => 'h4', :content => nil }

    assert_no_new_articles
  end

  def test_full_post
    post :preview, :article => {
      :title => 'A title', :body => 'A body',
      :extended => 'An extension' }

    assert_tag \
      :tag => 'p',
      :child => 'An extension',
      :after => {:tag => 'p', :child => 'A body',
        :after => { :tag => 'h4', :content => nil }}

    assert_no_new_articles
  end


end
