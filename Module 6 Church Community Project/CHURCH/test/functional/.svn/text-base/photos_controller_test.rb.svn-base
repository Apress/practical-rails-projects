require File.dirname(__FILE__) + '/../test_helper'
require 'photos_controller'

# Re-raise errors caught by the controller.
class PhotosController; def rescue_action(e) raise e end; end

class PhotosControllerTest < Test::Unit::TestCase
  fixtures :photos

  def setup
    @controller = PhotosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:photos)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_photo
    old_count = Photo.count
    post :create, :photo => { }
    assert_equal old_count+1, Photo.count
    
    assert_redirected_to photo_path(assigns(:photo))
  end

  def test_should_show_photo
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_photo
    put :update, :id => 1, :photo => { }
    assert_redirected_to photo_path(assigns(:photo))
  end
  
  def test_should_destroy_photo
    old_count = Photo.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Photo.count
    
    assert_redirected_to photos_path
  end
end
