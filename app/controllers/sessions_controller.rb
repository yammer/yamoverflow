# Copyright (c) Microsoft Corporation
# All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# THIS CODE IS PROVIDED *AS IS* BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION ANY IMPLIED WARRANTIES OR CONDITIONS OF TITLE, FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABLITY OR NON-INFRINGEMENT. 
#
# See the Apache Version 2.0 License for specific language governing permissions and limitations under the License. 
#

class SessionsController < ApplicationController
  skip_before_filter :require_session

  def create
    auth = request.env['omniauth.auth']
    auth_token = auth[:credentials][:token]
    info = auth[:info]

    user = User.find_by_auth_token(auth_token)

    unless user
      if auth[:extra][:raw_info][:network_id] != 107
        flash[:error] = "Sorry but access is limited to users of the Microsoft Network"
        redirect_to root_url
      end
      
      user = User.create!(auth_token: auth_token,
                          name: info[:name],
                          permalink: info[:nickname],
                          mugshot_url: info[:image],
                          profile_url: info[:urls][:yammer])
    end
    session[:user_id] = user.id
    flash[:notice] = "Signed In!"

    redirect_to_stored_location(root_url)
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end

end
