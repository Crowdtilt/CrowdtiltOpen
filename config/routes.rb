Crowdhoster::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  # PAGES
  root                                         to: 'pages#index'

  # USERS
  devise_for :users, { path: 'account', controllers: { registrations: :registrations } }  do
    match '/user/settings',                    to: 'devise/registrations#edit',             as: :user_settings
  end

  # ADMIN
  match '/admin',                      to: 'admin#admin_website',                   as: :admin_website
  namespace :admin do
    resources :campaigns
    post '/payments/:id/refund',                to: 'payments#refund_payment',               as: :admin_payment_refund
  end

  match '/admin/campaigns/:id/copy',           to: 'admin/campaigns#copy',                  as: :admin_campaigns_copy
  match '/admin/campaigns/:id/payments',       to: 'admin/campaigns#payments',              as: :admin_campaigns_payments
  match '/admin/processor-setup',              to: 'admin#admin_processor_setup',           as: :admin_processor_setup
  post '/admin/bank-setup',                    to: 'admin#create_admin_bank_account',       as: :create_admin_bank_account
  get '/admin/bank-setup',                     to: 'admin#admin_bank_account',              as: :admin_bank_account
  delete '/admin/bank-setup',                  to: 'admin#delete_admin_bank_account',       as: :delete_admin_bank_account
  match '/admin/notification-setup',           to: 'admin#admin_notification_setup',        as: :admin_notification_setup
  match '/ajax/verify',                        to: 'admin#ajax_verify',                     as: :ajax_verify

  # CAMPAIGNS
  match '/:id/checkout/amount',                to: 'campaigns#checkout_amount',             as: :checkout_amount
  match '/:id/checkout/payment',               to: 'campaigns#checkout_payment',            as: :checkout_payment
  match '/:id/checkout/process',               to: 'campaigns#checkout_process',            as: :checkout_process
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
