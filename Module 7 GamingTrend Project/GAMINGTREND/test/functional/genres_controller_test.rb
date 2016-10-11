require File.dirname(__FILE__) + '/../test_helper'
require 'genres_controller'

# Re-raise errors caught by the controller.
class GenresController; def rescue_action(e) raise e end; end

class GenresControllerTest < Test::Unit::TestCase
  def setup
    @controller = GenresController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
