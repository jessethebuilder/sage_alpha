FactoryGirl.define do
  sequence(:email){ |n| "test#{n}@test.com" }

  factory :user do
    email
    password { random_passoword }

    factory :admin do
      admin true
    end
  end
end
