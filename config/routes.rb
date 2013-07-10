Yamoverflow::Application.routes.draw do
  get "sessions/create"
  match '/auth/yammer/callback', :to => 'sessions#create', via: %i(get post)


  root to: "home#index"
end
