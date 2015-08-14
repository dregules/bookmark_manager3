
FactoryGirl.define do

  factory :user do
    #sequence(:email)  { |n| "example-#{n}}@random.com" }
    #email {Faker::Internet.safe_email}
    email 'example@example.com'
    password '12345'
    password_confirmation '12345'
  end
end
