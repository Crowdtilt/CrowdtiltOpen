FactoryGirl.define do
  factory :payment do
    sequence(:email) { |i| "foo+#{i}@bar.com" }
    fullname "full name"
    quantity 1
    campaign
  end
end
