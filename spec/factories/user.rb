FactoryGirl.define do 
  factory :user do
      fullname "Crowdhoster Tester"
      sequence(:email) { |n| "test#{n}@crowdhoster.com" }
      password "testPass"
      password_confirmation "testPass"

      trait :admin do
        admin true
        email 'admin_test@crowdhoster.com'
      end
  end
end
