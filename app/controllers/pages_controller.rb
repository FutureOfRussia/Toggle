class PagesController < ApplicationController

	def index
	end

	def home
		if log_in?
			init_user
		end
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
		if !$current_user.present?
			init_user 
		else
			vk = VkontakteApi::Client.new(session[:token])
		end

		friend_id = params[:id]
		@friend = vk.users.get(uid: friend_id, fields: [:screen_name, :name, :photo])
		@friend_albums = vk.photos.getAlbums(owner_id: friend_id, need_system: 1)
		
		if check_saved?
			@friend_photos = vk.photos.get(owner_id: friend_id, album_id: 'saved') if check_saved?
		else
			@saved_error = 1
		end

	end

	private

	def check_saved?
		@items = @friend_albums.items
		@items.include?(id: -15)
	end 

	def init_user
		session[:token] = cookies[:token] if !session[:token].present?
		vk = VkontakteApi::Client.new(session[:token])
		$current_user = vk.users.get(uid: session[:vk_id], 
										fields: [:screen_name, :photo, :counters]).first
		$friends = vk.friends.get(order: 'random', fields: [:screen_name, :name, :photo])
		$photos = vk.photos.get(uid: session[:vk_id], album_id: 'saved')
	end
end
