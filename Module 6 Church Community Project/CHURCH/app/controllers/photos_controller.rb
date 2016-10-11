class PhotosController < ApplicationController
  def index
    @photos = Photo.find(:all)
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def new
    @photo = Photo.new
  end

  def edit
    @photo = Photo.find(params[:id])
  end

  def create
    @photo = Photo.new(params[:photo])
    if @photo.save
      redirect_to gallery_url(:user => current_user.login, :id => @photo.gallery_id)
    else
      render :action => "new" 
    end
  end

  def update
    @photo = Photo.find(params[:id])
    if @photo.update_attributes(params[:photo])
      redirect_to photo_url(@photo)
    else
      render :action => "edit"
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    redirect_to galleries_url(:user => @user.login)
  end
  
  def addcomment
    photo = Photo.find(params[:id])
    comment = Comment.new(params[:comment])
    post.add_comment comment
    redirect_to photo_path(:user => params[:user], :id => photo)
  end  
end
