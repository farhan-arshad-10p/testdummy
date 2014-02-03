Fabricator(:content_source) do
  url { Faker::Internet.url }
  title { Faker::Company.bs }
  description { Faker::Lorem.sentences(1).first }
  provider_url { Faker::Internet.url }
  provider_name { Faker::Internet.domain_name }
  provider_display { Faker::Internet.domain_name }
  content { Faker::Lorem.paragraphs(2).join }
  content_type { "html" }
end
