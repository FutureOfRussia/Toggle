module PagesHelper
	def vk_url(user)
		"https://vk.com/#{user.screen_name}"
	end

	def full_name(user)
		"#{user.first_name} #{user.last_name}"
	end
end
