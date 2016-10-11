class PostsController < ApplicationController
  in_place_edit_for :post, :Active
  make_resourceful do
    build :all
  end  

  def index
    limit =  params[:limit] || 25
    start = params[:start] || 0

    respond_to do |format|
      format.html 
      format.json {
        @posts = Post.find(:all, :limit => limit, :offset => start )
        posts_count = Post.count
        griddata = Hash.new
        griddata[:posts] = @posts.collect {|p| {:NewsID => p.NewsID, :Headline => p.Headline, :created_at => p.created_at.to_s, :Body => p.Body, :Active => p.Active}}
        griddata[:totalCount] =  posts_count
        render :text => griddata.to_json()
      }
    end
  end
  
  def associate
      @post = Post.find(params[:id])
      @post.update_attributes(@params['post'])
      redirect_to post_url(@post)
   end
  
end
