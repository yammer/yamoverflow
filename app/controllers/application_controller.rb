# Copyright (c) Microsoft Corporation
# All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# THIS CODE IS PROVIDED *AS IS* BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION ANY IMPLIED WARRANTIES OR CONDITIONS OF TITLE, FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABLITY OR NON-INFRINGEMENT. 
#
# See the Apache Version 2.0 License for specific language governing permissions and limitations under the License. 
#

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :logged_in?

  before_filter :require_session


  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if logged_in?
  end

  def yammer_client
  	@yammer_client ||= YammerClient.new(current_user.auth_token)
  end

  def logged_in?
    !!session[:user_id]
  end

  def require_session
  	unless logged_in?
  		store_location(url_for(params.reject { |a,b| a.to_s == 'login' }))
  		flash[:error] = "You must be logged in to access this section"
      redirect_to root_url # halts request cycle
    end
  end

  def store_location(return_to = nil)
    return_to = request.fullpath if return_to.blank? && request.get?

    if return_to.present?
      expires = return_to =~ /oauth/ ? 30.minutes.from_now : 1.day.from_now
      cookies[:return_to] = { :value => return_to, :expires => expires, :httponly => false }
    end
  end

	# Redirect to the URI stored by the most recent store_location call or
  # to the passed default.
  def redirect_to_stored_location(default = nil)
    stored_location = cookies[:return_to] || default || home_url
    cookies.delete :return_to
    return redirect_to(relative_uri(stored_location))
  end

  def relative_uri(str)
    uri = begin
      URI.parse(str || '')
      rescue
        ''
      end
    relative = uri.try(:request_uri) || str
    relative = relative + '#' + uri.fragment if uri.respond_to?(:fragment) && !uri.fragment.nil?
    relative
  end
end
