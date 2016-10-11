require File.dirname(__FILE__) + '/../test_helper'
require 'activities_controller'

# Re-raise errors caught by the controller.
class ActivitiesController; def rescue_action(e) raise e end; end

class ActivitiesControllerTest < Test::Unit::TestCase
  fixtures :activities

  def setup
    @controller = ActivitiesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:activities)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_activity
    old_count = Activity.count
    post :create, :activity => { }
    assert_equal old_count+1, Activity.count
    
    assert_redirected_to activity_path(assigns(:activity))
  end

  def test_should_show_activity
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_activity
    put :update, :id => 1, :activity => { }
    assert_redirected_to activity_path(assigns(:activity))
  end
  
  def test_should_destroy_activity
    old_count = Activity.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Activity.count
    
    assert_redirected_to activities_path
  end
end
