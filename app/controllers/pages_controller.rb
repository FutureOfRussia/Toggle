class PagesController < ApplicationController
	def home
		if log_in?

			session[:token] = cookies[:token] if !session[:token].present?
				
			vk = VkontakteApi::Client.new(session[:token])

			@user = vk.users.get(uid: session[:vk_id], fields: [:screen_name, :photo]).first
			@friends = vk.friends.get(order: 'hints', fields: [:screen_name, :name, :photo])
			@photos = vk.photos.get(owner_id: 78141952, album_id: 'saved')

		end
	end

	def index
	end
end
