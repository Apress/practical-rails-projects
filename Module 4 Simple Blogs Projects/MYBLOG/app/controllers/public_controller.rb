class PublicController < ApplicationController

  def index
    @posts = @blog.posts.paginate(:per_page => 7, :page => params[:page], :order => "created_at desc")
  end

  def show
    @post = @blog.posts.find(params[:id])
  end
  
  def category
    @category = Category.find_by_name(params[:name])
    @posts = @category.posts.paginate(:per_page => 7, :page => params[:page], :conditions => ["blog_id == ?", @blog.id], :order => "created_at desc")
    render(:action => "index")
  end
  
  def rss
    @posts = @blog.posts.find(:all, :limit => 25, :order => 'created_at desc')
    render(:layout => false) 
  end
  
end
