class ComicSweeper < ActionController::Caching::Sweeper
  observe Comic
  
  def after_save(comic)
    expire_cache_for(comic)
  end
  
  def after_destroy(comic)
    expire_cache_for(comic)
  end
  
  private
  def expire_cache_for(record)
    prev_version = (record.id - 1)
    expire_fragment(:controller => 'public', :action => 'index')
    expire_fragment(:controller => 'public', :action => 'webcomic', :id => record.id)
    expire_fragment(:controller => 'public', :action => 'webcomic', :id => prev_version)    
  end
    # expire_page(:controller => 'public', :action => 'index')
    # expire_page(:controller => 'public', :action => 'webcomic', :id => record.id)
    # expire_page(:controller => 'public', :action => 'webcomic', :id => prev_version)    
    # expire_action(members_url)
    # expire_action(members_webcomic_url(:id => record.id))
    # expire_action(members_webcomic_url(:id => prev_version))

end
