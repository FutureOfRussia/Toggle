module ApplicationHelper
def full_title(page_title)
		base_title = "Toggle"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
end

def log_in?
	cookies[:token].present? || session[:token].present?
end

end
