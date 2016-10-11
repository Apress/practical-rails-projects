class Post < ActiveRecord::Base
  set_table_name 'News'
  set_primary_key :NewsID  
  
  has_and_belongs_to_many :games, :join_table => "GameNews", :foreign_key => "NewsID", :association_foreign_key => 'GameID'
  order_by "created_at DESC"
  
  validates_presence_of :Headline, :Body
  validates_length_of :FrontPage, :within => 1..26, :on => :create, :message => "must be present"
end
