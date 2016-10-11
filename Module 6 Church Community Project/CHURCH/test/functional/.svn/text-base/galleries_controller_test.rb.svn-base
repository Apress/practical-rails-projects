require File.dirname(__FILE__) + '/../test_helper'
require 'galleries_controller'

# Re-raise errors caught by the controller.
class GalleriesController; def rescue_action(e) raise e end; end

class GalleriesControllerTest < Test::Unit::TestCase
  fixtures :galleries

  def setup
    @controller = GalleriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:galleries)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_gallery
    old_count = Gallery.count
    post :create, :gallery => { }
    assert_equal old_count+1, Gallery.count
    
    assert_redirected_to gallery_path(assigns(:gallery))
  end

  def test_should_show_gallery
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_gallery
    put :update, :id => 1, :gallery => { }
    assert_redirected_to gallery_path(assigns(:gallery))
  end
  
  def test_should_destroy_gallery
    old_count = Gallery.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Gallery.count
    
    assert_redirected_to galleries_path
  end
end
