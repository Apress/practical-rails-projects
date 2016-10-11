require File.dirname(__FILE__) + '/../test_helper'
require 'exercises_controller'

# Re-raise errors caught by the controller.
class ExercisesController; def rescue_action(e) raise e end; end

class ExercisesControllerTest < Test::Unit::TestCase
  fixtures :exercises

  def setup
    @controller = ExercisesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:exercises)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_exercise
    old_count = Exercise.count
    post :create, :exercise => { }
    assert_equal old_count+1, Exercise.count
    
    assert_redirected_to exercise_path(assigns(:exercise))
  end

  def test_should_show_exercise
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_exercise
    put :update, :id => 1, :exercise => { }
    assert_redirected_to exercise_path(assigns(:exercise))
  end
  
  def test_should_destroy_exercise
    old_count = Exercise.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Exercise.count
    
    assert_redirected_to exercises_path
  end
end
