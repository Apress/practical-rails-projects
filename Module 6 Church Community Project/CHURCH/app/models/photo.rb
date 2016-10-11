class Photo < ActiveRecord::Base
  acts_as_commentable
  has_attachment :content_type => :image, 
                 :storage => :file_system, 
                 :max_size => 2.megabytes,
                 :resize_to => '640x360>',
                 :thumbnails => { :thumb => '140x105>' }
  validates_as_attachment  
  belongs_to :gallery
  belongs_to :user
  
  def self.recent
    find(:all, :order => 'Photos.created_at desc', :limit => 4, :conditions => 'parent_id is null', :group => 'galleries.user_id', :include => :gallery)
  end
end
