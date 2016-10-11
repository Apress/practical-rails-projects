class Result < ActiveRecord::Base
  belongs_to :goal
  validates_presence_of :date, :value
  after_create :update_last_result
  
  def update_last_result
    goal.last = value
    goal.save
  end
end
