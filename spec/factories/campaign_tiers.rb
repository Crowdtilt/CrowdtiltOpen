# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :campaign_tier do
    campaign_id 1
    price_at_tier "9.99"
    min_users 1
  end
end
