class Comic < ActiveRecord::Base
  has_attachment :content_type => :image, 
                 :storage => :file_system, 
                 :max_size => 500.kilobytes,
                 :resize_to => '650x650>'

  validates_as_attachment
  validates_presence_of :title
end
