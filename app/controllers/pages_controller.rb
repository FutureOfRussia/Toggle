class PagesController < ApplicationController

	def index
	end

	def home
		if log_in?
			session[:token] = cookies[:token] if !session[:token].present?
			vk = VkontakteApi::Client.new(session[:token])
			@current_user = vk.users.get(uid: session[:vk_id], 
										 fields: [:screen_name, :photo, :counters]).first
			@friends = vk.friends.get(order: 'random', fields: [:screen_name, :name, :photo])
			@photos = vk.photos.get(uid: session[:vk_id], album_id: 'saved', rev: 1)
		end
	end

	def search
		if log_in?
			search = params[:search]
			vk = VkontakteApi::Client.new(session[:token])
			@search_friends = vk.friends.search(q: search, fields: [:screen_name, :name, :photo])
			respond_to do |format|
				format.js
			end	
		else
			redirect_to root_url
		end

	end

	def show
		if log_in?
			session[:token] = cookies[:token] if !session[:token].present?
			vk = VkontakteApi::Client.new(session[:token])
			friend_id = params[:id]
			@friend = vk.users.get(uid: friend_id, fields: [:screen_name, :name, :photo])
			albums = vk.photos.getAlbums(owner_id: friend_id, need_system: 1)
			items = albums.items
				items.each do |item|
					@check = 1 if item.has_value?(-15)
				end
			if @check.present?
				@friend_photos = vk.photos.get(owner_id: friend_id, album_id: 'saved', rev: 1)
			else
				redirect_to root_url
				flash[:danger] = "Пользователь ограничил доступ к фотографиям."
			end
		else
			redirect_to root_url
		end
	end
end
