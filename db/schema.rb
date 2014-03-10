# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140307205637) do

  create_table "campaigns", :force => true do |t|
    t.string   "name"
    t.datetime "expiration_date"
    t.string   "ct_campaign_id"
    t.string   "media_type",                           :default => "video",      :null => false
    t.string   "main_image_file_name"
    t.string   "main_image_content_type"
    t.integer  "main_image_file_size"
    t.datetime "main_image_updated_at"
    t.string   "video_embed_id"
    t.string   "video_placeholder_file_name"
    t.string   "video_placeholder_content_type"
    t.integer  "video_placeholder_file_size"
    t.datetime "video_placeholder_updated_at"
    t.string   "contributor_reference",                :default => "backer"
    t.string   "progress_text",                        :default => "funded"
    t.string   "primary_call_to_action_button",        :default => "Contribute"
    t.text     "primary_call_to_action_description"
    t.string   "secondary_call_to_action_button",      :default => "Contribute"
    t.text     "secondary_call_to_action_description"
    t.text     "main_content"
    t.text     "checkout_sidebar_content"
    t.text     "confirmation_page_content"
    t.text     "confirmation_email_content"
    t.string   "payment_type",                         :default => "any",        :null => false
    t.float    "min_payment_amount",                   :default => 1.0,          :null => false
    t.float    "fixed_payment_amount",                 :default => 1.0,          :null => false
    t.boolean  "apply_processing_fee",                 :default => false,        :null => false
    t.string   "tweet_text"
    t.string   "facebook_title"
    t.text     "facebook_description"
    t.string   "facebook_image_file_name"
    t.string   "facebook_image_content_type"
    t.integer  "facebook_image_file_size"
    t.datetime "facebook_image_updated_at"
    t.string   "slug"
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
    t.integer  "stats_number_of_contributions"
    t.float    "stats_raised_amount"
    t.float    "stats_tilt_percent"
    t.integer  "stats_unique_contributors"
    t.boolean  "is_expired"
    t.boolean  "is_tilted"
    t.boolean  "is_paid"
    t.boolean  "published_flag",                       :default => false,        :null => false
    t.boolean  "collect_shipping_flag",                :default => false,        :null => false
    t.string   "goal_type",                            :default => "dollars",    :null => false
    t.float    "goal_dollars",                         :default => 1.0,          :null => false
    t.integer  "goal_orders",                          :default => 1,            :null => false
    t.boolean  "production_flag",                      :default => false,        :null => false
    t.boolean  "include_rewards",                      :default => false,        :null => false
    t.string   "reward_reference",                     :default => "reward",     :null => false
    t.boolean  "collect_additional_info",              :default => false,        :null => false
    t.string   "additional_info_label"
    t.boolean  "include_comments",                     :default => false,        :null => false
    t.string   "comments_shortname"
    t.boolean  "include_rewards_claimed"
  end

  add_index "campaigns", ["slug"], :name => "index_campaigns_on_slug", :unique => true

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "faqs", :force => true do |t|
    t.text     "question"
    t.text     "answer"
    t.integer  "sort_order"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "campaign_id"
  end

  create_table "payments", :force => true do |t|
    t.string   "ct_payment_id"
    t.string   "status"
    t.integer  "amount"
    t.integer  "user_fee_amount"
    t.integer  "admin_fee_amount"
    t.string   "fullname"
    t.string   "email"
    t.string   "card_type"
    t.string   "card_last_four"
    t.string   "card_expiration_month"
    t.string   "card_expiration_year"
    t.integer  "campaign_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "address_one"
    t.string   "address_two"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "country"
    t.integer  "quantity"
    t.integer  "reward_id"
    t.text     "additional_info"
    t.string   "billing_postal_code"
    t.integer  "client_timestamp",             :limit => 8
    t.string   "ct_tokenize_request_id"
    t.string   "ct_tokenize_request_error_id"
    t.string   "ct_charge_request_id"
    t.string   "ct_charge_request_error_id"
    t.string   "ct_user_id"
  end

  create_table "rewards", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "delivery_date"
    t.integer  "number"
    t.float    "price"
    t.integer  "campaign_id"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.boolean  "visible_flag",          :default => true, :null => false
    t.string   "image_url"
    t.boolean  "collect_shipping_flag", :default => true
    t.boolean  "include_claimed"
  end

  create_table "settings", :force => true do |t|
    t.string   "site_name",                   :default => "Crowdhoster",          :null => false
    t.string   "facebook_app_id"
    t.string   "tweet_text"
    t.string   "google_id"
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
    t.boolean  "initialized_flag",            :default => false,                  :null => false
    t.string   "logo_image_file_name"
    t.string   "logo_image_content_type"
    t.integer  "logo_image_file_size"
    t.datetime "logo_image_updated_at"
    t.string   "copyright_text"
    t.string   "facebook_title"
    t.text     "facebook_description"
    t.string   "facebook_image_file_name"
    t.string   "facebook_image_content_type"
    t.integer  "facebook_image_file_size"
    t.datetime "facebook_image_updated_at"
    t.text     "homepage_content"
    t.text     "custom_css"
    t.string   "ct_sandbox_guest_id"
    t.string   "header_link_text"
    t.string   "header_link_url"
    t.string   "ct_sandbox_admin_id"
    t.string   "ct_production_admin_id"
    t.string   "ct_production_guest_id"
    t.string   "api_key"
    t.string   "reply_to_email",              :default => "team@crowdhoster.com", :null => false
    t.text     "custom_js"
    t.string   "mailgun_route_id"
    t.string   "ct_prod_api_key"
    t.string   "ct_prod_api_secret"
    t.boolean  "indexable",                   :default => true
    t.integer  "default_campaign_id"
    t.string   "phone_number"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                            :default => "",    :null => false
    t.string   "encrypted_password",               :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.string   "fullname"
    t.boolean  "admin",                            :default => false
    t.boolean  "wants_admin_payment_notification", :default => true,  :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
