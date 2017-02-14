class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  helper_method :log_in? 

	def log_in?
		session[:token].present?
	end
end
