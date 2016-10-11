class Avatar < ActiveRecord::Base
  has_attachment :content_type => :image, 
                 :storage => :file_system, 
                 :max_size => 500.kilobytes,
                 :resize_to => '110x110',
                 :thumbnails => { :comment => '50x50>' }
  validates_as_attachment
  belongs_to :user
end