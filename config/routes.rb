Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'pages#home'

	match '/signin', to: 'sessions#new', via: 'get'
	match '/callback', to: 'sessions#callback', via: 'get'
	match '/signout', to: 'sessions#destroy', via: 'delete'

end
