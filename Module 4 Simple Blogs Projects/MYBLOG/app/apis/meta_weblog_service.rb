module MetaWeblogStructs
  class Post < ActionWebService::Struct
    member :postid, :string
    member :title,  :string
    member :link, :string
    member :dateCreated, :time    
    member :description, :string
    member :categories, [:string]
  end  
  
  class MediaObject < ActionWebService::Struct
    member :bits, :string
    member :name, :string
    member :type, :string
  end

  class Url < ActionWebService::Struct
    member :url, :string
  end  
end

class MetaWeblogApi < ActionWebService::API::Base
  inflect_names false
  api_method :getCategories,
    :expects => [{:blogid => :string}, {:username => :string}, {:password => :string}],
    :returns => [[:string]]

  api_method :newPost,
    :expects => [
      {:blogid => :string},
      {:username => :string},
      {:password => :string},
      {:content => MetaWeblogStructs::Post},
      {:publish => :bool}
      ],
    :returns => [:string]
    
  api_method :getPost,
    :expects => [{:postid => :string}, {:username => :string}, {:password => :string}],
    :returns => [MetaWeblogStructs::Post]
    
  api_method :getRecentPosts,
    :expects => [{:blogid => :string}, {:username => :string}, {:password => :string}, {:numberOfPosts => :int}],
    :returns => [[MetaWeblogStructs::Post]]

  api_method :editPost,
    :expects => [ {:postid => :string}, {:username => :string}, {:password => :string}, {:struct => MetaWeblogStructs::Post}, {:publish => :int} ],
    :returns => [:bool]

  api_method :newMediaObject,
    :expects => [ {:blogid => :string}, {:username => :string}, {:password => :string}, {:data => MetaWeblogStructs::MediaObject} ],
    :returns => [MetaWeblogStructs::Url]
end

class MetaWeblogService < ActionWebService::Base
  web_service_api MetaWeblogApi

  def getCategories(blogid, username, password)
    if Blog.authenticate(username, password)
      Category.find(:all).collect { |c| c.name }
    end
  end
    
  def newPost(blogid, username, password, content, publish)
    if Blog.authenticate(username, password)
      p = Post.new(:blog_id => blogid, :title => content['title'], :body => content['description'])
      if content['categories']
        p.categories.clear
        Category.find(:all).each do |c|
          p.categories << c if content['categories'].include?(c.name)
        end
      end
      p.save ? p.id.to_s : 'Error: Post cannot be created'
    end
  end
    
  def getPost(postid, username, password)
    if Blog.authenticate(username, password)      
      post = Post.find(postid)
      buildPost(post)
    end
  end

  def getRecentPosts(blogid, username, password, numberOfPosts)
    if Blog.authenticate(username, password)      
      Post.find(:all, :order => 'created_at desc', :limit => numberOfPosts).collect do |p|
        buildPost(p)
      end
    end
  end  

  def editPost(postid, username, password, content, publish)
    if Blog.authenticate(username, password)          
      post = Post.find(postid)
      post.attributes = {:body => content['description'].to_s, :title => content['title'].to_s}

      if content['categories']
        post.categories.clear
        Category.find(:all).each do |c|
          post.categories << c if content['categories'].include?(c.name)
        end
      end
      post.save
      true
    end
  end

  def newMediaObject(blogid, username, password, data)
    image = Image.create(:name => data['name'], :extension => data['name'].split('.').last.downcase)
    image.save_file(data['bits'])
    MetaWeblogStructs::Url.new("url" => image.url)
  end    
  
  
  def buildPost(post)
    MetaWeblogStructs::Post.new(
      :dateCreated => post.created_at || '',
      :postid => post.id.to_s,
      :description => post.body,
      :title => post.title,
      :categories => post.categories.collect { |c| c.name })
  end
end
