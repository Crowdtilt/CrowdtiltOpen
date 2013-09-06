FactoryGirl.define do 
  factory :user do
      fullname "Crowdhoster Tester"
      sequence(:email) { |n| "test#{n}@crowdhoster.com" }
      password "testPass"
      password_confirmation "testPass"
    end
  end