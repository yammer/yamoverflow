class HomeController < ApplicationController
	skip_before_filter :require_session
	
  def index
  end
end
