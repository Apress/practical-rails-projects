class Exercise < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :user_id
  has_many :activities
end
