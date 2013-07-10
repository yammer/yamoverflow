Yamoverflow::Application.routes.draw do
  get "sessions/create"
  match '/auth/yammer/callback', :to => 'sessions#create', via: %i(get post)

  get "add/:thread_id", :to => 'questions#new'

  resources :questions


  root to: "home#index"
end
