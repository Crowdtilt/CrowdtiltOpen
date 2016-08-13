# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :referral_code do
    email "MyText"
    code "MyText"
    comment "MyText"
  end
end
