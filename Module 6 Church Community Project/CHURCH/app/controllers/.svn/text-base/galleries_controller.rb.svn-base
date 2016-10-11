class GalleriesController < ApplicationController
  before_filter :login_required

  def index
    @galleries = @user.galleries.find(:all)
  end

  def show
    @gallery = @user.galleries.find(params[:id])
  end

  def new
    @gallery = current_user.galleries.build
  end

  def edit
    @gallery = current_user.galleries.find(params[:id])
  end

  def create
    @gallery = current_user.galleries.build(params[:gallery])
    if @gallery.save
      redirect_to gallery_url(:user => current_user.login, :id => @gallery)
    else
      render :action => "new"
    end
  end

  def update
    @gallery = current_user.galleries.find(params[:id])
    if @gallery.update_attributes(params[:gallery])
      redirect_to gallery_url(:user => current_user.login, :id => @gallery) 
    else
      render :action => "edit"
    end
    
  end

  def destroy
    @gallery = current_user.galleries.find(params[:id])
    @gallery.destroy
    redirect_to galleries_url(:user => current_user.login )
  end
end
