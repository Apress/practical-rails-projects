class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_table :blogs do |t|
      t.column :name, :string
    end
    
    Blog.create(:name => 'My Simple Blog')
  end

  def self.down
    drop_table :blogs
  end
end
