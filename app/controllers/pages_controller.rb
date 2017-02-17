class PagesController < ApplicationController

	def home
		if log_in?

			session[:token] = cookies[:token] if !session[:token].present?
				
			vk = VkontakteApi::Client.new(session[:token])

			@user = vk.users.get(uid: session[:vk_id], fields: [:screen_name, :photo, :counters]).first
			@friends = vk.friends.get(order: 'random', fields: [:screen_name, :name, :photo])
			@photos = vk.photos.get(owner_id: 78141952, album_id: 'saved')

		end
	end

	def search
		search = params[:search]
		vk = VkontakteApi::Client.new(session[:token])
		@search_friends = vk.friends.search(q: search, fields: [:screen_name, :name, :photo])
		respond_to do |format|
			format.js
		end	
	end

	def index
	end
end
