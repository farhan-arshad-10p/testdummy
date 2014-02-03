Fabricator(:user) do
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  email { Faker::Internet.email }
  password "password"
  password_confirmation "password"
  terms_of_service true
  interests(count: 1)
end
