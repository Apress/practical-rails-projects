class WelcomeController < ApplicationController
  skip_filter :get_user
  before_filter :login_required
  
  def index
    @posts = Post.recent
    @photos = Photo.recent
    @user = User.find(:first, :order => :random)
  end

  def directory
    @alphabet = ('A'..'Z').to_a
    @user = User.find(:first, :order => :random)
    @character = params[:char]
    @users = User.find(:all, :order => "last_name ASC", :conditions => ["last_name like ?", params[:char] + "%"])
  end

end
