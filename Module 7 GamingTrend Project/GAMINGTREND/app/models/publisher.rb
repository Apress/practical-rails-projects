class Publisher < ActiveRecord::Base
  set_table_name 'Publishers'
  set_primary_key :PubID
  has_many :games, :foreign_key => 'PubID'
  order_by "Name"
  validates_length_of  :Name, :maximum => 200, :message => " must be less than 200 characters" 
  validates_length_of  :URL, :maximum => 200, :message => " must be less than 200 characters" 
end
