ActionController::Routing::Routes.draw do |map|
  map.resources :games
  map.resources :publishers, :developers, :genres, :posts
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
