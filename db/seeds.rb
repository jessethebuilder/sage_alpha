t = Time.now
include FarmShed
#--- Users -----------------------
# User.destroy_all
#
# User.create! email: 'jesse@anysoft.us', admin: true, password: 'password'

#--- Clients ------------------
Client.destroy_all

112.times do
  c = Client.new first_name: Faker::Name.first_name,
                 last_name: Faker::Name.last_name,
                 email: Faker::Internet.email,
                 phone: Faker::PhoneNumber.phone_number,
                 company_name: Faker::Company.name,
                 client_number: random_password,
                 keywords: Faker::Lorem.words.join(',')

  if(Random.rand(1..5) == 1)
    c.keywords << %w|paypal national obama|.sample
  end

  c.save!
end

n = Time.now

puts (n - t)
