class CreateGalleries < ActiveRecord::Migration
  def self.up
    create_table :galleries do |t|
      t.column :user_id, :integer
      t.column :name, :string
      t.column :description, :text
      t.column :created_at, :datetime
      t.column :photos_count, :integer, :default => 0
      t.column :privacy, :boolean
    end
  end

  def self.down
    drop_table :galleries
  end
end
