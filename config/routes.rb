# == Route Map
#
#                                   Prefix Verb   URI Pattern                                                                                       Controller#Action
#                                     root GET    /                                                                                                 static_pages#home
#                                    terms GET    /terms(.:format)                                                                                  static_pages#terms
#                                  privacy GET    /privacy(.:format)                                                                                static_pages#privacy
#                                  contact GET    /contact(.:format)                                                                                static_pages#contact
#                                          POST   /oauth/:provider/callback(.:format)                                                               oauths#callback
#                                          GET    /oauth/:provider/callback(.:format)                                                               oauths#callback
#                         auth_at_provider GET    /oauth/:provider(.:format)                                                                        oauths#oauth
#                                    login GET    /login(.:format)                                                                                  user_sessions#new
#                                   logout DELETE /logout(.:format)                                                                                 user_sessions#destroy
#                            ranking_posts GET    /posts/ranking(.:format)                                                                          posts#ranking
#                               tweet_post GET    /posts/:id/tweet(.:format)                                                                        posts#tweet
#                            post_comments POST   /posts/:post_id/comments(.:format)                                                                comments#create
#                                  comment DELETE /comments/:id(.:format)                                                                           comments#destroy
#                               post_likes POST   /posts/:post_id/likes(.:format)                                                                   likes#create
#                                     like DELETE /likes/:id(.:format)                                                                              likes#destroy
#                                    posts GET    /posts(.:format)                                                                                  posts#index
#                                          POST   /posts(.:format)                                                                                  posts#create
#                                 new_post GET    /posts/new(.:format)                                                                              posts#new
#                                     post DELETE /posts/:id(.:format)                                                                              posts#destroy
#                                     user GET    /users/:id(.:format)                                                                              users#show
#                             edit_profile GET    /profile/edit(.:format)                                                                           profiles#edit
#                                  profile PATCH  /profile(.:format)                                                                                profiles#update
#                                          PUT    /profile(.:format)                                                                                profiles#update
#                                          GET    /login_as/:user_id(.:format)                                                                      development/sessions#login_as
#            rails_postmark_inbound_emails POST   /rails/action_mailbox/postmark/inbound_emails(.:format)                                           action_mailbox/ingresses/postmark/inbound_emails#create
#               rails_relay_inbound_emails POST   /rails/action_mailbox/relay/inbound_emails(.:format)                                              action_mailbox/ingresses/relay/inbound_emails#create
#            rails_sendgrid_inbound_emails POST   /rails/action_mailbox/sendgrid/inbound_emails(.:format)                                           action_mailbox/ingresses/sendgrid/inbound_emails#create
#      rails_mandrill_inbound_health_check GET    /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#health_check
#            rails_mandrill_inbound_emails POST   /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#create
#             rails_mailgun_inbound_emails POST   /rails/action_mailbox/mailgun/inbound_emails/mime(.:format)                                       action_mailbox/ingresses/mailgun/inbound_emails#create
#           rails_conductor_inbound_emails GET    /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#index
#                                          POST   /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#create
#        new_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/new(.:format)                                      rails/conductor/action_mailbox/inbound_emails#new
#       edit_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id/edit(.:format)                                 rails/conductor/action_mailbox/inbound_emails#edit
#            rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#show
#                                          PATCH  /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#update
#                                          PUT    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#update
#                                          DELETE /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#destroy
# new_rails_conductor_inbound_email_source GET    /rails/conductor/action_mailbox/inbound_emails/sources/new(.:format)                              rails/conductor/action_mailbox/inbound_emails/sources#new
#    rails_conductor_inbound_email_sources POST   /rails/conductor/action_mailbox/inbound_emails/sources(.:format)                                  rails/conductor/action_mailbox/inbound_emails/sources#create
#    rails_conductor_inbound_email_reroute POST   /rails/conductor/action_mailbox/:inbound_email_id/reroute(.:format)                               rails/conductor/action_mailbox/reroutes#create
#                       rails_service_blob GET    /rails/active_storage/blobs/redirect/:signed_id/*filename(.:format)                               active_storage/blobs/redirect#show
#                 rails_service_blob_proxy GET    /rails/active_storage/blobs/proxy/:signed_id/*filename(.:format)                                  active_storage/blobs/proxy#show
#                                          GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                                        active_storage/blobs/redirect#show
#                rails_blob_representation GET    /rails/active_storage/representations/redirect/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations/redirect#show
#          rails_blob_representation_proxy GET    /rails/active_storage/representations/proxy/:signed_blob_id/:variation_key/*filename(.:format)    active_storage/representations/proxy#show
#                                          GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format)          active_storage/representations/redirect#show
#                       rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                                       active_storage/disk#show
#                update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                               active_storage/disk#update
#                     rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                                    active_storage/direct_uploads#create

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
  
  if Rails.env.development? || Rails.env.test?
    get '/login_as/:user_id', to: 'development/sessions#login_as' # ダミーログイン用
  end

  resources :posts, only: %i[new create index destroy], shallow: true do
    collection do
      get :ranking
    end
    member do
      get :tweet
    end
    resources :comments, only: %i[create destroy]
    resources :likes, only: %i[create destroy]
  end
  resources :users, only: %i[show]
  resource :profile, only: %i[edit update]
end
