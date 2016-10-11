require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/feedback_controller'
require 'comment'
require 'trackback'

# Re-raise errors caught by the controller.
class Admin::FeedbackController; def rescue_action(e) raise e end; end

class Admin::FeedbackControllerTest < Test::Unit::TestCase
  fixtures :contents, :users, :resources, :text_filters,
           :blogs, :articles_categories

  def setup
    @controller = Admin::FeedbackController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session = { :user => users(:tobi) }
  end

  def test_index
    get :index

    assert_success
    assert_rendered_file 'list'
    assert_equal Feedback.count, assigns(:feedback).size
  end

  def test_list_unconfirmed
    get :index, :confirmed => 'f'

    assert_success
    assert_rendered_file 'list'

    assert_equal(Feedback.count(['blog_id = 1 AND status_confirmed = ?', false]),
                 assigns(:feedback).size)

  end

  def test_list_spam
    get :index, :published => 'f'

    assert_success
    assert_rendered_file 'list'

    assert_equal(Feedback.count(['blog_id = 1 AND published = ?', false]),
                 assigns(:feedback).size)
  end

  def test_list_unconfirmed_spam
    get :index, :published => 'f', :confirmed => 'f'

    assert_success
    assert_rendered_file 'list'

    assert_equal(Feedback.count(['blog_id = 1 AND published = ? AND status_confirmed = ?', false, false]),
                 assigns(:feedback).size)
  end

end
