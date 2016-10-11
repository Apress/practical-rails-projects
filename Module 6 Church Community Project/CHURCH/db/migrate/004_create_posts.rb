class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.column :user_id, :integer
      t.column :headline, :string
      t.column :body, :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :posts
  end
end
