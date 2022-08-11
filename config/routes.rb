# == Route Map
#

Rails.application.routes.draw do
  root 'static_pages#home'
  get 'terms', to: 'static_pages#terms'
  get 'privacy', to: 'static_pages#privacy'
  get 'contact', to: 'static_pages#contact'

  post 'oauth/:provider/callback', to: 'oauths#callback'
  get 'oauth/:provider/callback', to: 'oauths#callback' # for use with Github, Facebook
  get 'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider
  get 'login', to: 'user_sessions#new'
  delete 'logout', to: 'user_sessions#destroy'
end
