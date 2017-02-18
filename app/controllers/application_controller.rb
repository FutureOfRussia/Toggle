class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

	if log_in?
		session[:token] = cookies[:token] if !session[:token].present?
		vk = VkontakteApi::Client.new(session[:token])
		$current_user = vk.users.get(uid: session[:vk_id], 
									 fields: [:screen_name, :photo, :counters]).first
		$friends = vk.friends.get(order: 'random', fields: [:screen_name, :name, :photo])
		$photos = vk.photos.get(uid: session[:vk_id], album_id: 'saved', rev: 1)
	end
end
