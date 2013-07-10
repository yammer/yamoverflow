Yamoverflow::Application.routes.draw do


  get "sessions/create"
  get '/auth/yammer/callback', :to => 'sessions#create'
  root to: "home#index"
end
