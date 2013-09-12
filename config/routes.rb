require 'constraint'

Crowdhoster::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  # These routes are only used for the 'admin' subdomain when MULTISITE_ENABLED=true. 
  # They only specify routing for the multisite splash and management admin pages. 
  constraints Constraint::MultisiteRouteAdmin.new do
    root                                       to: 'multisite/pages#index'

    scope module: :multisite do
      resources :sites, only: [:new, :create, :index], as: 'multisite_sites'
    end

    devise_for :users, { path: 'account', controllers: { registrations: 'multisite/registrations', sessions: 'multisite/sessions' } }
    devise_scope :user do
      get '/user/settings',                    to: 'multisite/registrations#edit',            as: :user_settings
    end
  end
    
  # These routes are used for MULTISITE_ENABLED=false deployments or non-admin subdomains in multisite mode.
  # They specify the routing for all Site specific pages, including the API.
  constraints Constraint::MultisiteRouteNonAdmin.new do
    # Rewrite www to non-www with a 301 Moved Permanently
    match '(*any)',                              to: redirect { |p, req| req.url.sub('www.', '') }, :constraints => { :host => /^www\./ }
    root                                         to: 'pages#index'

    # USERS
    devise_for :users, { path: 'account', controllers: { registrations: :registrations, sessions: :sessions } }
    devise_scope :user do
      get '/user/settings',                      to: 'registrations#edit',                    as: :user_settings
    end

    # ADMIN
    match '/admin',                              to: 'admin#admin_website',                   as: :admin_website
    namespace :admin do
      resources :campaigns
    end
    match '/admin/campaigns/:id/copy',           to: 'admin/campaigns#copy',                  as: :admin_campaigns_copy
    match '/admin/campaigns/:id/payments',       to: 'admin/campaigns#payments',              as: :admin_campaigns_payments
    match '/admin/bank-setup',                   to: 'admin#admin_bank_setup',                as: :admin_bank_setup
    match '/ajax/verify',                        to: 'admin#ajax_verify',                     as: :ajax_verify

    # CAMPAIGNS
    match '/:id/checkout/amount',                to: 'campaigns#checkout_amount',             as: :checkout_amount
    match '/:id/checkout/payment',               to: 'campaigns#checkout_payment',            as: :checkout_payment
    match '/:id/checkout/confirmation',          to: 'campaigns#checkout_confirmation',       as: :checkout_confirmation
    match '/:id',                                to: 'campaigns#home',                        as: :campaign_home


    namespace :api, defaults: {format: 'json'} do
      scope module: :v0  do
        resources :campaigns, only: :show do
          resources :payments, only: :index
        end
      end
    end
  end
end
