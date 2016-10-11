class CreateComics < ActiveRecord::Migration
  def self.up
    create_table :comics do |t|
      t.column :content_type, :string
      t.column :filename, :string
      t.column :size, :integer
      t.column :width, :integer
      t.column :height, :integer
      t.column :title, :string
      t.column :description, :text
    end
  end

  def self.down
    drop_table :comics
  end
end
