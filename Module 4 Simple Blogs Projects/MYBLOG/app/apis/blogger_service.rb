module BloggerStructs
  class Blog < ActionWebService::Struct
    member :url,      :string
    member :blogid,   :string
    member :blogName, :string
  end  
end

class BloggerApi < ActionWebService::API::Base
  inflect_names false

  api_method :getUsersBlogs,
    :expects => [ {:appkey => :string}, {:username => :string}, {:password => :string} ],
    :returns => [[BloggerStructs::Blog]]
  
  api_method :deletePost,
    :expects => [ {:appkey => :string}, {:postid => :string}, {:username => :string}, {:password => :string}, {:publish => :int} ],
    :returns => [:bool]    
end


class BloggerService < ActionWebService::Base
  web_service_api BloggerApi
  
  def getUsersBlogs(appkey, username, password)
    [BloggerStructs::Blog.new(
      :url      => 'http://localhost:3000',
      :blogid   => 1,
      :blogName => 'My Wonderful Blog'
    )]
  end
  
  def deletePost(appkey, postid, username, password, publish)
    if Blog.authenticate(username, password)    
      post = Post.find(postid)
      post.destroy
      true
    end
  end
  
end
