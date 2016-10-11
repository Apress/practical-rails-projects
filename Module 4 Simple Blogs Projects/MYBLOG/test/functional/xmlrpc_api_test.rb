require File.dirname(__FILE__) + '/../test_helper'
require 'xmlrpc_controller'

class XmlrpcController; def rescue_action(e) raise e end; end

class XmlrpcControllerApiTest < Test::Unit::TestCase
  def setup
    @controller = XmlrpcController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
end
