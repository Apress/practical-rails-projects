class Plugins::Sidebars::RecentPostsController < Sidebars::ComponentPlugin
  display_name "Recent posts"
  description "Displays the most recent posts"

  setting :count,   7, :label => "Number of Posts"

  def content
     @recent_articles = Article.find(:all, :limit => count, 
                          :conditions => ['published = ?', true],
                          :order => 'created_at DESC')
  end
end
