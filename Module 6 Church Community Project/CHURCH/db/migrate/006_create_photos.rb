class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.column :user_id, :integer
      t.column :gallery_id, :integer
      t.column :parent_id, :integer
      t.column :content_type, :string
      t.column :filename, :string
      t.column :thumbnail, :string
      t.column :size, :integer
      t.column :width, :integer
      t.column :height, :integer
      t.column :created_at, :datetime
      t.column :description, :string
    end
  end

  def self.down
    drop_table :photos
  end
end
