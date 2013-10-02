FactoryGirl.define do
  factory :reward do
    title "reward"
    description "awesome"
    delivery_date { Time.now + 30.days }
    price 10.00

    campaign
  end
end
