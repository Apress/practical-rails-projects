class PublicController < ApplicationController
  # caches_page :webcomic, :index

  def index
    unless read_fragment({})
      @comic = Comic.find(:first, :order => 'id desc')
    end
    render :template => 'public/webcomic'
  end
  
  def webcomic
    unless read_fragment({})
      @comic = Comic.find(params[:id])
    end
  rescue
    @comic = Comic.find(:first, :order => 'id desc')
  end
  
end
