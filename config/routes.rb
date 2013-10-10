# Copyright (c) Microsoft Corporation
# All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# THIS CODE IS PROVIDED *AS IS* BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION ANY IMPLIED WARRANTIES OR CONDITIONS OF TITLE, FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABLITY OR NON-INFRINGEMENT. 
#
# See the Apache Version 2.0 License for specific language governing permissions and limitations under the License. 
#
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
