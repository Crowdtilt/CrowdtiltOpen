FactoryGirl.define do
  factory :campaign do
    name "foo"
    slug "foo"

    expiration_date {Time.now + 30.days}
  end
end
