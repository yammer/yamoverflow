Yamoverflow::Application.routes.draw do

  get "add/:thread_id", :to => 'questions#new'

  resources :questions do
  	member do
  		get :thread
      get :refresh
  	end
  end


  get "sessions/create"
  get "sessions/destroy", :as => :destroy_session
  get '/auth/yammer/callback', :to => 'sessions#create'
  root to: "home#index"
end
