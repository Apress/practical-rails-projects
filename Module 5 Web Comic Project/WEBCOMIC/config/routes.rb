ActionController::Routing::Routes.draw do |map|
  map.resources :comics, :path_prefix => '/admin'
  map.resources :sessions
  map.webcomic 'comic/:id', :controller => "public", :action => 'webcomic'
  map.home '', :controller => "public", :action => 'index'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.members 'members', :controller => 'members', :action => 'index'
  map.members_webcomic '/members/comic/:id', :controller => "members", :action => 'webcomic'
end
