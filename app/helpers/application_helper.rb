module ApplicationHelper
	def full_title(page_title)
		base_title = "Toggle"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end
	
	def vk_url(user)
		"https://vk.com/#{user.screen_name}"
	end

	def full_name(user)
		"#{user.first_name} #{user.last_name}"
	end
end
