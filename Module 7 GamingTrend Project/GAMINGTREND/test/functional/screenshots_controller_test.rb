require File.dirname(__FILE__) + '/../test_helper'
require 'screenshots_controller'

# Re-raise errors caught by the controller.
class ScreenshotsController; def rescue_action(e) raise e end; end

class ScreenshotsControllerTest < Test::Unit::TestCase
  def setup
    @controller = ScreenshotsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
