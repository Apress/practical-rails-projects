class Genre < ActiveRecord::Base
  set_table_name 'Genres'
  set_primary_key :GenreID
  order_by "TYPE"
  has_many :games, :foreign_key => "GenreID"
  validates_length_of :TYPE, :within => 1..16
end
