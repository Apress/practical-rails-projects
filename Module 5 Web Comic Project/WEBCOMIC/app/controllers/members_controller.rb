class MembersController < ApplicationController
  layout 'adfree'

  before_filter :verify_member
  
  caches_action :index, :webcomic  

  def index
    @comic = Comic.find(:first, :order => 'id desc')
    render :template => 'members/webcomic'
  end
  
  def webcomic
    @comic = Comic.find(params[:id])
  rescue
    @comic = Comic.find(:first, :order => 'id desc')
  end

  protected
  def verify_member
    unless member? || admin?
      redirect_to login_path
      return false      
    end    
    true
  end

end


