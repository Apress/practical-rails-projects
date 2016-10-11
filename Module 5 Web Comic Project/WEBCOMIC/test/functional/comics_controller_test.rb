require File.dirname(__FILE__) + '/../test_helper'
require 'comics_controller'

# Re-raise errors caught by the controller.
class ComicsController; def rescue_action(e) raise e end; end

class ComicsControllerTest < Test::Unit::TestCase
  fixtures :comics

  def setup
    @controller = ComicsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:comics)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_comic
    old_count = Comic.count
    post :create, :comic => { }
    assert_equal old_count+1, Comic.count
    
    assert_redirected_to comic_path(assigns(:comic))
  end

  def test_should_show_comic
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_comic
    put :update, :id => 1, :comic => { }
    assert_redirected_to comic_path(assigns(:comic))
  end
  
  def test_should_destroy_comic
    old_count = Comic.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Comic.count
    
    assert_redirected_to comics_path
  end
end
