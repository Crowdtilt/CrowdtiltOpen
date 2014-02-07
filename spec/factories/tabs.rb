# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tab do
    title "MyString"
    content "MyString"
    sort_order 1
    campaign_id 1
  end
end
