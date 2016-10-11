class Post < ActiveRecord::Base
  belongs_to :blog
  has_and_belongs_to_many :categories  
  validates_presence_of :blog_id, :title, :body
  
  def to_param
    "#{id}-#{title.gsub(/[^a-z1-9]+/i, '-')}"
  end  
  
end
