class PagesController < ApplicationController

	def index
	end

	def home
		if log_in?
			session[:token] = cookies[:token] if !session[:token].present?
			@vk = VkontakteApi::Client.new(session[:token])
			init_user
		end
	end

	def search
		search = params[:search]
		@vk = VkontakteApi::Client.new(session[:token])
		$search_friends = @vk.friends.search(q: search, fields: [:screen_name, :name, :photo])
		respond_to do |format|
			format.js
		end	
	end

	def show
		session[:token] = cookies[:token] if !session[:token].present?
		@vk = VkontakteApi::Client.new(session[:token])

		init_user if !$current_user.present?

		friend_id = params[:id]
		@friend = @vk.users.get(uid: friend_id, fields: [:screen_name, :name, :photo])
		@friend_albums = @vk.photos.getAlbums(owner_id: friend_id, need_system: 1)
		
		check_saved(@friend_albums, @check_s)
		if @check_s.present?
			@friend_photos = @vk.photos.get(owner_id: friend_id, album_id: 'saved')
		else
			@saved_error = true
		end

	end

	private

	def init_user
		$current_user = @vk.users.get(uid: session[:vk_id], 
										fields: [:screen_name, :photo, :counters]).first
		$friends = @vk.friends.get(order: 'random', fields: [:screen_name, :name, :photo])
		check_friends
		$photos = @vk.photos.get(uid: session[:vk_id], album_id: 'saved')

	end

	def check_saved(albums, check)
		@items = albums.items
		@items.each do |item|
			check = true if item.has_value?(-15)
		end
	end 

	def check_friends
		$friends.items.each do |item|
			friend_id = item.id
			@albums = @vk.photos.getAlbums(owner_id: friend_id, need_system: 1)
			check_saved(@albums, @check_f)
			item.check = true if @check_f.present?
		end
	end

end
