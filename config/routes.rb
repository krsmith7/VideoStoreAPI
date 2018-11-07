Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/zomg', to: 'movies#zomg'
  resources :movies, only: [:index, :show, :create]
  resources :customers, only:[:index]
  post '/rentals/check-out', to: 'rentals#checkout'
  post 'rentals/check-in', to: 'rentals#checkin'

end
