class Blog < ActiveRecord::Base
  has_many :posts
  validates_presence_of :name
  
  def self.authenticate(username, password)
    if username == 'eldon' && password == 'test'
      true
    else
      false
    end
  end
end
