class Post < ActiveRecord::Base
  acts_as_commentable
  belongs_to :user
  
  def self.recent
    find(:all, :order => 'Posts.created_at desc', :group => 'user_id', :limit => 7, :include => :user)
  end
end
