class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    render :text => "Authenticated! #{auth[:credentials][:token]}"
  end
end
