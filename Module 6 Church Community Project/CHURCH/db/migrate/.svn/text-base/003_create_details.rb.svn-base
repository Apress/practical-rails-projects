class CreateDetails < ActiveRecord::Migration
  def self.up
    create_table :details do |t|
      t.column :user_id, :integer
      t.column :headline, :string
      t.column :about_me, :text
      t.column :like_to_meet, :text
      t.column :interests, :text
      t.column :music, :text
      t.column :movies, :text
      t.column :television, :text
      t.column :books, :text
    end
  end

  def self.down
    drop_table :details
  end
end
