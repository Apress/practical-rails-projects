class CreateAvatars < ActiveRecord::Migration
  def self.up
    create_table :avatars do |t|
      t.column :user_id, :integer
      t.column :content_type, :string
      t.column :filename, :string
      t.column :size, :integer
      t.column :width, :integer
      t.column :height, :integer
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :avatars
  end
end
