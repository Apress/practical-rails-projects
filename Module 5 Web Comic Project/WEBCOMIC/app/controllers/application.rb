# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_newcomic_session_id'
  
  helper_method :admin?, :member?

  protected
  def admin?
    session[:password] == "my_ultra_secret_password"
  end

  def member?
    session[:password] == "lambda-lambda-lambda"
  end
  

end
