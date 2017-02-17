class PagesController < ApplicationController

	respond_to :html, :js

	def home
		if log_in?

			session[:token] = cookies[:token] if !session[:token].present?
				
			vk = VkontakteApi::Client.new(session[:token])

			@user = vk.users.get(uid: session[:vk_id], fields: [:screen_name, :photo, :counters]).first
			@friends = vk.friends.get(order: 'hints', fields: [:screen_name, :name, :photo])
			@photos = vk.photos.get(owner_id: 78141952, album_id: 'saved')

		end
	end

	def search
		@search_friends = vk.friends.search(q: session[:search], fields: [:screen_name, :name, :photo])
		respond_with
	end

	def index
	end
end
