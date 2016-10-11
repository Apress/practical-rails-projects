require File.dirname(__FILE__) + '/../test_helper'
require 'results_controller'

# Re-raise errors caught by the controller.
class ResultsController; def rescue_action(e) raise e end; end

class ResultsControllerTest < Test::Unit::TestCase
  fixtures :results

  def setup
    @controller = ResultsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:results)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_result
    old_count = Result.count
    post :create, :result => { }
    assert_equal old_count+1, Result.count
    
    assert_redirected_to result_path(assigns(:result))
  end

  def test_should_show_result
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_result
    put :update, :id => 1, :result => { }
    assert_redirected_to result_path(assigns(:result))
  end
  
  def test_should_destroy_result
    old_count = Result.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Result.count
    
    assert_redirected_to results_path
  end
end
