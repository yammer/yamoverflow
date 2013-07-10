class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    auth_token = auth[:credentials][:token]

    user = User.find_by_auth_token(auth_token)
    unless user
      user = User.create!(:auth_token => auth_token)
    end
    session[:user_id] = user.id
    redirect_to root_url, :notice => "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end

end
