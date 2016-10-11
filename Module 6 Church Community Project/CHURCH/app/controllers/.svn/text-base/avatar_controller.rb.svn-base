class AvatarController < ApplicationController
  before_filter :login_required
  
  def create
    @avatar = current_user.build_avatar(params[:avatar])
    @avatar.save
    redirect_to showprofile_path(:user => @user.login)
  end
end
