
FactoryGirl.define do

  factory :user do
    email 'example@gmail.com'
    #username 'example'
    password '12345'
    password_confirmation '12345'
  end
end