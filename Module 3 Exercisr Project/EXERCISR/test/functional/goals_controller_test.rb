require File.dirname(__FILE__) + '/../test_helper'
require 'goals_controller'

# Re-raise errors caught by the controller.
class GoalsController; def rescue_action(e) raise e end; end

class GoalsControllerTest < Test::Unit::TestCase
  fixtures :goals

  def setup
    @controller = GoalsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:goals)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_goal
    old_count = Goal.count
    post :create, :goal => { }
    assert_equal old_count+1, Goal.count
    
    assert_redirected_to goal_path(assigns(:goal))
  end

  def test_should_show_goal
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_goal
    put :update, :id => 1, :goal => { }
    assert_redirected_to goal_path(assigns(:goal))
  end
  
  def test_should_destroy_goal
    old_count = Goal.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Goal.count
    
    assert_redirected_to goals_path
  end
end
