Yamoverflow::Application.routes.draw do

  get "add/:thread_id", :to => 'questions#new'

  resources :questions


  get "sessions/create"
  get '/auth/yammer/callback', :to => 'sessions#create'
  root to: "home#index"
end
