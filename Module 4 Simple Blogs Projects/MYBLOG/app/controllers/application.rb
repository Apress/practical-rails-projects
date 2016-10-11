class ApplicationController < ActionController::Base
  session :session_key => '_myblog_session_id'
  before_filter :get_blog

  protected
  def get_blog 
    @blog = Blog.find(:first)
  end 
end
