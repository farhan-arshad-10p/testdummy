Fabricator(:admin_user) do
  email { Faker::Internet.email }
  password "password"
  password_confirmation "password"
end
