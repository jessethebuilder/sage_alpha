### Users ###
User.destroy_all

User.create! email: 'jesse@anysoft.us', admin: true, password: 'password'

20.times do
  u = User.new(email: Faker::Internet.email, password: 'password')
  u.admin = Random.rand(1..2) == 1 ? true : false
  u.save!
end
