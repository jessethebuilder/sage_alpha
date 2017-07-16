FactoryGirl.define do
  sequence(:email){ |n| "test#{n}@test.com" }

  factory :user do
    email
    password { random_passoword }

    factory :admin do
      admin true
    end
  end

  factory :mail_image do
    mail_queue
    image 'xyx'
  end

  factory :mail_image_request do
    client
    mail_image
    type { MailImageRequest::TYPES.sample }

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
