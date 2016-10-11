class Game < ActiveRecord::Base
  set_table_name 'Games'
  set_primary_key :GameID
  belongs_to :publisher, :foreign_key => 'PubID'
  belongs_to :developer, :foreign_key => 'DevID'
  belongs_to :genre, :foreign_key => 'GenreID'
  has_many :screenshots, :foreign_key => 'GameID'
  has_and_belongs_to_many :posts, :join_table => "GameNews", :foreign_key => "GameID", :association_foreign_key => 'NewsID'

  order_by :title

  validates_length_of :Title, :maximum => 100, :message => " must be less than 100 characters" 
  validates_presence_of :Title, :Console
  
  
  def boxart
    self.BoximagePath.blank? ? "/boxshots/empty.jpg" :  self.BoximagePath
  end
  
  def homepage
    self.SiteURL || "Not Set"
  end

  def homepage=(value)
    self.SiteURL = value
  end
  
end
