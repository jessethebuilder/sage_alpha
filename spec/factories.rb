include FarmShed

FactoryGirl.define do
  sequence(:email){ |n| "test#{n}@test.com" }

  factory :user do
    email
    password { random_password }

    factory :admin do
      admin true
    end
  end

  factory :mail_image do
    mail_queue
    image 'http://localhost:3000/test.png'
  end

  factory :mail_image_request do
    client
    mail_image
    type { MailImageRequest::TYPES.sample }

    after(:build) do |mi, ev|
      mi.tracking_id = random_password if mi.type == 'forward'
    end

    factory :completed_mail_image_request do
      complete true
    end
  end

  factory :client_keyword_match do
    client
    mail_image
    keyword { Faker::Lorem.word }
  end

  factory :client do
    email
    name { Faker::Name.name }
    keywords { Faker::Lorem.words }


  end

  factory :mail_queue do

  end
end
