class SessionsController < ApplicationController

	def new
		srand
		session[:state] ||= Digest::MD5.hexdigest(rand.to_s)

		@vk_url = VkontakteApi.authorization_url(display: 'popup', 
												 scope: [:friends, :groups, :offline, :notify, :photos],
												 state: session[:state])
		redirect_to @vk_url
	end
	
	def callback
		if session[:state].present? && session[:state] != params[:state]
		redirect_to root_url
		flash[:danger] = "Ошибка авторизацииб попробуйте еще раз."
		else
		@vk = VkontakteApi.authorize(code: params[:code])
		session[:token] = @vk.token
		session[:vk_id] = @vk.user_id
		cookies.permanent[:token] = @vk.token
		redirect_to root_url
		end
	end

	def destroy
		session[:token] = nil
		session[:vk_id] = nil
		cookies[:token] = nil

		redirect_to root_url
	end

end