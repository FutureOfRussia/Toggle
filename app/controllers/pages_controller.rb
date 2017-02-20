class PagesController < ApplicationController

	def index
	end

	def home
		if log_in?
			if !session[:token].present?
				session[:token] = cookies[:token]
			end

			vk = VkontakteApi::Client.new(session[:token])
			$current_user = vk.users.get(user_ids: session[:vk_id], 
										 fields: [:screen_name, :photo, :counters]).first
			$friends = vk.friends.get(order: 'random', fields: [:screen_name, :name, :photo])
			$photos = vk.photos.get(uid: session[:vk_id], album_id: 'saved', rev: 1)
		end
	end

	def search
		if log_in?
			search = params[:search]
			vk = VkontakteApi::Client.new(session[:token])
			$search_friends = vk.friends.search(q: search, fields: [:screen_name, :name, :photo])
			respond_to do |format|
				format.js
			end	
		else
			redirect_to root_url
		end
	end

	def show

		if !session[:token].present?
			session[:token] = cookies[:token]
		end

		vk = VkontakteApi::Client.new(session[:token])
		friend_id = params[:id]
		@friend = vk.users.get(user_ids: friend_id, fields: [:screen_name, :name, :photo]).first
		albums = vk.photos.getAlbums(owner_id: friend_id, need_system: 1)
		items = albums.items

			items.each do |item|
				if item.has_value?(-15)
					@check = 1 
				end
			end

		if @check.present?
			@friend_photos = vk.photos.get(owner_id: friend_id, album_id: 'saved', rev: 1) 
		end

		respond_to do |format|
			format.js
		end
	end

	def back
		respond_to do |format|
			format.js
		end
	end

end
