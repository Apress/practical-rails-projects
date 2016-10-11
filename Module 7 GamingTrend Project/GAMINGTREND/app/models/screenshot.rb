class Screenshot < ActiveRecord::Base
  set_primary_key :shotID
  belongs_to :game, :foreign_key => 'GameID'
end
