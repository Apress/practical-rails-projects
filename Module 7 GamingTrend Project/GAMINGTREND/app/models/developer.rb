class Developer < ActiveRecord::Base
  set_table_name 'Developers'
  set_primary_key :DevID
  has_many :games, :foreign_key => 'DevID'  
  order_by "Name"

  validates_presence_of :Name
  validates_length_of  :Name, :maximum => 200, :message => " must be less than 200 characters" 
  validates_length_of  :URL, :maximum => 200, :message => " must be less than 200 characters" 

end
