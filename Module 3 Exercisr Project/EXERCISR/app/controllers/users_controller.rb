class UsersController < ApplicationController
  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    reset_session
    @user = User.new(params[:user])
    @user.save!
    self.current_user = @user
    redirect_back_or_default(welcome_path)
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end
end
