class SessionsController < ApplicationController
  skip_before_filter :require_session

  def create
    auth = request.env['omniauth.auth']
    auth_token = auth[:credentials][:token]
    info = auth[:info]

    user = User.find_by_auth_token(auth_token)
    unless user
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
