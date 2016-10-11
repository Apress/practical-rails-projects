class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.column "name", :string
      t.column "extension", :string
      t.column 'created_at', :datetime      
    end
  end

  def self.down
    drop_table :images
  end
end
