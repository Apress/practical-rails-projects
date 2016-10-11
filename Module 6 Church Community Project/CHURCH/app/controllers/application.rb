class ApplicationController < ActionController::Base
  session :session_key => '_church_session_id'
  include AuthenticatedSystem
  before_filter :get_user
  
    
  protected
  def get_user
    if !(@user = User.find_by_login(params[:user]))
      redirect_to :controller => 'welcome', :action => 'search'
    end 
  end
end
