class PagesController < ApplicationController

	def index
	end

	def home
	end

	def search
		search = params[:search]
		vk = VkontakteApi::Client.new(session[:token])
		$search_friends = vk.friends.search(q: search, fields: [:screen_name, :name, :photo])
		respond_to do |format|
			format.js
		end	
	end

	def show
		session[:token] = cookies[:token] if !session[:token].present?
		vk = VkontakteApi::Client.new(session[:token])
		friend_id = params[:id]
		@friend = vk.users.get(uid: friend_id, fields: [:screen_name, :name, :photo])
		@friend_photos = vk.photos.get(owner_id: friend_id, album_id: 'saved', rev: 1)
		@albums = vk.photos.getAlbums(owner_id: friend_id, need_system: 1)
		items = @albums.items
			items.each do |item|
				@check = true if item.has_value?(-15)
			end
	end

end
