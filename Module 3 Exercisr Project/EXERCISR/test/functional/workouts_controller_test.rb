require File.dirname(__FILE__) + '/../test_helper'
require 'workouts_controller'

# Re-raise errors caught by the controller.
class WorkoutsController; def rescue_action(e) raise e end; end

class WorkoutsControllerTest < Test::Unit::TestCase
  fixtures :workouts

  def setup
    @controller = WorkoutsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:workouts)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_workout
    old_count = Workout.count
    post :create, :workout => { }
    assert_equal old_count+1, Workout.count
    
    assert_redirected_to workout_path(assigns(:workout))
  end

  def test_should_show_workout
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_workout
    put :update, :id => 1, :workout => { }
    assert_redirected_to workout_path(assigns(:workout))
  end
  
  def test_should_destroy_workout
    old_count = Workout.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Workout.count
    
    assert_redirected_to workouts_path
  end
end
