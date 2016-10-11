ActionController::Routing::Routes.draw do |map|
  map.home '', :controller => 'welcome', :action => 'index'  
  map.resources :sessions
  map.login  '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.directory '/directory/:char', :controller => 'welcome', :action => 'directory', :char => 'A'
  
  map.showuser  ":user", :controller => 'profile', :action => 'index'
  map.showprofile  ":user/profile", :controller => 'profile', :action => 'show'  
  map.editprofile  ":user/profile/edit", :controller => 'profile', :action => 'edit'
  map.updateprofile  ":user/profile/update", :controller => 'profile', :action => 'update'  
  map.addavatar    ":user/avatar/create", :controller => 'avatar', :action => 'create'
  map.resources :posts, :path_prefix => ":user",:member => { :addcomment => :post }
  map.resources :galleries, :path_prefix => ":user",:member => { :addcomment => :post } 
  map.resources :photos, :path_prefix => ":user"
end
