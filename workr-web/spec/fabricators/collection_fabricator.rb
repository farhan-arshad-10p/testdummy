Fabricator(:collection) do
  user
  name { Faker::Company.bs }
  description { Faker::Lorem.sentences(2).join }
end

