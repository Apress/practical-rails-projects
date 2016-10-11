class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.column :blog_id, :integer
      t.column :title, :string
      t.column :body, :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    
    blog = Blog.find :first
    blog.posts.create(:title => 'My Very First Blog Post', :body => 'Nothing Interesting to see here yet')
  end

  def self.down
    drop_table :posts
  end
end
