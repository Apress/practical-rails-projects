ActionController::Routing::Routes.draw do |map|
  map.home '', :controller => 'public'
  map.category '/category/:name', :controller => 'public', :action => 'category'
  map.feed '/rss', :controller => 'public', :action => 'rss'
  map.post '/:id', :controller => 'public', :action => 'show'
  
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
