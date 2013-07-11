class HomeController < ApplicationController
	skip_before_filter :require_session

  def index
  	redirect_to questions_url if logged_in?
  end
end
