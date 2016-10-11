ActionController::Routing::Routes.draw do |map|

  map.resources :goals do |goal|
    goal.resources :results
  end

  # map.resources :goals, :member => {:report => :get} do |goal|
  #   goal.resources :results
  # end

  map.resources :workouts do |workout|
    workout.resources :activities
  end

  map.resources :exercises
  map.home '', :controller => 'sessions', :action => 'new' 
  map.resources :users, :sessions 
  map.welcome '/welcome', :controller => 'sessions', :action => 'welcome'
  map.signup '/signup', :controller => 'users', :action => 'new' 
  map.login  '/login', :controller => 'sessions', :action => 'new' 
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'  
  map.connect '/sparklines', :controller => 'sparklines', :action => 'index'
end
