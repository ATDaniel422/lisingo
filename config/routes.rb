require 'sidekiq/web'

Rails.application.routes.draw do
#  root to: "application#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    mount Sidekiq::Web => '/sidekiq'
    root to: 'home#index'
    post 'search_bar', to: 'application#search_bar'
end
