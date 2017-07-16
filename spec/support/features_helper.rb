ENV['PASSWORD'] = 'Password123!%6^^1'

def sign_in(user)
  visit '/users/sign_in'
  fill_in 'Email', with: user.email
  fill_in 'Password', with: ENV['PASSWORD']
  click_button 'Log in'
  u
end

def sign_in_admin
  u = create(:admin, password: ENV['PASSWORD'])
  sign_in(u)
end

def sign_in_user
  u = create(:user, password: ENV['PASSWORD'])
  sign_in(u)
end

def sign_in_client(client)
  u = client.user
  u.password = ENV['PASSWORD']
  u.save!
  sign_in(u)
end

def fill_in_client_min
  fill_in 'Name', with: Faker::Name.name
  fill_in 'Email', with: Faker::Internet.email
  fill_in 'Keywords', with: Faker::Lorem.words.join(',')
  # fill_in 'Phone', with: Faker::Phone.phone
  # fill_in 'Comp'
end
