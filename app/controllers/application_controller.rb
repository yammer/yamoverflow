class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  before_filter :require_session


  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if logged_in?
  end

  def yammer_client
  	@yamemr_client ||= Yammer::Client.new(:access_token  => current_user.auth_token)
  end

  def logged_in?
    !!session[:user_id]
  end

  def require_session
  	unless logged_in?
  		flash[:error] = "You must be logged in to access this section"
      redirect_to root_url # halts request cycle
    end
  end
end
