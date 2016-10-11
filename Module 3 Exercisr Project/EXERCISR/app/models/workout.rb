class Workout < ActiveRecord::Base
  belongs_to :user
  has_many :activities, :dependent => :destroy
  has_many :exercises, :through => :activities
  validates_presence_of :date
end
